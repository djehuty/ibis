#[crate_id="io-pixelmap#1.0"];
#[feature(globs)];

extern mod io_stream = "io-stream";
extern mod io_buffer = "io-buffer";
extern mod drawing_color = "drawing-color";

mod drawing {
  pub mod color {
    pub use drawing_color::drawing::color::*;
  }
}

pub mod io {
  pub mod pixelmap {
    pub enum ColorDepth {
      B8G8R8,
      B8G8R8A8,

      R8G8B8,
      R8G8B8A8,

      R16G16B16,
      R16G16B16A16,

      B16G16R16,
      B16G16R16A16,
    }

    pub struct Pixelmap {
      colorDepth: ColorDepth,
      data: ~::io_buffer::io::buffer::Buffer,
      x: u64,
      y: u64,
      width: u64,
      height: u64,
    }

    pub fn create(width: u64, height: u64, colorDepth: ColorDepth) -> ~Pixelmap {
      ~Pixelmap {
        colorDepth: colorDepth,
        x: 0,
        y: 0,
        width: width,
        height: height,
        data: ::io_buffer::io::buffer::with_length(width * height * 4),
      }
    }

    impl Pixelmap {
      fn _advance(&mut self) {
        self.x += 1;

        if (self.x >= self.width) {
          self.x = 0;

          if (self.y < self.height) {
            self.y += 1;
          }
        }
      }

      pub fn resize(&mut self, width: u64, height: u64) {
        self.width  = width;
        self.height = height;
        self.data   = ::io_buffer::io::buffer::with_length(width * height * self.bytesPerPixel());
      }

      pub fn read(&mut self) -> ::drawing::color::Color {
        let bytesPerPixel = self.bytesPerPixel();
        let clr = self.data.read(bytesPerPixel);
        self._advance();

        match self.colorDepth {
          R8G8B8A8 => {
            ::drawing::color::ColorRGBA {
              red:   (clr[0] as f64) / 0xff as f64,
              green: (clr[1] as f64) / 0xff as f64,
              blue:  (clr[2] as f64) / 0xff as f64,
              alpha: (clr[3] as f64) / 0xff as f64,
            }
          },
          R8G8B8 => {
            ::drawing::color::ColorRGBA {
              red:   (clr[0] as f64) / 0xff as f64,
              green: (clr[1] as f64) / 0xff as f64,
              blue:  (clr[2] as f64) / 0xff as f64,
              alpha: 1.0,
            }
          },
          R16G16B16A16 => {
            ::drawing::color::ColorRGBA {
              red:   (clr[0] as f64) / 0xffff as f64,
              green: (clr[1] as f64) / 0xffff as f64,
              blue:  (clr[2] as f64) / 0xffff as f64,
              alpha: (clr[3] as f64) / 0xffff as f64,
            }
          },
          R16G16B16 => {
            ::drawing::color::ColorRGBA {
              red:   (clr[0] as f64) / 0xffff as f64,
              green: (clr[1] as f64) / 0xffff as f64,
              blue:  (clr[2] as f64) / 0xffff as f64,
              alpha: 1.0,
            }
          },
          _ => {
            ::drawing::color::ColorRGBA {
              red:   (clr[0] as f64) / 0xffff as f64,
              green: (clr[1] as f64) / 0xffff as f64,
              blue:  (clr[2] as f64) / 0xffff as f64,
              alpha: 1.0,
            }
          }
        }
      }

      pub fn reposition(&mut self, x: u64, y: u64) {
        let mut actual_x = x;
        let mut actual_y = y;
        if (actual_x >= self.width) {
          actual_x = self.width - 1;
        }

        if (actual_y >= self.height) {
          actual_y = self.height - 1;
        }

        self.x = actual_x;
        self.y = actual_y;

        let position = ((self.y * self.width) + self.x) * self.bytesPerPixel();
        self.data.stream().seekTo(position);
      }

      pub fn bytesPerPixel(&self) -> u64 {
        self.bitsPerPixel() / 8
      }

      pub fn bitsPerPixel(&self) -> u64 {
        match self.colorDepth {
          R8G8B8 |
          B8G8R8 => 24,

          R8G8B8A8 |
          B8G8R8A8 => 32,

          R16G16B16 |
          B16G16R16 => 48,

          R16G16B16A16 |
          B16G16R16A16 => 64,
        }
      }

      pub fn reader<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Readable {
        self.data.reader()
      }

      pub fn writer<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Writable {
        self.data.writer()
      }

      pub fn stream<'a>(&'a mut self) -> &'a mut ::io_stream::io::stream::Streamable {
        self.data.stream()
      }

      pub fn imm_reader<'a>(&'a self) -> &'a ::io_stream::io::stream::Readable {
        self.data.imm_reader()
      }

      pub fn imm_writer<'a>(&'a self) -> &'a ::io_stream::io::stream::Writable {
        self.data.imm_writer()
      }

      pub fn imm_stream<'a>(&'a self) -> &'a ::io_stream::io::stream::Streamable {
        self.data.imm_stream()
      }

      pub fn write(&mut self, color: ~::drawing::color::Color) {
        match self.colorDepth {
          R8G8B8A8 => {
            let clr = color.r8g8b8a8();
            self.data.writer().writeFromPtr(&clr as *u32 as *u8, 4);
            self._advance();
          },
          R8G8B8 => {
            let clr = color.r8g8b8();
            self.data.writer().writeFromPtr(&clr as *u32 as *u8, 3);
            self._advance();
          },
          _ => {
          }
        }
      }

      pub fn writeRGBAf64(&mut self, red: f64, green: f64, blue: f64, alpha: f64) {
        self.write(~::drawing::color::ColorRGBA { red: red, green: green, blue: blue, alpha: alpha });
      }

      pub fn writeHSLAf64(&mut self, hue: f64, saturation: f64, luminance: f64, alpha: f64) {
        self.write(~::drawing_color::drawing::color::ColorHSLA { hue: hue, saturation: saturation, luminance: luminance, alpha: alpha });
      }

      pub fn writeB8G8R8A8(&mut self, color: u32) {
        match self.colorDepth {
          R8G8B8A8 => {
            let new_color: u32 = (color & 0xff00ff00) |
                                 ((color & 0xff) << 16) |
                                 ((color >> 16) & 0xff);
            self.data.writer().writeFromPtr(&new_color as *u32 as *u8, 4);
            self._advance();
          },
          R8G8B8 => {
            let new_color: u32 = (color & 0xff00ff00) |
                                 ((color & 0xff) << 16) |
                                 ((color >> 16) & 0xff);
            self.data.writer().writeFromPtr(&new_color as *u32 as *u8, 3);
            self._advance();
          },
          _ => {
            let red   = ((color >>  0) & 0xff) as f64 / 0xff as f64;
            let green = ((color >>  8) & 0xff) as f64 / 0xff as f64;
            let blue  = ((color >> 16) & 0xff) as f64 / 0xff as f64;
            let alpha = ((color >> 24) & 0xff) as f64 / 0xff as f64;

            self.writeRGBAf64(red, green, blue, alpha);
          }
        }
      }

      pub fn writeB16G16R16A16(&mut self, color: u64) {
        match self.colorDepth {
          R8G8B8A8 => {
            self._advance();
          },
          R8G8B8 => {
            self._advance();
          },
          R16G16B16A16 => {
            self.data.writer().writeFromPtr(&color as *u64 as *u8, 8);
            self._advance();
          },
          R16G16B16 => {
            self.data.writer().writeFromPtr(&color as *u64 as *u8, 6);
            self._advance();
          },
          _ => {
            let red   = ((color >>  0) & 0xffff) as f64 / 0xffff as f64;
            let green = ((color >> 16) & 0xffff) as f64 / 0xffff as f64;
            let blue  = ((color >> 32) & 0xffff) as f64 / 0xffff as f64;
            let alpha = ((color >> 48) & 0xffff) as f64 / 0xffff as f64;

            self.writeRGBAf64(red, green, blue, alpha);
          }
        }
      }

      pub fn writeR8G8B8A8(&mut self, color: u32) {
        match self.colorDepth {
          R8G8B8A8 => {
            self.data.writer().writeFromPtr(&color as *u32 as *u8, 4);
            self._advance();
          },
          R8G8B8 => {
            self.data.writer().writeFromPtr(&color as *u32 as *u8, 3);
            self._advance();
          },
          _ => {
            let red   = ((color >>  0) & 0xff) as f64 / 0xff as f64;
            let green = ((color >>  8) & 0xff) as f64 / 0xff as f64;
            let blue  = ((color >> 16) & 0xff) as f64 / 0xff as f64;
            let alpha = ((color >> 24) & 0xff) as f64 / 0xff as f64;

            self.writeRGBAf64(red, green, blue, alpha);
          }
        }
      }

      pub fn writeR16G16B16A16(&mut self, color: u64) {
        match self.colorDepth {
          R8G8B8A8 => {
            self._advance();
          },
          R8G8B8 => {
            self._advance();
          },
          R16G16B16A16 => {
            self.data.writer().writeFromPtr(&color as *u64 as *u8, 8);
            self._advance();
          },
          R16G16B16 => {
            self.data.writer().writeFromPtr(&color as *u64 as *u8, 6);
            self._advance();
          },
          _ => {
            let red   = ((color >>  0) & 0xffff) as f64 / 0xffff as f64;
            let green = ((color >> 16) & 0xffff) as f64 / 0xffff as f64;
            let blue  = ((color >> 32) & 0xffff) as f64 / 0xffff as f64;
            let alpha = ((color >> 48) & 0xffff) as f64 / 0xffff as f64;

            self.writeRGBAf64(red, green, blue, alpha);
          }
        }
      }
    }

    impl ::io_stream::io::stream::Readable for Pixelmap {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.reader().readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.reader().readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.reader().read(amount)
      }

      fn readAll(&mut self) -> ~[u8] {
        self.reader().readAll()
      }

      fn seekTo(&mut self, position: u64) {
        self.reader().seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.reader().seek(amount)
      }

      fn length(&self) -> u64 {
        self.imm_reader().length()
      }

      fn available(&self) -> u64 {
        self.imm_reader().available()
      }

      fn position(&self) -> u64 {
        self.imm_reader().position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Writable for Pixelmap {
      fn write(&mut self, buffer: &[u8]) {
        self.writer().write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writer().writeFromPtr(buf_p, amount);
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writer().writeFromReader(data, amount)
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writer().writeFromStream(data, amount)
      }

      fn append(&mut self, buffer: &[u8]) {
        self.writer().append(buffer)
      }

      fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.writer().appendFromPtr(buf_p, amount)
      }

      fn appendFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writer().appendFromReader(data, amount)
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writer().appendFromStream(data, amount)
      }

      fn seekTo(&mut self, position: u64) {
        self.writer().seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.writer().seek(amount)
      }

      fn length(&self) -> u64 {
        self.imm_writer().length()
      }

      fn available(&self) -> u64 {
        self.imm_writer().available()
      }

      fn position(&self) -> u64 {
        self.imm_writer().position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }

    impl ::io_stream::io::stream::Streamable for Pixelmap {
      fn readInto(&mut self, buffer: &mut [u8]) -> bool {
        self.stream().readInto(buffer)
      }

      fn readIntoPtr(&mut self, buf_p: *mut u8, amount: u64) -> bool {
        self.stream().readIntoPtr(buf_p, amount)
      }

      fn read(&mut self, amount: u64) -> ~[u8] {
        self.stream().read(amount)
      }

      fn readAll(&mut self) -> ~[u8] {
        self.stream().readAll()
      }

      fn write(&mut self, buffer: &[u8]) {
        self.stream().write(buffer)
      }

      fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.stream().writeFromPtr(buf_p, amount);
      }

      fn writeFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.writer().writeFromReader(data, amount)
      }

      fn writeFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.writer().writeFromStream(data, amount)
      }

      fn append(&mut self, buffer: &[u8]) {
        self.stream().append(buffer)
      }

      fn appendFromPtr(&mut self, buf_p: *u8, amount: u64) {
        self.stream().appendFromPtr(buf_p, amount)
      }

      fn appendFromReader(&mut self, data: &mut ::io_stream::io::stream::Readable, amount: u64) {
        self.stream().appendFromReader(data, amount)
      }

      fn appendFromStream(&mut self, data: &mut ::io_stream::io::stream::Streamable, amount: u64) {
        self.stream().appendFromStream(data, amount)
      }

      fn seekTo(&mut self, position: u64) {
        self.stream().seekTo(position)
      }

      fn seek(&mut self, amount: i64) {
        self.stream().seek(amount)
      }

      fn length(&self) -> u64 {
        self.imm_stream().length()
      }

      fn available(&self) -> u64 {
        self.imm_stream().available()
      }

      fn position(&self) -> u64 {
        self.imm_stream().position()
      }

      fn seekable(&self) -> bool {
        true
      }

      fn persistent(&self) -> bool {
        false
      }
    }
  }
}
