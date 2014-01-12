#[crate_id="codec-image-png-decoder#1.0"];
#[feature(globs)];

extern mod system_cpu = "system-cpu";

extern mod math_round = "math-round";
extern mod zlib = "codec-data-zlib-decoder";

extern mod image_info = "image-info";

extern mod io_pass_through = "io-pass_through";
extern mod io_console      = "io-console";
extern mod io_stream       = "io-stream";
extern mod io_buffer       = "io-buffer";
extern mod io_pixelmap     = "io-pixelmap";

use std::iter;
use std::vec;

mod system {
  pub mod cpu {
    pub use system_cpu::system::cpu::*;
  }
}

mod image {
  pub mod info {
    pub use image_info::image::info::*;
  }
}

mod io {
  pub mod stream {
    pub use io_stream::io::stream::*;
  }
  pub mod console {
    pub use io_console::io::console::*;
  }
  pub mod buffer {
    pub use io_buffer::io::buffer::*;
  }
  pub mod pass_through {
    pub use io_pass_through::io::pass_through::*;
  }
  pub mod pixelmap {
    pub use io_pixelmap::io::pixelmap::*;
  }
}

pub mod codec {
  pub mod image {
    pub mod png {
      pub mod decoder {
        static INTERLACE_INCREMENTS_X:[u32,..7] = [8, 8, 4, 4, 2, 2, 1];
        static INTERLACE_INCREMENTS_Y:[u32,..7] = [8, 8, 8, 4, 4, 2, 2];

        static INTERLACE_STARTS_X:[u32,..7]     = [0, 4, 0, 2, 0, 1, 0];
        static INTERLACE_STARTS_Y:[u32,..7]     = [0, 0, 4, 0, 2, 0, 1];

        // For low bpp color conversion
        static EXPAND_1BPP:[u8,..2]  = [  0, 255];
        static EXPAND_2BPP:[u8,..4]  = [  0,  85, 170, 255];
        static EXPAND_4BPP:[u8,..16] = [  0,  17,  34,  51,  68,  85, 102,
                                        119, 136, 153, 170, 187, 204, 221,
                                        238, 255];

        enum State {
          Init,

          Invalid,
          Required,

          ReadHeader,

          ReadChunkHeader,
          ReadChunkCRC,
          SkipChunk,

          ReadIHDR,
          ReadPLTE,
          ReadIDAT,
          ReadIEND,

          ReadPLTEEntries,

          InterpretIDAT,
          FillIDAT,
          DoneIDAT,

          DecodeIDAT,
          DecodeReadFilterType,

          UnfilterNone,
          UnfilterSub,
          UnfilterUp,
          UnfilterAverage,
          UnfilterPaeth,

          Render,

          Accepted,
          Complete,
        }

        static IHDR:u32 = 0x49484452;
        static PLTE:u32 = 0x504c5445;
        static IDAT:u32 = 0x49444154;
        static IEND:u32 = 0x49454e44;

        enum ImageType {
          Grayscale1bpp       = (1 << 16) + 1,
          Grayscale2bpp       = (1 << 16) + 2,
          Grayscale4bpp       = (1 << 16) + 4,
          Grayscale8bpp       = (1 << 16) + 8,
          Grayscale16bpp      = (1 << 16) + 16,

          Truecolor8bpp       = (3 << 16) + 8,
          Truecolor16bpp      = (3 << 16) + 16,

          Indexed1bpp         = (4 << 16) + 1,
          Indexed2bpp         = (4 << 16) + 2,
          Indexed4bpp         = (4 << 16) + 4,
          Indexed8bpp         = (4 << 16) + 8,

          GrayscaleAlpha8bpp  = (5 << 16) + 8,
          GrayscaleAlpha16bpp = (5 << 16) + 16,

          TruecolorAlpha8bpp  = (7 << 16) + 8,
          TruecolorAlpha16bpp = (7 << 16) + 16,
        }

        enum FilterType {
          NoFilter,
          Sub,
          Up,
          Average,
          Paeth
        }

#[packed]
        struct PngChunkHeader {
          length: u32,
          chunkType: u32
        }

#[packed]
        struct IHDR {
          width: u32,
          height: u32,
          bitDepth: u8,
          colorType: u8,
          compressionMethod: u8,
          filterMethod: u8,
          interlaceMethod: u8,
        }

#[packed]
        struct PngColor {
          red: u8,
          green: u8,
          blue: u8
        }

        pub struct Decoder {
          // Header
          header: [u8,..8],
          chunkHeader: PngChunkHeader,

          imageInfo: ::image::info::Info,

          // IHDR chunk
          haveIHDR: bool,
          IHDR: IHDR,

          // Checksum data
          chunkCRC: u32,
          runningCRC: u32,

          // Color palette
          paletteCount: u32,
          palette: [PngColor,..256],
          paletteRealized: [u32,..256],

          decodedBuffer: ~::io::buffer::Buffer,
          decoderSource: ~::io::buffer::Buffer,

          decoder: ~::zlib::codec::data::zlib::decoder::Decoder,

          // Sampling data
          numSamples: u8,
          nsamp: u32,
          psamp: u32,

          // Current position in the image
          x: u32,
          y: u32,

          // How many bytes we have decoded
          bytesDecoded: u64,

          // The number of bytes we expect to decode
          expectedBytes: i32,

          // The image color type
          imageType: ImageType,

          // Array for holding the prior scanline's decoded bytes
          bytes: [~[u8],..8],

          // Previous line/sample information (only need prior line for desampling)
          priorScannedByte: [u8,..8],
          priorPixel: [u8,..8],
          curComponent: [u32,..8],
          priorScannedComponent: u8,

          // Width/Height of subimage
          interlaceWidths: [u32, ..7],
          interlaceHeights: [u32, ..7],

          // Current interlace pass
          interlacePass: u32,

          // Current scanline of the current pass
          interlaceCurLine: u32,

          // Decoder State
          state: State,
          filterState: State,
          currentState: State,
        }

        pub fn new() -> ~Decoder {
          ~Decoder {
            // Header
            header: [0,0,0,0,0,0,0,0],
            chunkHeader: PngChunkHeader {
              length: 0,
              chunkType: 0
            },

            imageInfo: ::image::info::Info {
              width: 0,
              height: 0,
              colorDepth: ::io::pixelmap::R8G8B8A8,
              bitsPerPixel: 0,
            },

            // IHDR chunk
            haveIHDR: false,
            IHDR: IHDR {
              width: 0,
              height: 0,
              bitDepth: 0,
              colorType: 0,
              compressionMethod: 0,
              filterMethod: 0,
              interlaceMethod: 0
            },

            // Checksum data
            chunkCRC: 0,
            runningCRC: 0,

            // Color palette
            paletteCount: 0,
            palette: [PngColor{red:0, green:0, blue:0}, ..256],
            paletteRealized: [0, ..256],

            decodedBuffer: ::io::buffer::create(),
            decoderSource: ::io::buffer::create(),

            decoder: ::zlib::codec::data::zlib::decoder::new(),

            // Sampling data
            numSamples: 0,
            nsamp: 0,
            psamp: 0,

            // Current position in the image
            x: 0,
            y: 0,

            // How many bytes we have decoded
            bytesDecoded: 0,

            // The number of bytes we expect to decode
            expectedBytes: 0,

            // The image color type
            imageType: Grayscale1bpp,

            // Array for holding the prior scanline's decoded bytes
            bytes: [~[],~[],~[],~[],~[],~[],~[],~[]],

            // Previous line/sample information (only need prior line for desampling)
            priorScannedByte: [0,0,0,0,0,0,0,0],
            priorPixel: [0,0,0,0,0,0,0,0],
            curComponent: [0,0,0,0,0,0,0,0],
            priorScannedComponent: 0,

            // Width/Height of subimage
            interlaceWidths: [0,0,0,0,0,0,0],
            interlaceHeights: [0,0,0,0,0,0,0],

            // Current interlace pass
            interlacePass: 0,

            // Current scanline of the current pass
            interlaceCurLine: 0,

            // Decoder State
            state: Init,
            filterState: Init,
            currentState: Init,
          }
        }

        impl Decoder {
          pub fn info(&mut self, input: &mut ::io::stream::Readable) -> ::image::info::Info {
            return self.imageInfo;
          }

          pub fn read(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Create passthrough

            loop {
              match self.state {
                Init => self.init(),

                Invalid => {::io::console::println("invalid")},
                Required => {},

                ReadHeader => self.readHeader(input),

                ReadChunkHeader => self.readChunkHeader(input),
                ReadChunkCRC => self.readChunkCRC(input),
                SkipChunk => self.skipChunk(input),

                ReadIHDR => self.readIHDR(input),
                ReadPLTE => self.readPLTE(input),
                ReadIDAT => self.readIDAT(input),
                ReadIEND => {},

                ReadPLTEEntries => {},

                InterpretIDAT => {},
                FillIDAT => {},
                DoneIDAT => {},

                DecodeIDAT => self.decodeIDAT(input),
                DecodeReadFilterType => self.decodeReadFilterType(),

                UnfilterNone => self.unfilterNone(),
                UnfilterSub => self.unfilterSub(),
                UnfilterUp => self.unfilterUp(),
                UnfilterAverage => self.unfilterAverage(),
                UnfilterPaeth => self.unfilterPaeth(),

                Render => {
                  if (pixelmap.width == 0) {
                    pixelmap.resize(self.imageInfo.width, self.imageInfo.height);
                  }

                  match self.imageType {
                    Grayscale1bpp  => self.renderGrayscale1bpp(pixelmap),
                    Grayscale2bpp  => self.renderGrayscale2bpp(pixelmap),
                    Grayscale4bpp  => self.renderGrayscale4bpp(pixelmap),
                    Grayscale8bpp  => self.renderGrayscale8bpp(pixelmap),
                    Grayscale16bpp => self.renderGrayscale16bpp(pixelmap),

                    Truecolor8bpp  => self.renderTruecolor8bpp(pixelmap),
                    Truecolor16bpp => self.renderTruecolor16bpp(pixelmap),

                    Indexed1bpp    => self.renderIndexed1bpp(pixelmap),
                    Indexed2bpp    => self.renderIndexed2bpp(pixelmap),
                    Indexed4bpp    => self.renderIndexed4bpp(pixelmap),
                    Indexed8bpp    => self.renderIndexed8bpp(pixelmap),

                    GrayscaleAlpha8bpp => self.renderGrayscaleAlpha8bpp(pixelmap),
                    GrayscaleAlpha16bpp => self.renderGrayscaleAlpha16bpp(pixelmap),

                    TruecolorAlpha8bpp => self.renderTruecolorAlpha8bpp(pixelmap),
                    TruecolorAlpha16bpp => self.renderTruecolorAlpha16bpp(pixelmap),
                  }

                  self.state = self.filterState;
                },

                Accepted => {},
                Complete => {break;},
              }

              if (self.state as u32 == Invalid as u32) {
                ::io::console::println("invalid");
              }

              if (self.state as u32 == Invalid as u32  ||
                  self.state as u32 == Required as u32 ||
                  self.state as u32 == Accepted as u32) {
                break;
              }
            }
          }

          fn init(&mut self) {
            self.state = ReadHeader;
            self.filterState = DecodeReadFilterType;
          }

          fn readHeader(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 8 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readInto(self.header);

            // Verify header
            if self.header != [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a] {
              self.state = Invalid;
              return;
            }

            self.state = ReadChunkHeader;
          }

          fn readChunkHeader(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 8 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.chunkHeader as *mut PngChunkHeader as *mut u8, 8);

            self.chunkHeader.length = ::system::cpu::fromBigEndian32(self.chunkHeader.length);
            self.chunkHeader.chunkType   = ::system::cpu::fromBigEndian32(self.chunkHeader.chunkType);

            self.state =
              match self.chunkHeader.chunkType {
                IHDR => ReadIHDR,
                PLTE => ReadPLTE,
                IDAT => ReadIDAT,
                IEND => Complete,
                   _ => SkipChunk
              };
          }

          fn skipChunk(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < self.chunkHeader.length as u64 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.seek(self.chunkHeader.length as i64);
            self.state = ReadChunkCRC;
          }

          fn readIHDR(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 13 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.IHDR as *mut IHDR as *mut u8, 13);

            self.haveIHDR = true;

            self.IHDR.width  = ::system::cpu::fromBigEndian32(self.IHDR.width);
            self.IHDR.height = ::system::cpu::fromBigEndian32(self.IHDR.height);

            self.imageInfo.width = self.IHDR.width as u64;
            self.imageInfo.height = self.IHDR.height as u64;
            self.imageInfo.bitsPerPixel = self.IHDR.bitDepth as u32;

            self.paletteCount = 0;

            match self.IHDR.colorType {
              // Grayscale
              0 => {
                match self.IHDR.bitDepth {
                  1 | 2 | 4 | 8 => {},
                  _ => {self.state = Invalid;}
                }
              },

              2 => {
                match self.IHDR.bitDepth {
                  8 | 16 => {},
                  _ => {self.state = Invalid;}
                }
              },

              3 => {
                match self.IHDR.bitDepth {
                  1 | 2 | 4 | 8 => {},
                  _ => {self.state = Invalid;}
                }
              },

              4 => {
                match self.IHDR.bitDepth {
                  8 | 16 => {},
                  _ => {self.state = Invalid;}
                }
              },

              6 => {
                match self.IHDR.bitDepth {
                  8 | 16 => {},
                  _ => {self.state = Invalid;}
                }
              },

              _ => {
                self.state = Invalid;
              }
            }

            if self.IHDR.filterMethod != 0 {
              self.state = Invalid;
              return;
            }

            if self.IHDR.compressionMethod != 0 {
              self.state = Invalid;
              return;
            }

            if self.IHDR.interlaceMethod > 1 {
              self.state = Invalid;
              return;
            }

            if self.IHDR.interlaceMethod > 0 {
              self.setUpInterlacing();
            }

            self.imageType =
              match self.IHDR.colorType {
                0 => match self.IHDR.bitDepth {
                   1 => Indexed1bpp,
                   2 => Indexed2bpp,
                   4 => Indexed4bpp,
                   8 => Indexed8bpp,
                   _ => { self.state = Invalid; Indexed1bpp }
                },
                2 => match self.IHDR.bitDepth {
                   8 => Truecolor8bpp,
                  16 => Truecolor16bpp,
                   _ => { self.state = Invalid; Grayscale1bpp }
                },
                3 => match self.IHDR.bitDepth {
                   1 => Grayscale1bpp,
                   2 => Grayscale2bpp,
                   4 => Grayscale4bpp,
                   8 => Grayscale8bpp,
                  16 => Grayscale16bpp,
                   _ => { self.state = Invalid; Grayscale1bpp }
                },
                4 => match self.IHDR.bitDepth {
                   8 => GrayscaleAlpha8bpp,
                  16 => GrayscaleAlpha16bpp,
                   _ => { self.state = Invalid; Grayscale1bpp }
                },
                6 => match self.IHDR.bitDepth {
                   8 => TruecolorAlpha8bpp,
                  16 => TruecolorAlpha16bpp,
                   _ => { self.state = Invalid; Grayscale1bpp }
                },
                _ => { self.state = Invalid; Grayscale1bpp }
              };

            self.expectedBytes =
              match self.IHDR.colorType {
                // Indexed / Grayscale
                3 | 0 => {
                  self.numSamples = 1;
                  match self.IHDR.bitDepth {
                     1 => 1 + ((self.IHDR.width as f32 / 8.0f32) + 0.5f32) as i32,
                     2 => 1 + ((self.IHDR.width as f32 / 4.0f32) + 0.5f32) as i32,
                     4 => 1 + ((self.IHDR.width as f32 / 2.0f32) + 0.5f32) as i32,
                     8 => self.IHDR.width as i32,
                    16 => { self.numSamples = 2; self.IHDR.width as i32 * 2 }
                     _ => { self.state = Invalid; 0 }
                  }
                },

                // Truecolor
                2 => {
                  self.numSamples = 3;
                  match self.IHDR.bitDepth {
                     8 => { self.numSamples = 3; self.IHDR.width as i32 * 3 },
                    16 => { self.numSamples = 6; self.IHDR.width as i32 * 3 * 2},
                     _ => { self.state = Invalid; 0 }
                  }
                },

                // Grayscale Alpha
                4 => {
                  match self.IHDR.bitDepth {
                     8 => { self.numSamples = 2; self.IHDR.width as i32 * 2 },
                    16 => { self.numSamples = 4; self.IHDR.width as i32 * 2 * 2},
                     _ => { self.state = Invalid; 0 }
                  }
                },

                // Truecolor Alpha
                6 => {
                  match self.IHDR.bitDepth {
                     8 => { self.numSamples = 4; self.IHDR.width as i32 * 4 },
                    16 => { self.numSamples = 8; self.IHDR.width as i32 * 4 * 2},
                     _ => { self.state = Invalid; 0 }
                  }
                },

                _ => {
                  self.state = Invalid; 0
                }
              };

            if self.state as u32 == Invalid as u32 {
              return;
            }

            // Init Decoder Data
            for i in ::iter::range_step(0, 8, 1) {
              self.bytes[i] = ::vec::from_elem(self.expectedBytes as uint, 0 as u8);
            }

            self.nsamp = 0;
            self.psamp = 0;

            self.x = 0;
            self.y = 0;

            self.state = ReadChunkCRC;
          }

          fn setUpInterlacing(&mut self) {
            self.interlacePass = 0;
            self.interlaceCurLine = 0;

            // Set up interlace pass dimensions

            // That is, how much data will be in each pass
            // Also, how much will be in each scanline for each pass

            // Equations for interlace widths:

            // 1st pass: ceiling(width / 8)
            // 2nd pass: ceiling((width - 4) / 8)
            // 3rd pass: ceiling(width / 4)
            // 4th pass: ceiling((width - 2) / 4)
            // 5th pass: ceiling(width / 2)
            // 6th pass: ceiling((width - 1) / 2)
            // 7th pass: width

            // Equations for interlace heights:

            // 1st, 2nd pass: ceiling(height / 8)
            // 3rd pass: ceiling((height - 4) / 8)
            // 4th pass: ceiling(height / 4)
            // 5th pass: ceiling((height - 2) / 4)
            // 6th pass: ceiling(height / 2)
            // 7th pass: ceiling((height - 1) / 2)
            for i in ::iter::range_step(0, 3, 1) {
              let intermediate = self.IHDR.width as f64 / ((8 >> i) as f64);
              self.interlaceWidths[i * 2] = ::math_round::math::round::ceiling(intermediate) as u32;

              let intermediate2 = (self.IHDR.width - (4 >> i)) as f64 / ((8 >> i) as f64);
              self.interlaceWidths[(i * 2) + 1] = ::math_round::math::round::ceiling(intermediate2) as u32;
            }
            self.interlaceWidths[6] = self.IHDR.width;

            for i in ::iter::range_step(0, 3, 1) {
              let intermediate = self.IHDR.height as f64 / ((8 >> i) as f64);
              self.interlaceWidths[(i * 2) + 1] = ::math_round::math::round::ceiling(intermediate) as u32;

              let intermediate2 = (self.IHDR.height - (4 >> i)) as f64 / ((8 >> i) as f64);
              self.interlaceWidths[(i * 2) + 2] = ::math_round::math::round::ceiling(intermediate2) as u32;
            }
            self.interlaceWidths[0] = self.interlaceHeights[1];
          }

          fn readPLTE(&mut self, input: &mut ::io::stream::Readable) {
            // Read Palette Entries

            // The chunk length divided by 3 is the number of entries
            // since each entry is 3 bytes (1 per color channel)

            // If the chunk length is not divisible by 3, it is corrupt
            if (self.chunkHeader.length % 3 != 0) {
              self.state = Invalid;
              return;
            }

            self.paletteCount = self.chunkHeader.length / 3;

            if (self.paletteCount > 256) {
              // Too many entries
              self.state = Invalid;
              return;
            }
            else if (self.paletteCount == 0) {
              // Valid, but there are no entries.
              self.state = ReadChunkCRC;
              return;
            }

            if input.available() < self.chunkHeader.length as u64 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.palette as *mut PngColor as *mut u8, self.chunkHeader.length as u64);

            for i in ::iter::range_step(0, self.paletteCount, 1) {
              self.paletteRealized[i] = 0xff000000 | self.palette[i].red as u32
                                                   | self.palette[i].green as u32 << 8
                                                   | self.palette[i].blue as u32 << 16;
            }

            for i in ::iter::range_step(self.paletteCount, 256, 1) {
              self.paletteRealized[i] = 0;
            }

            self.state = ReadChunkCRC;
          }

          fn readIDAT(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() == 0 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            let mut bytes_to_read = self.chunkHeader.length as u64 - self.bytesDecoded;

            if input.available() < bytes_to_read {
              bytes_to_read = input.available();
            }

            self.decoderSource.appendFromReader(input, bytes_to_read);

            self.state = DecodeIDAT;
          }

          fn decodeIDAT(&mut self, input: &mut ::io::stream::Readable) {
            // let mut source = ::io::pass_through::create();

            // Decompress some bits if we can
            if self.bytesDecoded == 0 {
              self.decodedBuffer.resize(self.expectedBytes as u64);
              //source.useRegion(input.position(), self.chunkHeader.length as u64);
            }

            if self.bytesDecoded == self.chunkHeader.length as u64 {
              self.state = ReadChunkCRC;
              self.bytesDecoded = 0;
              return;
            }

            if self.decoderSource.available() == 0 {
              self.state = ReadIDAT;
              return;
            }

            // How many bits?
            let curPos = self.decoderSource.position();
            self.decoder.decode(self.decoderSource.reader(), self.decodedBuffer.stream());
            let numBytesDecoded = self.decoderSource.position() - curPos;
            self.bytesDecoded += numBytesDecoded;
            //self.decoderSource.seek(numBytesDecoded as i64);

            // Render those bits in the decoded buffer!
            self.state = self.filterState;
          }

          fn decodeReadFilterType(&mut self) {
            if self.decodedBuffer.reader().available() < 1 {
              self.state = DecodeIDAT;
              return;
            }

            let filterType = self.decodedBuffer.reader().read(1)[0];
            self.state =
              match filterType {
                0 => UnfilterNone,
                1 => UnfilterSub,
                2 => UnfilterUp,
                3 => UnfilterAverage,
                4 => UnfilterPaeth,
                _ => {::io::console::println("filter state wrong"); Invalid }
              };

            for i in ::iter::range_step(0, self.numSamples, 1) {
              self.priorScannedByte[i] = 0;
              self.priorPixel[i] = 0;
            }

            self.nsamp = 0;
            self.psamp = 0;

            self.filterState = self.state;
          }

          fn interlaceCompleteLine(&mut self) {
            self.interlaceCurLine += 1;

            if self.interlaceCurLine == self.interlaceHeights[self.interlacePass] {
              // Entering a new interlace pass
              self.interlaceCurLine = 0;

              for i in ::iter::range_step(0, 8, 1) {
                for j in ::iter::range_step(0, self.expectedBytes, 1) {
                  self.bytes[i][j] = 0;
                }
              }

              // Skip empty interlace passes
              loop {
                self.interlacePass += 1;
                if (self.interlacePass < 7 &&
                    (self.interlaceWidths[self.interlacePass] == 0 ||
                     self.interlaceHeights[self.interlacePass] == 0)) {
                  break;
                }
              }

              if self.interlacePass < 7 {
                self.y = INTERLACE_STARTS_Y[self.interlacePass];
              }
            }
            else {
              self.y += INTERLACE_INCREMENTS_Y[self.interlacePass];
            }

            if self.interlacePass < 7 {
              self.x = INTERLACE_STARTS_X[self.interlacePass];
            }
          }

          fn reposition(&mut self) -> bool {
            if self.x >= self.IHDR.width {
              // Done
              if self.IHDR.interlaceMethod > 0 {
                self.interlaceCompleteLine();

                if self.interlacePass >= 7 {
                  // Done decoding
                  self.state = Complete;
                  return true;
                }
              }
              else {
                self.x = 0;
                self.y += 1;
              }

              if self.y >= self.IHDR.height {
                self.state = Complete;
                return true;
              }

              self.filterState = DecodeReadFilterType;
              self.state = self.filterState;
              return true;
            }

            if self.decodedBuffer.reader().available() < 1 {
              self.state = DecodeIDAT;
              return true;
            }

            false
          }

          fn incrementPSamp(&mut self) {
            self.psamp += 1;

            if self.psamp == self.numSamples as u32 {
              self.nsamp += 1;
              self.psamp = 0;

              self.state = Render;
            }
          }

          fn unfilterNone(&mut self) {
            if self.reposition() {
              return;
            }

            let b = self.decodedBuffer.reader().read(1)[0];

            self.curComponent[self.psamp]      = b as u32;
            self.bytes[self.psamp][self.nsamp] = b;

            self.incrementPSamp();
          }

          fn unfilterSub(&mut self) {
            if self.reposition() {
              return;
            }

            let b = self.decodedBuffer.reader().read(1)[0];

            self.priorPixel[self.psamp]   += b;
            self.curComponent[self.psamp]  = self.priorPixel[self.psamp] as u32;
            self.bytes[self.psamp][self.nsamp] = self.curComponent[self.psamp] as u8;

            self.incrementPSamp();
          }

          fn unfilterUp(&mut self) {
            if self.reposition() {
              return;
            }

            let b = self.decodedBuffer.reader().read(1)[0];

            self.bytes[self.psamp][self.nsamp] += b;
            self.curComponent[self.psamp]       = self.bytes[self.psamp][self.nsamp] as u32;

            self.incrementPSamp();
          }

          fn unfilterAverage(&mut self) {
            if self.reposition() {
              return;
            }

            let b = self.decodedBuffer.reader().read(1)[0];

            self.curComponent[self.psamp]  = self.priorPixel[self.psamp] as u32;
            self.curComponent[self.psamp] += self.bytes[self.psamp][self.nsamp] as u32;
            self.curComponent[self.psamp] /= 2;
            self.curComponent[self.psamp] += b as u32;

            self.bytes[self.psamp][self.nsamp] = self.curComponent[self.psamp] as u8;

            self.curComponent[self.psamp] = self.bytes[self.psamp][self.nsamp] as u32;

            self.priorPixel[self.psamp] = self.bytes[self.psamp][self.nsamp];

            self.incrementPSamp();
          }

          fn unfilterPaeth(&mut self) {
            if self.reposition() {
              return;
            }

            let b = self.decodedBuffer.reader().read(1)[0];

            self.priorScannedComponent = self.priorScannedByte[self.psamp];
            self.priorScannedByte[self.psamp] = self.bytes[self.psamp][self.nsamp];

            let p = self.priorPixel[self.psamp] as i32
                  + self.priorScannedByte[self.psamp] as i32
                  - self.priorScannedComponent as i32;

            let pa =
              if p > self.priorPixel[self.psamp] as i32 {
                p - self.priorPixel[self.psamp] as i32
              }
              else {
                self.priorPixel[self.psamp] as i32 - p
              };

            let pb =
              if p > self.priorScannedByte[self.psamp] as i32 {
                p - self.priorScannedByte[self.psamp] as i32
              }
              else {
                self.priorScannedByte[self.psamp] as i32 - p
              };

            let pc =
              if p > self.priorScannedComponent as i32 {
                p - self.priorScannedComponent as i32
              }
              else {
                self.priorScannedComponent as i32 - p
              };

            let paethPredictor:u8 =
              if pa <= pb && pa <= pc {
                self.priorPixel[self.psamp]
              }
              else if pb <= pc {
                self.priorScannedByte[self.psamp]
              }
              else {
                self.priorScannedComponent
              };

            let recon:u8 = b + paethPredictor;

            self.priorPixel[self.psamp] = recon;
            self.curComponent[self.psamp] = recon as u32;

            self.bytes[self.psamp][self.nsamp] = self.curComponent[self.psamp] as u8;

            self.incrementPSamp();
          }

          fn readChunkCRC(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 4 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.chunkCRC as *mut u32 as *mut u8, 4);

            self.state = ReadChunkHeader;
          }

          fn advanceX(&mut self) {
            if self.IHDR.interlaceMethod > 0 {
              self.x += INTERLACE_INCREMENTS_X[self.interlacePass];
            }
            else {
              self.x += 1;
            }
          }

          fn renderGrayscalePixel(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap, pixel: u8) {
            let rgba:u32 = (pixel as u32 <<  0)
                         | (pixel as u32 <<  8)
                         | (pixel as u32 << 16)
                         | 0xff000000;

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR8G8B8A8(rgba);

            self.advanceX();
          }

          fn renderGrayscale1bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(7, -1, -1) {
              self.renderGrayscalePixel(pixelmap,
                EXPAND_1BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderGrayscale2bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(6, -1, -2) {
              self.renderGrayscalePixel(pixelmap,
                EXPAND_2BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderGrayscale4bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(4, -1, -4) {
              self.renderGrayscalePixel(pixelmap,
                EXPAND_4BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderGrayscale8bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            self.renderGrayscalePixel(pixelmap, self.curComponent[0] as u8);
          }

          fn renderGrayscale16bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u64 = (self.curComponent[0] as u64 <<  0)
                         | (self.curComponent[1] as u64 <<  8)
                         | (self.curComponent[0] as u64 <<  16)
                         | (self.curComponent[1] as u64 <<  24)
                         | (self.curComponent[0] as u64 <<  32)
                         | (self.curComponent[1] as u64 <<  40)
                         | 0xffff000000000000;

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR16G16B16A16(rgba);

            self.advanceX();
          }

          fn renderTruecolor8bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u32 = (self.curComponent[0] <<  0)
                         | (self.curComponent[1] <<  8)
                         | (self.curComponent[2] << 16)
                         | 0xff000000;

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR8G8B8A8(rgba);

            self.advanceX();
          }

          fn renderTruecolor16bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u64 = (self.curComponent[0] as u64 <<  0)
                         | (self.curComponent[1] as u64 <<  8)
                         | (self.curComponent[2] as u64 <<  16)
                         | (self.curComponent[3] as u64 <<  24)
                         | (self.curComponent[4] as u64 <<  32)
                         | (self.curComponent[5] as u64 <<  40)
                         | 0xffff000000000000;

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR16G16B16A16(rgba);

            self.advanceX();
          }

          fn renderIndexedPixel(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap, index: u8) {
            let bounded_index =
              if index as u32 > self.paletteCount {
                0
              }
              else {
                index
              };

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR8G8B8A8(self.paletteRealized[bounded_index]);

            self.advanceX();
          }

          fn renderIndexed1bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(7, -1, -1) {
              self.renderIndexedPixel(pixelmap,
                EXPAND_1BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderIndexed2bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(6, -1, -2) {
              self.renderIndexedPixel(pixelmap,
                EXPAND_2BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderIndexed4bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            for i in ::iter::range_step(4, -1, -4) {
              self.renderIndexedPixel(pixelmap,
                EXPAND_4BPP[self.curComponent[0] >> i & 0x1]);
              if self.x >= self.IHDR.width { return; }
            }
          }

          fn renderIndexed8bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            self.renderIndexedPixel(pixelmap, self.curComponent[0] as u8);
          }

          fn renderGrayscaleAlpha8bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u32 = (self.curComponent[0] <<  0)
                         | (self.curComponent[0] <<  8)
                         | (self.curComponent[0] << 16)
                         | (self.curComponent[1] << 24);

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR8G8B8A8(rgba);

            self.advanceX();
          }

          fn renderGrayscaleAlpha16bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u64 = (self.curComponent[0] as u64 <<  0)
                         | (self.curComponent[1] as u64 <<  8)
                         | (self.curComponent[0] as u64 <<  16)
                         | (self.curComponent[1] as u64 <<  24)
                         | (self.curComponent[0] as u64 <<  32)
                         | (self.curComponent[1] as u64 <<  40)
                         | (self.curComponent[2] as u64 <<  48)
                         | (self.curComponent[3] as u64 <<  56);

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR16G16B16A16(rgba);

            self.advanceX();
          }

          fn renderTruecolorAlpha8bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u32 = (self.curComponent[0] <<  0)
                         | (self.curComponent[1] <<  8)
                         | (self.curComponent[2] << 16)
                         | (self.curComponent[3] << 24);

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR8G8B8A8(rgba);

            self.advanceX();
          }

          fn renderTruecolorAlpha16bpp(&mut self, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            let rgba:u64 = (self.curComponent[0] as u64 <<  0)
                         | (self.curComponent[1] as u64 <<  8)
                         | (self.curComponent[2] as u64 <<  16)
                         | (self.curComponent[3] as u64 <<  24)
                         | (self.curComponent[4] as u64 <<  32)
                         | (self.curComponent[5] as u64 <<  40)
                         | (self.curComponent[6] as u64 <<  48)
                         | (self.curComponent[7] as u64 <<  56);

            if self.IHDR.interlaceMethod > 0 {
              pixelmap.reposition(self.x as u64, self.y as u64);
            }

            pixelmap.writeR16G16B16A16(rgba);

            self.advanceX();
          }
        }
      }
    }
  }
}
