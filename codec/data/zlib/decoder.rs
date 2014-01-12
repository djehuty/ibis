#[crate_id="codec-data-zlib-decoder#1.0"];
#[feature(globs)];

extern mod deflate = "codec-data-deflate-decoder";

extern mod io_console      = "io-console";
extern mod io_stream       = "io-stream";

mod io {
  pub mod stream {
    pub use io_stream::io::stream::*;
  }
  pub mod console {
    pub use io_console::io::console::*;
  }
}

pub mod codec {
  pub mod data {
    pub mod zlib {
      pub mod decoder {
        enum State {
          Init,

          Invalid,
          Required,
          Accepted,

          ReadHeader,
          StreamDeflate,
          ReadAlder32,

          Complete,
        }

#[packed]
        struct ZlibHeader {
          cmf: u8,
          flg: u8,
        }

        pub struct Decoder {
          header: ZlibHeader,

          compressionMethod: u8,
          compressionInfo:   u8,
          isDictionary:      u8,
          compressionLevel:  u8,
          fCheck:            u8,

          state:        State,
          currentState: State,

          deflater: ~::deflate::codec::data::deflate::decoder::Decoder,
        }

        pub fn new() -> ~Decoder {
          ~Decoder {
            state: Init,
            currentState: Init,

            header: ZlibHeader {
              cmf: 0,
              flg: 0,
            },

            compressionMethod: 0,
            compressionInfo:   0,
            isDictionary:      0,
            compressionLevel:  0,
            fCheck:            0,

            deflater: ::deflate::codec::data::deflate::decoder::new(),
          }
        }

        impl Decoder {
          pub fn decode(&mut self, input: &mut ::io::stream::Readable, stream: &mut ::io::stream::Streamable) {
            loop {
              match self.state {
                Init => self.readHeader(input),

                Invalid => {},
                Required => {},

                ReadHeader => self.readHeader(input),
                StreamDeflate => self.streamDeflate(input, stream),
                ReadAlder32 => self.readAlder32(input),

                Accepted => {},
                Complete => {break;},
              }

              if (self.state as u32 == Invalid as u32  ||
                  self.state as u32 == Required as u32 ||
                  self.state as u32 == Accepted as u32) {
                break;
              }
            }
          }

          fn readHeader(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 2 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.readIntoPtr(&mut self.header as *mut ZlibHeader as *mut u8, 2);

            self.compressionMethod = self.header.cmf & 0xf;
            self.compressionInfo   = self.header.cmf >> 4;

            self.isDictionary      = self.header.flg & 32;
            self.fCheck            = self.header.flg & 0xf;
            self.compressionLevel  = self.header.flg >> 6;

            if self.compressionMethod == 8 {
              // Deflate
              if self.compressionInfo > 7 {
                // Window size is invalid
                self.state = Invalid;
                return;
              }
            }
            else {
              self.state = Invalid;
              return;
            }

            self.state = StreamDeflate;
          }

          fn streamDeflate(&mut self, input: &mut ::io::stream::Readable, output: &mut ::io::stream::Streamable) {
            self.deflater.decode(input, output);

            // Check decoder state

            self.state = ReadAlder32;
          }

          fn readAlder32(&mut self, input: &mut ::io::stream::Readable) {
            if input.available() < 4 {
              self.currentState = self.state;
              self.state = Required;
              return;
            }

            input.seek(4);
            self.state = Complete;
          }
        }
      }
    }
  }
}
