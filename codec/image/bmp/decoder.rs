#[link(name = "codec-image-bmp-decoder", vers = "1.0", package_id = "codec-image-bmp-decoder")];

use std::vec;
use std::iter;

mod io {
  extern mod console  = "io-console";
  extern mod stream   = "io-stream";
  extern mod pixelmap = "io-pixelmap";
}

pub struct Info {
  width: u64,
  height: u64,
  colorDepth: io::pixelmap::ColorDepth,
  bitsPerPixel: u32,
}

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

  // RLE
  absoluteCount: i32,
  deltaPairNext: bool,

  // StateMachine
  state: State,
  nextState: State,
  currentState: State,

  // Stream
  input: ~io::stream::Readable,

  bytesPerRow: u64,
  bytesLeft:   u64,
}

pub fn fromStream(reader: ~io::stream::Readable) -> ~Decoder {
  ~Decoder {
    input: reader,
    state: ReadHeaders,

    // Defaults
    y: 0,
    x: 0,
    width: 0,
    height: 0,
    absoluteCount: 0,
    deltaPairNext: false,
    nextState: ReadHeaders,
    currentState: ReadHeaders,
    bytesPerRow: 0,
    bytesLeft:   0,
    palette: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
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
  pub fn read(&mut self, mut pixelmap: ~io::pixelmap::Pixelmap) {
    loop {
      match self.state {
        Init => self.readHeaders(),

        Accepted => {},
        Invalid => {},
        Required => { self.state = self.currentState; },

        ReadHeaders => self.readHeaders(),
        ReadBitmapSize => self.readBitmapSize(),

        InterpretHeader => self.interpretHeader(),

        ReadOSX1 => {},
        ReadOSX2 => {},
        ReadWindows => self.readWindowsInfo(),

        ReadWindowsPalette => self.readWindowsPalette(),
        ReadOSX1Palette => {},
        ReadOSX2Palette => {},

        ReadWindowsBitfields => self.readWindowsBitfields(),

        DecodeWindows1bpp => self.decodeWindows1bpp(),
        DecodeWindows2bpp => self.decodeWindows2bpp(),
        DecodeWindows4bpp => self.decodeWindows4bpp(),
        DecodeWindows8bpp => self.decodeWindows8bpp(),
        DecodeWindows16bpp => self.decodeWindows16bpp(),
        DecodeWindows24bpp => self.decodeWindows24bpp(),
        DecodeWindows32bpp => self.decodeWindows32bpp(),

        RenderWindows1bpp => self.renderWindows1bpp(pixelmap),
        RenderWindows2bpp => self.renderWindows2bpp(pixelmap),
        RenderWindows4bpp => {
          if self.infoHeader.biCompression == 2 {
            self.renderWindowsRLE4bpp(pixelmap);
          }
          else {
            self.renderWindows4bpp(pixelmap);
          }
        },
        RenderWindows8bpp => {
          if self.infoHeader.biCompression == 1 {
            self.renderWindowsRLE8bpp(pixelmap);
          }
          else {
            self.renderWindows8bpp(pixelmap);
          }
        },
        RenderWindows16bpp => self.renderWindows16bpp(pixelmap),
        RenderWindows24bpp => self.renderWindows24bpp(pixelmap),
        RenderWindows32bpp => self.renderWindows32bpp(pixelmap),
      }

      if (self.state as u32 == Invalid as u32 || self.state as u32 == Required as u32 || self.state as u32 == Accepted as u32) {
        break;
      }
    }
  }

  fn readHeaders(&mut self) {
    // Read into fileHeader
    self.input.readIntoPtr(&mut self.fileHeader as *mut FileHeader as *mut u8, 14);

    // Determine if file is a bitmap
    if (self.fileHeader.header_type != 0x4d42) {
      self.state = Invalid;
    }
    else {
      self.state = ReadBitmapSize;
    }
  }

  fn readBitmapSize(&mut self) {
    if (self.input.available() < 4) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    // Read biSize
    let mut biSize = 0 as u32;
    self.input.readIntoPtr(&mut biSize as *mut u32 as *mut u8, 4);

    self.state = match(biSize){
      0x0c => ReadOSX1,
      0xf0 => ReadOSX2,
      0x28 => ReadWindows,
      _    => Invalid
    };
  }

  fn readWindowsInfo(&mut self) {
    if (self.input.available() < 36) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    // Read into infoHeader
    self.input.readIntoPtr(&mut self.infoHeader as *mut InfoHeader as *mut u8, 36);

    self.paletteNumColors = 0;

    self.state = InterpretHeader;
  }

  fn interpretHeader(&mut self) {
    let offset = self.fileHeader.offBits as u64 - 54;

    if (offset > 0) {
      if (self.input.available() < offset) {
        self.currentState = self.state;
        self.state = Required;
        return;
      }

      self.input.seek(offset as i64);
    }

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
        self.state = DecodeWindows24bpp;
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

  fn readWindowsPalette(&mut self) {
    if (self.infoHeader.biClrUsed == 0) {
      self.infoHeader.biClrUsed = self.paletteNumColors;
    }

    let sizeOfPalette = self.infoHeader.biClrUsed as u64 * 4;

    if (self.input.available() < sizeOfPalette) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    self.input.readIntoPtr(&self.palette as *mut u32 as *mut u8, sizeOfPalette);

    for i in iter::range_step(0, self.paletteNumColors, 1) {
      self.palette[i] |= 0xff000000;
    }

    self.state = self.nextState;
  }

  fn readWindowsBitfields(&mut self) {
    if (self.infoHeader.biCompression == 3) {
      if (self.input.available() < 12) {
        self.currentState = self.state;
        self.state = Required;
        return;
      }

      self.input.readIntoPtr(&self.bitfields as *mut u32 as *mut u8, 12);

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

    self.state = self.nextState;
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

  fn renderWindows1bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row = vec::with_capacity(self.bytesPerRow as uint);
    self.input.readInto(row);

    let mut numPixels = 0;
    for color in row.iter() {
      for i in iter::range_step(0, 8, 1) {
        let clr = (color >> i as u8) & 0x1;

        if (numPixels >= self.infoHeader.biWidth) {
          break;
        }

        let actual = self.palette[clr];

        pixelmap.writeR8G8B8A8(actual);
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

  fn renderWindows2bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
    self.input.readInto(row);

    pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

    let mut numPixels = 0;
    for &color in row.iter() {
      for i in iter::range_step(0, 4, 1) {
        if (numPixels >= self.infoHeader.biWidth) {
          break;
        }

        let clr = (color >> (i * 2)) & 0x3;

        let actual = self.palette[clr];
        pixelmap.writeR8G8B8A8(actual);

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

  fn renderWindows4bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
    self.input.readInto(row);

    pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

    let mut numPixels = 0;
    for &color in row.iter() {
      for i in iter::range_step(0, 2, 1) {
        if (numPixels >= self.infoHeader.biWidth) {
          break;
        }

        let clr = (color >> (i * 4)) & 0xf;

        let actual = self.palette[clr];
        pixelmap.writeR8G8B8A8(actual);

        numPixels += 1;
      }
    }

    self.y += 1;
    if self.y == self.infoHeader.biHeight as u64 {
      self.state = Accepted;
    }
  }

  fn renderWindowsRLE4bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
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

  fn renderWindows8bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row: ~[u8] = vec::with_capacity(self.bytesPerRow as uint);
    self.input.readInto(row);

    pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

    let mut numPixels = 0;
    for &color in row.iter() {
      if (numPixels >= self.infoHeader.biWidth) {
        break;
      }

      let clr = self.palette[color];
      pixelmap.writeR8G8B8A8(clr);

      numPixels += 1;
    }

    self.y += 1;
    if self.y == self.infoHeader.biHeight as u64 {
      self.state = Accepted;
    }
  }

  fn renderWindowsRLE8bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
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

  fn renderWindows16bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row: ~[u16] = vec::with_capacity((self.bytesPerRow as uint) / 2);
    self.input.readIntoPtr(&mut row as *mut ~[u16] as *mut u8, self.bytesPerRow);

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

      pixelmap.writeR8G8B8A8(clr);

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

  fn renderWindows24bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    // Attempt to acquire a row
    if (self.input.available() < self.bytesPerRow) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    let mut row = vec::with_capacity(self.bytesPerRow as uint);
    self.input.readInto(row);

    pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);

    for i in iter::range_step(0, self.infoHeader.biWidth, 1) {
      let red   = row[(i * 3) + 2] as u32;
      let green = row[(i * 3) + 1] as u32;
      let blue  = row[(i * 3) + 0] as u32;

      let clr = red | (green << 8) | (blue << 16) | 0xff000000;

      pixelmap.writeR8G8B8A8(clr)
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

  fn renderWindows32bpp(&mut self, pixelmap: &mut io::pixelmap::Pixelmap) {
    if (self.input.available() < 4) {
      self.currentState = self.state;
      self.state = Required;
      return;
    }

    if (self.x == 0 && self.y == 0) {
      pixelmap.reposition(0, (self.infoHeader.biHeight as u64 - self.y - 1) as u64);
    }

    let mut row: ~[u32] = vec::with_capacity((self.bytesPerRow as uint) / 4);
    self.input.readIntoPtr(&mut row as *mut ~[u32] as *mut u8, self.bytesPerRow);

    for color in row.iter() {
      let red   = ((color & self.bitfields[0]) >> self.bitfieldShifts[0])
                << (8 - self.bitfieldSizes[0]);
      let green = ((color & self.bitfields[1]) >> self.bitfieldShifts[1])
                << (8 - self.bitfieldSizes[1]);
      let blue  = ((color & self.bitfields[2]) >> self.bitfieldShifts[2])
                << (8 - self.bitfieldSizes[2]);

      let clr = red | (green << 8) | (blue << 16) | 0xff000000;

      pixelmap.writeR8G8B8A8(clr);

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
