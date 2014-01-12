#[crate_id="codec-image-bmp-decoder#1.0"];
#[feature(globs)];

extern mod io_console      = "io-console";
extern mod io_stream       = "io-stream";
extern mod io_pixelmap     = "io-pixelmap";

extern mod image_info = "image-info";

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
  pub mod pixelmap {
    pub use io_pixelmap::io::pixelmap::*;
  }
}

pub mod codec {
  pub mod image {
    pub mod bmp {
      pub mod decoder {
        use std::vec;
        use std::iter;

        pub enum State {
          Init,

          Invalid,
          Required,
          Accepted,

          ReadHeaders,
          ReadBitmapSize,

          InterpretHeader,

          ReadOSX1,
          ReadOSX2,
          ReadWindows,

          ReadWindowsPalette,
          ReadOSX1Palette,
          ReadOSX2Palette,

          ReadWindowsBitfields,

          SkipToImageData,

          DecodeWindows1bpp,
          DecodeWindows2bpp,
          DecodeWindows4bpp,
          DecodeWindows8bpp,
          DecodeWindows16bpp,
          DecodeWindows24bpp,
          DecodeWindows32bpp,

          RenderWindows1bpp,
          RenderWindows2bpp,
          RenderWindows4bpp,
          RenderWindows8bpp,
          RenderWindows16bpp,
          RenderWindows24bpp,
          RenderWindows32bpp,
        }

#[packed]
        struct FileHeader {
          header_type: u16,
          size: u32,
          reserved: u32,
          offBits: u32
        }

#[packed]
        struct InfoHeader {
          biWidth: u32,
          biHeight: i32,
          biPlanes: u16,
          biBitCount: u16,
          biCompression: u32,
          biSizeImage: u32,
          biXPelsPerMeter: i32,
          biYPelsPerMeter: i32,
          biClrUsed: u32,
          biClrImportant: u32
        }

#[packed]
        struct OS2_1InfoHeader {
          biWidth: u16,
          biHeight: u16,
          biPlanes: u16,
          biBitCount: u16
        }

#[packed]
        struct OS2_2InfoHeader {
          biWidth: u32,
          biHeight: u32,
          biPlanes: u16,
          biBitCount: u16,
          biCompression: u32,
          biSizeImage: u32,
          biXPelsPerMeter: u32,
          biYPelsPerMeter: u32,
          biClrUsed: u32,
          biClrImportant: u32,

          /* extended os2 2.x stuff */

          usUnits: u16,
          usReserved: u16,
          usRecording: u16,
          usRendering: u16,
          cSize1: u32,
          cSize2: u32,
          ulColorEncoding: u32,
          ulIdentifier: u32
        }

        pub struct Decoder {
          fileHeader: FileHeader,
          infoHeader: InfoHeader,

          os2_1_bi: OS2_1InfoHeader,
          os2_2_bi: OS2_2InfoHeader,

          imageInfo: ::image::info::Info,

          // Bit masks for bitfields compression
          bitfields: [u32, ..3],
          bitfieldShifts: [u32, ..3],
          bitfieldSizes: [u32, ..3],
          bitfieldMaxes: [u32, ..3],

          // Color Palette
          paletteNumColors: u32,
          palette: [u32, ..256],

          // Position
          y: u64,
          x: u64,
          width: u64,
          height: u64,

          imageDataSkipAmount: u64,

          // RLE
          absoluteCount: i32,
          deltaPairNext: bool,

          // StateMachine
          state: State,
          nextState: State,
          currentState: State,

          bytesPerRow: u64,
          bytesLeft:   u64,
        }

        pub fn new() -> ~Decoder {
          ~Decoder {
            state: ReadHeaders,

            imageInfo: ::image::info::Info {
              width: 0,
              height: 0,
              colorDepth: ::io::pixelmap::B8G8R8A8,
              bitsPerPixel: 0,
            },

            // Defaults
            y: 0,
            x: 0,
            width: 0,
            height: 0,
            imageDataSkipAmount: 0,
            absoluteCount: 0,
            deltaPairNext: false,
            nextState: ReadHeaders,
            currentState: ReadHeaders,
            bytesPerRow: 0,
            bytesLeft:   0,
            palette: [0, ..256],
            paletteNumColors: 0,
            bitfields: [0, 0, 0],
            bitfieldShifts: [0, 0, 0],
            bitfieldSizes: [0, 0, 0],
            bitfieldMaxes: [0, 0, 0],
            fileHeader: FileHeader {
              header_type: 0,
              size: 0,
              reserved: 0,
              offBits: 0 },
            infoHeader: InfoHeader {
              biWidth: 0,
              biHeight: 0,
              biPlanes: 0,
              biBitCount: 0,
              biCompression: 0,
              biSizeImage: 0,
              biXPelsPerMeter: 0,
              biYPelsPerMeter: 0,
              biClrUsed: 0,
              biClrImportant: 0 },
            os2_1_bi: OS2_1InfoHeader {
              biWidth: 0,
              biHeight: 0,
              biPlanes: 0,
              biBitCount: 0 },
            os2_2_bi: OS2_2InfoHeader {
              biWidth: 0,
              biHeight: 0,
              biPlanes: 0,
              biBitCount: 0,
              biCompression: 0,
              biSizeImage: 0,
              biXPelsPerMeter: 0,
              biYPelsPerMeter: 0,
              biClrUsed: 0,
              biClrImportant: 0,
              usUnits: 0,
              usReserved: 0,
              usRecording: 0,
              usRendering: 0,
              cSize1: 0,
              cSize2: 0,
              ulColorEncoding: 0,
              ulIdentifier: 0 },
          }
        }

        impl Decoder {
          pub fn info(&mut self, input: &mut ::io::stream::Readable) -> ::image::info::Info {
            return self.imageInfo;
          }

          pub fn read(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            loop {
              match self.state {
                Init => self.readHeaders(input),

                Invalid  => {},
                Accepted => {},
                Required => { self.state = self.currentState; },

                ReadHeaders => self.readHeaders(input),
                ReadBitmapSize => self.readBitmapSize(input),

                InterpretHeader => self.interpretHeader(input),

                SkipToImageData => self.skipToImageData(input),

                ReadOSX1 => {},
                ReadOSX2 => {},
                ReadWindows => self.readWindowsInfo(input),

                ReadWindowsPalette => self.readWindowsPalette(input),
                ReadOSX1Palette => {},
                ReadOSX2Palette => {},

                ReadWindowsBitfields => self.readWindowsBitfields(input),

                DecodeWindows1bpp => self.decodeWindows1bpp(),
                DecodeWindows2bpp => self.decodeWindows2bpp(),
                DecodeWindows4bpp => self.decodeWindows4bpp(),
                DecodeWindows8bpp => self.decodeWindows8bpp(),
                DecodeWindows16bpp => self.decodeWindows16bpp(),
                DecodeWindows24bpp => self.decodeWindows24bpp(),
                DecodeWindows32bpp => self.decodeWindows32bpp(),

                RenderWindows1bpp => self.renderWindows1bpp(input, pixelmap),
                RenderWindows2bpp => self.renderWindows2bpp(input, pixelmap),
                RenderWindows4bpp => {
                  if self.infoHeader.biCompression == 2 {
                    self.renderWindowsRLE4bpp(input, pixelmap);
                  }
                  else {
                    self.renderWindows4bpp(input, pixelmap);
                  }
                },
                RenderWindows8bpp => {
                  if self.infoHeader.biCompression == 1 {
                    self.renderWindowsRLE8bpp(input, pixelmap);
                  }
                  else {
                    self.renderWindows8bpp(input, pixelmap);
                  }
                },
                RenderWindows16bpp => self.renderWindows16bpp(input, pixelmap),
                RenderWindows24bpp => self.renderWindows24bpp(input, pixelmap),
                RenderWindows32bpp => self.renderWindows32bpp(input, pixelmap),
              }

              if (self.state as u32) == Invalid as u32 {
                break;
              }
              else if (self.state as u32 == Required as u32 || self.state as u32 == Accepted as u32) {
                break;
              }
            }
          }

          fn readHeaders(&mut self, input: &mut ::io::stream::Readable) {
            // Read into fileHeader
            input.readIntoPtr(&mut self.fileHeader as *mut FileHeader as *mut u8, 14);

            // Determine if file is a bitmap
            if (self.fileHeader.header_type != 0x4d42) {
              self.state = Invalid;
            }
            else {
              self.state = ReadBitmapSize;
            }

            self.imageDataSkipAmount = self.fileHeader.offBits as u64 - 14;
          }

          fn readBitmapSize(&mut self, input: &mut ::io::stream::Readable) {
            if (input.available() < 4) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            // Read biSize
            let mut biSize = 0 as u32;
            input.readIntoPtr(&mut biSize as *mut u32 as *mut u8, 4);
            self.imageDataSkipAmount -= 4;

            self.state = match(biSize){
              0x0c => ReadOSX1,
              0xf0 => ReadOSX2,
              0x28 => ReadWindows,
              _    => Invalid
            };
          }

          fn readWindowsInfo(&mut self, input: &mut ::io::stream::Readable) {
            if (input.available() < 36) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            // Read into infoHeader
            input.readIntoPtr(&mut self.infoHeader as *mut InfoHeader as *mut u8, 36);
            self.imageDataSkipAmount -= 36;

            self.paletteNumColors = 0;

            self.imageInfo.width = self.infoHeader.biWidth as u64;
            self.imageInfo.height = self.infoHeader.biHeight as u64;
            self.imageInfo.bitsPerPixel = self.infoHeader.biBitCount as u32;
            // TODO: image::info::Info color depth

            self.state = InterpretHeader;
          }

          fn skipToImageData(&mut self, input: &mut ::io::stream::Readable) {
            let offset = self.fileHeader.offBits as i64;

            if (offset > 0) {
              if (input.available() < offset as u64) {
                self.currentState = self.state;
                self.state = Required;
                return;
              }

              input.seek(self.imageDataSkipAmount as i64);
            }

            self.state = self.nextState;
          }

          fn interpretHeader(&mut self, input: &mut ::io::stream::Readable) {
            match (self.infoHeader.biBitCount) {
              1 => {
                self.state = ReadWindowsPalette;
                self.nextState = DecodeWindows1bpp;
                self.paletteNumColors = 2;
              },
              2 => {
                self.state = ReadWindowsPalette;
                self.nextState = DecodeWindows2bpp;
                self.paletteNumColors = 4;
              },
              4 => {
                self.state = ReadWindowsPalette;
                self.nextState = DecodeWindows4bpp;
                self.paletteNumColors = 16;
              },
              8 => {
                self.state = ReadWindowsPalette;
                self.nextState = DecodeWindows8bpp;
                self.paletteNumColors = 256;
              },
              16 => {
                self.state = ReadWindowsBitfields;
                self.nextState = DecodeWindows16bpp;
              },
              24 => {
                self.state = SkipToImageData;
                self.nextState = DecodeWindows24bpp;
              },
              32 => {
                self.state = ReadWindowsBitfields;
                self.nextState = DecodeWindows32bpp;
              },
              _ => {
                self.state = Invalid;
              }
            }
          }

          fn readWindowsPalette(&mut self, input: &mut ::io::stream::Readable) {
            if (self.infoHeader.biClrUsed == 0) {
              self.infoHeader.biClrUsed = self.paletteNumColors;
            }

            // TODO: endianess
            let sizeOfPalette = self.infoHeader.biClrUsed as u64 * 4;

            self.imageDataSkipAmount -= sizeOfPalette;

            if (input.available() < sizeOfPalette) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&self.palette as *mut u32 as *mut u8, sizeOfPalette);

            // TODO: endianess
            for i in iter::range_step(0, self.paletteNumColors, 1) {
              self.palette[i] |= 0xff000000;
            }

            self.state = SkipToImageData;
          }

          fn readWindowsBitfields(&mut self, input: &mut ::io::stream::Readable) {
            if (self.infoHeader.biCompression == 3) {
              if (input.available() < 12) {
                self.currentState = self.state;
                self.state = Required;
                return;
              }

              input.readIntoPtr(&self.bitfields as *mut u32 as *mut u8, 12);

              self.imageDataSkipAmount -= 12;

              for i in iter::range_step(0, 3, 1) {
                self.bitfieldShifts[i] = 0;
                self.bitfieldMaxes[i]  = 0;
                self.bitfieldSizes[i]  = 0;
              }

              for i in iter::range_step(0, 3, 1) {
                let mut check = 0x1;

                while (check > 0 && (self.bitfields[i] & check) == 0) {
                  self.bitfieldShifts[i] += 1;
                  check <<= 1;
                }

                while (check > 0 && (self.bitfields[i] & check) > 0) {
                  self.bitfieldMaxes[i] = (self.bitfieldMaxes[i] << 1) | 1;
                  self.bitfieldSizes[i] += 1;

                  check <<= 1;
                }
              }
            }
            else {
              if (self.infoHeader.biBitCount == 16) {
                // Default is 5-5-5
                self.bitfields[0] = 0x00007c00;
                self.bitfields[1] = 0x000003e0;
                self.bitfields[2] = 0x0000001f;

                self.bitfieldShifts[0] = 10;
                self.bitfieldShifts[1] = 5;
                self.bitfieldShifts[2] = 0;

                self.bitfieldMaxes[0] = 0x1f;
                self.bitfieldMaxes[1] = 0x1f;
                self.bitfieldMaxes[2] = 0x1f;

                self.bitfieldSizes[0] = 5;
                self.bitfieldSizes[1] = 5;
                self.bitfieldSizes[2] = 5;
              }
              else if (self.infoHeader.biBitCount == 32) {
                // Default is 8-8-8
                self.bitfields[0] = 0x00ff0000;
                self.bitfields[1] = 0x0000ff00;
                self.bitfields[2] = 0x000000ff;

                self.bitfieldShifts[0] = 16;
                self.bitfieldShifts[1] = 8;
                self.bitfieldShifts[2] = 0;

                self.bitfieldMaxes[0] = 0xff;
                self.bitfieldMaxes[1] = 0xff;
                self.bitfieldMaxes[2] = 0xff;

                self.bitfieldSizes[0] = 8;
                self.bitfieldSizes[1] = 8;
                self.bitfieldSizes[2] = 8;
              }
              else {
                self.state = Invalid;
              }
            }

            self.state = SkipToImageData;
          }

          fn decodeWindows1bpp(&mut self) {
            self.bytesPerRow = (self.infoHeader.biWidth as u64 + 7) / 8;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows1bpp;
          }

          fn renderWindows1bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row = vec::with_capacity(self.bytesPerRow as uint);
            input.readInto(row);

            let mut numPixels = 0;
            for color in row.iter() {
              for i in iter::range_step(0, 8, 1) {
                let clr = (color >> i as u8) & 0x1;

                if (numPixels >= self.infoHeader.biWidth) {
                  break;
                }

                let actual = self.palette[clr];

                pixelmap.writeB8G8R8A8(actual);
                numPixels += 1;
              }
            }
          }

          fn decodeWindows2bpp(&mut self) {
            self.bytesPerRow = (self.infoHeader.biWidth as u64 + 3) / 4;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows2bpp;
          }

          fn renderWindows2bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
            input.readInto(row);

            pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

            let mut numPixels = 0;
            for &color in row.iter() {
              for i in iter::range_step(0, 4, 1) {
                if (numPixels >= self.infoHeader.biWidth) {
                  break;
                }

                let clr = (color >> (i * 2)) & 0x3;

                let actual = self.palette[clr];
                pixelmap.writeB8G8R8A8(actual);

                numPixels += 1;
              }
            }

            self.y += 1;
          }

          fn decodeWindows4bpp(&mut self) {
            self.bytesPerRow = (self.infoHeader.biWidth as u64 + 1) / 2;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression == 2) {
              self.bytesLeft = self.infoHeader.biSizeImage as u64;
            }
            else if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows4bpp;
          }

          fn renderWindows4bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
            input.readInto(row);

            pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

            let mut numPixels = 0;
            for &color in row.iter() {
              for i in iter::range_step(0, 2, 1) {
                if (numPixels >= self.infoHeader.biWidth) {
                  break;
                }

                let clr = (color >> (i * 4)) & 0xf;

                let actual = self.palette[clr];
                pixelmap.writeB8G8R8A8(actual);

                numPixels += 1;
              }
            }

            self.y += 1;
            if self.y == self.infoHeader.biHeight as u64 {
              self.state = Accepted;
            }
          }

          fn renderWindowsRLE4bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }
          }

          fn decodeWindows8bpp(&mut self) {
            self.bytesPerRow = self.infoHeader.biWidth as u64;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression == 1) {
              // RLE-8
              self.bytesLeft = self.infoHeader.biSizeImage as u64;
            }
            else if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows8bpp;
          }

          fn renderWindows8bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
            unsafe {
              row.set_len(self.bytesPerRow as uint);
            }
            input.readInto(row);

            pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

            let mut numPixels = 0;
            for &color in row.iter() {
              if (numPixels >= self.infoHeader.biWidth) {
                break;
              }

              let clr = self.palette[color];
              pixelmap.writeB8G8R8A8(clr);

              numPixels += 1;
            }

            self.y += 1;
            if self.y == self.infoHeader.biHeight as u64 {
              self.state = Accepted;
            }
          }

          fn renderWindowsRLE8bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }
          }

          fn decodeWindows16bpp(&mut self) {
            self.bytesPerRow = self.infoHeader.biWidth as u64 * 2;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows16bpp;
          }

          fn renderWindows16bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row: ~[u16] = vec::with_capacity((self.bytesPerRow as uint) / 2);
            input.readIntoPtr(&mut row as *mut ~[u16] as *mut u8, self.bytesPerRow);

            pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

            let mut numPixels = 0;
            for &color in row.iter() {
              if (numPixels >= self.infoHeader.biWidth) {
                break;
              }

              let red   = ((color as u32 & self.bitfields[0]) >> self.bitfieldShifts[0])
                        << (8 - self.bitfieldSizes[0]);
              let green = ((color as u32 & self.bitfields[1]) >> self.bitfieldShifts[1])
                        << (8 - self.bitfieldSizes[1]);
              let blue  = ((color as u32 & self.bitfields[2]) >> self.bitfieldShifts[2])
                        << (8 - self.bitfieldSizes[2]);

              let clr = red | (green << 8) | (blue << 16) | 0xff000000;

              pixelmap.writeB8G8R8A8(clr);

              numPixels += 1;
            }

            self.y += 1;
            if self.y == self.infoHeader.biHeight as u64 {
              self.state = Accepted;
            }
          }

          fn decodeWindows24bpp(&mut self) {
            self.bytesPerRow = self.infoHeader.biWidth as u64 * 3;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows24bpp;
          }

          fn renderWindows24bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            // Attempt to acquire a row
            if (input.available() < self.bytesPerRow) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            let mut row = vec::with_capacity(self.bytesPerRow as uint);
            input.readInto(row);

            pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

            for i in iter::range_step(0, self.infoHeader.biWidth, 1) {
              let red   = row[(i * 3) + 2] as u32;
              let green = row[(i * 3) + 1] as u32;
              let blue  = row[(i * 3) + 0] as u32;

              let clr = red | (green << 8) | (blue << 16) | 0xff000000;

              pixelmap.writeB8G8R8A8(clr)
            }

            self.y += 1;
            if self.y == self.infoHeader.biHeight as u64 {
              self.state = Accepted;
            }
          }

          fn decodeWindows32bpp(&mut self) {
            self.bytesPerRow = self.infoHeader.biWidth as u64 * 4;

            if (self.bytesPerRow % 4 > 0) {
              let bytesForPadding = 4 - (self.bytesPerRow % 4);
              self.bytesPerRow += bytesForPadding;
            }

            // TODO: compression == 3?
            if (self.infoHeader.biCompression != 0) {
              self.state = Invalid;
              return;
            }

            self.state = RenderWindows32bpp;
          }

          fn renderWindows32bpp(&mut self, input: &mut ::io::stream::Readable, pixelmap: &mut ::io::pixelmap::Pixelmap) {
            if (input.available() < 4) {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            if (pixelmap.width == 0) {
              pixelmap.resize(self.infoHeader.biWidth as u64, self.infoHeader.biHeight as u64);
            }

            if (self.x == 0 && self.y == 0) {
              pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);
            }

            let mut row: ~[u32] = vec::with_capacity((self.bytesPerRow as uint) / 4);
            input.readIntoPtr(&mut row as *mut ~[u32] as *mut u8, self.bytesPerRow);

            for color in row.iter() {
              let red   = ((color & self.bitfields[0]) >> self.bitfieldShifts[0])
                        << (8 - self.bitfieldSizes[0]);
              let green = ((color & self.bitfields[1]) >> self.bitfieldShifts[1])
                        << (8 - self.bitfieldSizes[1]);
              let blue  = ((color & self.bitfields[2]) >> self.bitfieldShifts[2])
                        << (8 - self.bitfieldSizes[2]);

              let clr = red | (green << 8) | (blue << 16) | 0xff000000;

              pixelmap.writeB8G8R8A8(clr);

              self.x += 1;
              if (self.x == self.width) {
                self.x  = 0;
                self.y += 1;

                if self.y == self.infoHeader.biHeight as u64 {
                  self.state = Accepted;
                  break;
                }

                pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);
              }
            }
          }
        }
      }
    }
  }
}
