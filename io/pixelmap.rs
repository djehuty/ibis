#[link(name = "io-pixelmap", vers = "1.0", package_id = "io-pixelmap")];

mod io {
  extern mod stream = "io-stream";
  extern mod buffer = "io-buffer";
}

mod drawing {
  extern mod color = "drawing-color";
}

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
  data: ~io::buffer::Buffer,
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
    data: io::buffer::create(128)
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
    let rewind = -(self.data.stream().position() as i64);
    self.data.stream().seek(rewind);
    self.data.stream().seek(position as i64);
  }

  pub fn bytesPerPixel(&self) -> u64 {
    self.bitsPerPixel() / 8
  }

  pub fn bitsPerPixel(&self) -> u64 {
    match self.colorDepth {
      R8G8B8A8 |
      B8G8R8A8 => 32,

      R8G8B8 |
      B8G8R8 => 24,

      R16G16B16 |
      B16G16R16 => 48,

      R16G16B16A16 |
      B16G16R16A16 => 64,
    }
  }

  pub fn reader<'a>(&'a mut self) -> &'a mut io::stream::Readable {
    self.data.reader()
  }

  pub fn writer<'a>(&'a mut self) -> &'a mut io::stream::Writable {
    self.data.writer()
  }

  pub fn stream<'a>(&'a mut self) -> &'a mut io::stream::Streamable {
    self.data.stream()
  }

  pub fn imm_reader<'a>(&'a self) -> &'a io::stream::Readable {
    self.data.imm_reader()
  }

  pub fn imm_writer<'a>(&'a self) -> &'a io::stream::Writable {
    self.data.imm_writer()
  }

  pub fn imm_stream<'a>(&'a self) -> &'a io::stream::Streamable {
    self.data.imm_stream()
  }

  pub fn write(&mut self, color: ~drawing::color::Color) {
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
    self.write(~drawing::color::ColorRGBA { red: red, green: green, blue: blue, alpha: alpha });
  }

  pub fn writeHSLAf64(&mut self, hue: f64, saturation: f64, luminance: f64, alpha: f64) {
    self.write(~drawing::color::ColorHSLA { hue: hue, saturation: saturation, luminance: luminance, alpha: alpha });
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

impl io::stream::Readable for Pixelmap {
  fn readInto<'a>(&'a mut self, buffer: &mut [u8]) -> bool {
    self.reader().readInto(buffer)
  }

  fn readIntoPtr<'a>(&'a mut self, buf_p: *mut u8, amount: u64) -> bool {
    self.reader().readIntoPtr(buf_p, amount)
  }

  fn read<'a>(&'a mut self, amount: u64) -> ~[u8] {
    self.reader().read(amount)
  }

  fn seek<'a>(&'a mut self, amount: i64) {
    self.reader().seek(amount)
  }

  fn length<'a>(&'a self) -> u64 {
    self.imm_reader().length()
  }

  fn available<'a>(&'a self) -> u64 {
    self.imm_reader().available()
  }

  fn position<'a>(&'a self) -> u64 {
    self.imm_reader().position()
  }
}

impl io::stream::Writable for Pixelmap {
  fn write<'a>(&'a mut self, buffer: &[u8]) {
    self.writer().write(buffer)
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    self.writer().writeFromPtr(buf_p, amount);
  }

  fn append<'a>(&'a mut self, buffer: &[u8]) {
    self.writer().append(buffer)
  }

  fn seek<'a>(&'a mut self, amount: i64) {
    self.writer().seek(amount)
  }

  fn length<'a>(&'a self) -> u64 {
    self.imm_writer().length()
  }

  fn available<'a>(&'a self) -> u64 {
    self.imm_writer().available()
  }

  fn position<'a>(&'a self) -> u64 {
    self.imm_writer().position()
  }
}

impl io::stream::Streamable for Pixelmap {
  fn readInto<'a>(&'a mut self, buffer: &mut [u8]) -> bool {
    self.stream().readInto(buffer)
  }

  fn readIntoPtr<'a>(&'a mut self, buf_p: *mut u8, amount: u64) -> bool {
    self.stream().readIntoPtr(buf_p, amount)
  }

  fn read<'a>(&'a mut self, amount: u64) -> ~[u8] {
    self.stream().read(amount)
  }

  fn write<'a>(&'a mut self, buffer: &[u8]) {
    self.stream().write(buffer)
  }

  fn writeFromPtr(&mut self, buf_p: *u8, amount: u64) {
    self.stream().writeFromPtr(buf_p, amount);
  }

  fn append<'a>(&'a mut self, buffer: &[u8]) {
    self.stream().append(buffer)
  }

  fn seek<'a>(&'a mut self, amount: i64) {
    self.stream().seek(amount)
  }

  fn length<'a>(&'a self) -> u64 {
    self.imm_stream().length()
  }

  fn available<'a>(&'a self) -> u64 {
    self.imm_stream().available()
  }

  fn position<'a>(&'a self) -> u64 {
    self.imm_stream().position()
  }
}
