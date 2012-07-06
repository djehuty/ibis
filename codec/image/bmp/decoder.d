module codec.image.bmp.decoder;

import codec.image.decoder;

import io.stream;
import io.pixelmap;

import system.architecture;
import system.cpu;

final class BmpDecoder {
private:
  enum State {
    Init,

    Invalid,
    Required,

    ReadHeaders,
    ReadBitmapSize,

    InterpretHeader,

    ReadOSX1,
    ReadOSX2,
    ReadWin,

    ReadWinPalette,
    ReadOSX1Palette,
    ReadOSX2Palette,

    ReadWinBitfields,

    DecodeWin1bpp,
    DecodeWin2bpp,
    DecodeWin4bpp,
    DecodeWin8bpp,
    DecodeWin16bpp,
    DecodeWin24bpp,
    DecodeWin32bpp,

    RenderWin1bpp,
    RenderWin2bpp,
    RenderWin4bpp,
    RenderWin8bpp,
    RenderWin16bpp,
    RenderWin24bpp,
    RenderWin32bpp,
  }

  align(2) struct FileHeader {
    ushort _fileHeaderType;
    uint   _fileHeaderSize;
    ushort _fileHeaderReserved1;
    ushort _fileHeaderReserved2;
    uint   _fileHeaderOffBits;
  }

  align(2) struct InfoHeader {
    uint   biWidth;
    int    biHeight;
    ushort biPlanes;
    ushort biBitCount;
    uint   biCompression;
    uint   biSizeImage;
    int    biXPelsPerMeter;
    int    biYPelsPerMeter;
    uint   biClrUsed;
    uint   biClrImportant;
  }

  align(2) struct OS2_1InfoHeader {
    ushort biWidth;
    ushort biHeight;
    ushort biPlanes;
    ushort biBitCount;
  }

  align(2) struct OS2_2InfoHeader {
    uint   biWidth;
    uint   biHeight;
    ushort biPlanes;
    ushort biBitCount;
    uint   biCompression;
    uint   biSizeImage;
    uint   biXPelsPerMeter;
    uint   biYPelsPerMeter;
    uint   biClrUsed;
    uint   biClrImportant;

    /* extended os2 2.x stuff */

    ushort usUnits;
    ushort usReserved;
    ushort usRecording;
    ushort usRendering;
    uint   cSize1;
    uint   cSize2;
    uint   ulColorEncoding;
    uint   ulIdentifier;
  }

  Stream _input;

  FileHeader _fileHeader;
  InfoHeader _infoHeader;

  OS2_1InfoHeader os2_1_bi;
  OS2_2InfoHeader os2_2_bi;

  // Bit masks (for bitfields (biCompression == 3) compression)
  uint[3] _bitfields;
  uint[3] _bitfieldShifts;
  uint[3] _bitfieldSizes;
  uint[3] _bitfieldMaxes;

  // Color Palette
  uint      _paletteNumColors;
  uint[256] _palette;

  // Render information
  int   _bytesPerRow;
  ulong _bytesLeft;

  ulong _y;
  ulong _x;

  // RLE info
  int   _absoluteCount;
  bool  _deltaPairNext;

  // State Machine Status
  State _state;
  State _nextState;
  State _currentState;

  // Cpu information
  Cpu   _cpu;

  void _init() {
    _state = State.ReadHeaders;
  }

  void _readHeaders() {
    ubyte* _fileHeaderptr = cast(ubyte*)&_fileHeader;
    _input.read(_fileHeaderptr[0..FileHeader.sizeof]);

    if (_fileHeader._fileHeaderType != _cpu.fromLittleEndian16(0x4d42)) {
      _state = State.Invalid;
    }
    else {
      _state = State.ReadBitmapSize;
    }
  }

  void _readBitmapSize() {
    uint biSize;
    ubyte* ptr = cast(ubyte*)&biSize;

    if (_input.available < 4) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.read(ptr[0..4]);
    switch (biSize) {
      case 0x0C: // osx 1.0
        _state = State.ReadOSX1;
        break;

      case 0xF0: // osx 2.0
        _state = State.ReadOSX2;
        break;

      case 0x28: // windows
        _state = State.ReadWin;
        break;

      default:
        // Unknown/Unsupported image
        _state = State.Invalid;
    }
  }

  void _readWindowsInfo() {
    if (_input.available < 36) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_infoHeader;
    _input.read(ptr[0..36]);

    _paletteNumColors = 0;

    _state = State.InterpretHeader;
  }

  void _interpretHeader() {
    // Skip to image data according to padding detailed in header
    int offset = cast(int)_fileHeader._fileHeaderOffBits - 54;

    if (offset > 0) {
      if (_input.available < offset) {
        // Required
        _currentState = _state;
        _state = State.Required;
        return;
      }

      _input.seek(offset);
    }

    switch (_infoHeader.biBitCount) {
      case 1:
        _state = State.ReadWinPalette;
        _nextState = State.DecodeWin1bpp;
        _paletteNumColors = 2;
        break;

      case 4:
        _state = State.ReadWinPalette;
        _nextState = State.DecodeWin4bpp;
        _paletteNumColors = 16;
        break;

      case 8:
        _state = State.ReadWinPalette;
        _nextState = State.DecodeWin8bpp;
        _paletteNumColors = 256;
        break;

      case 16:
        _state = State.ReadWinBitfields;
        _nextState = State.DecodeWin16bpp;
        break;

      case 24:
        _state = State.DecodeWin24bpp;
        break;

      case 32:
        _state = State.ReadWinBitfields;
        _nextState = State.DecodeWin32bpp;
        break;

      default:
        _state = State.Invalid;
        break;
    }
  }

  void _readWinPalette() {
    if (_infoHeader.biClrUsed == 0) {
      _infoHeader.biClrUsed = _paletteNumColors;
    }

    uint sizeOfPalette = _infoHeader.biClrUsed * 4;

    if (_input.available < sizeOfPalette) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)_palette.ptr;
    _input.read(ptr[0..sizeOfPalette]);

    for (size_t i = 0; i < _paletteNumColors; i++) {
      _palette[i] |= 0xff000000;
    }

    _state = _nextState;
  }

  void _readWinBitfields() {
    if (_infoHeader.biCompression == 3) {
      if (_input.available < _bitfields.sizeof) {
        // Required
        _currentState = _state;
        _state = State.Required;
        return;
      }

      _input.read((cast(ubyte*)_bitfields.ptr)[0.._bitfields.sizeof]);

      _bitfieldShifts[0..2] = 0;
      _bitfieldMaxes[0..2] = 0;
      _bitfieldSizes[0..2] = 0;

      for (size_t i = 0; i < 3; i++) {
        uint check = 0x1;

        while (check > 0 && (_bitfields[i] & check) == 0) {
          _bitfieldShifts[i]++;

          check <<= 1;
        }

        while (check > 0 && (_bitfields[i] & check) > 0) {
          _bitfieldMaxes[i] = (_bitfieldMaxes[i] << 1) | 1;
          _bitfieldSizes[i]++;

          check <<= 1;
        }
      }
    }
    else {
      if (_infoHeader.biBitCount == 16) {
        // Default is 5-5-5
        _bitfields[0] = 0x00007c00;
        _bitfields[1] = 0x000003e0;
        _bitfields[2] = 0x0000001f;

        _bitfieldShifts[0] = 10;
        _bitfieldShifts[1] = 5;
        _bitfieldShifts[2] = 0;

        _bitfieldMaxes[0] = 0x1f;
        _bitfieldMaxes[1] = 0x1f;
        _bitfieldMaxes[2] = 0x1f;

        _bitfieldSizes[0] = 5;
        _bitfieldSizes[1] = 5;
        _bitfieldSizes[2] = 5;
      }
      else if (_infoHeader.biBitCount == 32) {
        // Default is 8-8-8
        _bitfields[0] = 0x00ff0000;
        _bitfields[1] = 0x0000ff00;
        _bitfields[2] = 0x000000ff;

        _bitfieldShifts[0] = 16;
        _bitfieldShifts[1] = 8;
        _bitfieldShifts[2] = 0;

        _bitfieldMaxes[0] = 0xff;
        _bitfieldMaxes[1] = 0xff;
        _bitfieldMaxes[2] = 0xff;

        _bitfieldSizes[0] = 8;
        _bitfieldSizes[1] = 8;
        _bitfieldSizes[2] = 8;
      }
      else {
        _state = State.Invalid;
      }
    }

    _state = _nextState;
  }

  void _decodeWin1bpp() {
    _bytesPerRow = (_infoHeader.biWidth + 7) / 8;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin1bpp;
  }

  void _renderWin1bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte[] row = new ubyte[_bytesPerRow];
    _input.read(row);

    size_t numPixels = 0;
    foreach(color; row) {
      for (size_t idx = 0; idx < 8; idx++) {
        uint clr = (color >> idx) & 0x1;
        if (numPixels >= _infoHeader.biWidth) {
          break;
        }

        clr = _palette[clr];

        uint red   = (clr & 0xff0000) >> 16;
        uint green = (clr & 0xff00) >> 8;
        uint blue  = (clr & 0xff) >> 0;

        pixelmap.writeRGBA(clr);

        numPixels++;
      }
    }
  }

  void _decodeWin2bpp() {
    _bytesPerRow = (_infoHeader.biWidth + 3) / 4;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin1bpp;
  }

  void _renderWin2bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte[] row = new ubyte[_bytesPerRow];
    _input.read(row);

    size_t numPixels = 0;
    foreach(color; row) {
      for (size_t idx = 0; idx < 4; idx++) {
        uint clr = (color >> (idx * 2)) & 0x3;
        if (numPixels >= _infoHeader.biWidth) {
          break;
        }

        clr = _palette[clr];

        uint red   = (clr & 0xff0000) >> 16;
        uint green = (clr & 0xff00) >> 8;
        uint blue  = (clr & 0xff) >> 0;

        pixelmap.writeRGBA(clr);

        numPixels++;
      }
    }
  }
  void _decodeWin4bpp() {
    _bytesPerRow = (_infoHeader.biWidth + 1) / 2;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression == 2) {
      // RLE-4
      _bytesLeft = _infoHeader.biSizeImage;
    }
    else if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin4bpp;
  }

  void _renderRleWin4bpp(Pixelmap pixelmap) {
    if (_bytesLeft == 0) {
      _state = State.Invalid;
      return;
    }

    // Attempt to read in the bitmap data
    int bytesAvailable = _input.available;
    if (bytesAvailable > _bytesLeft) {
      bytesAvailable = _bytesLeft;
    }

    // Ensure bytes to read and parse is a multiple of 2
    if ((bytesAvailable % 2) == 1) {
      bytesAvailable--;
    }

    ubyte[] data = new ubyte[bytesAvailable];

    _input.read(data);

    // Interpret each pair
    for (size_t idx = 0; idx < bytesAvailable; idx += 2) {
      ubyte count = data[idx];
      ubyte color = data[idx + 1];

      if (_deltaPairNext) {
        int x = cast(byte)count;
        int y = cast(byte)color;

        pixelmap.seek(x, -y);

        _deltaPairNext = false;
      }
      else if (_absoluteCount > 0) {
        uint[2] clr;

        clr[0] = (count >> 0) & 0xf;
        clr[1] = (count >> 4) & 0xf;

        clr[0] = _palette[clr[0]];
        clr[1] = _palette[clr[1]];

        pixelmap.writeRGBA(clr[0]);
        _absoluteCount--;

        if (_absoluteCount > 0) {
          pixelmap.writeRGBA(clr[1]);
          _absoluteCount--;
        }

        if (_absoluteCount > 0) {
          clr[0] = (color >> 0) & 0xf;
          clr[1] = (color >> 4) & 0xf;

          clr[0] = _palette[clr[0]];
          clr[1] = _palette[clr[1]];

          pixelmap.writeRGBA(clr[0]);
          _absoluteCount--;
        }

        if (_absoluteCount > 0) {
          pixelmap.writeRGBA(clr[1]);
          _absoluteCount--;
        }
      }
      else if (count == 0) {
        if (color == 0) {
          // End of line (reposition to next line)
          pixelmap.reposition(0, pixelmap.y - 1);
        }
        else if (color == 1) {
          // End of bitmap
          _bytesLeft = 0;
          return;
        }
        else if (color == 2) {
          // Delta (reposition)
          // Next pair gives coordinates offset from the current position
          _deltaPairNext = true;
        }
        else {
          // Absolute Mode (just literally express the follow 3-255 bytes)
          _absoluteCount = color;
        }
      }
      else {
        uint[2] clr;

        clr[0] = (color >> 0) & 0xf;
        clr[1] = (color >> 4) & 0xf;

        clr[0] = _palette[clr[0]];
        clr[1] = _palette[clr[1]];

        for (int j = 0; j < count; j += 2) {
          pixelmap.writeRGBA(clr[0]);

          if (j + 1 < count) {
            pixelmap.writeRGBA(clr[1]);
          }
        }
      }
    }
  }

  void _renderWin4bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);

    ubyte[] row = new ubyte[_bytesPerRow];
    _input.read(row);

    size_t numPixels = 0;
    foreach(color; row) {
      for (size_t idx = 0; idx < 2; idx++) {
        uint clr = (color >> (idx * 4)) & 0xf;
        if (numPixels >= _infoHeader.biWidth) {
          break;
        }

        clr = _palette[clr];
        pixelmap.writeRGBA(clr);

        numPixels++;
      }
    }

    _y++;
    if (_y == _infoHeader.biHeight) {
      // Done
    }
  }

  void _decodeWin8bpp() {
    _bytesPerRow = _infoHeader.biWidth;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression == 1) {
      // RLE-8
      _bytesLeft = _infoHeader.biSizeImage;
    }
    else if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin8bpp;
  }

  void _renderWin8bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);

    ubyte[] row = new ubyte[_bytesPerRow];
    _input.read(row);

    size_t numPixels = 0;
    foreach(color; row) {
      if (numPixels >= _infoHeader.biWidth) {
        break;
      }

      uint clr = _palette[color];
      pixelmap.writeRGBA(clr);

      numPixels++;
    }

    _y++;
  }

  void _renderRleWin8bpp(Pixelmap pixelmap) {
    if (_bytesLeft == 0) {
      _state = State.Invalid;
      return;
    }

    // Attempt to read in the bitmap data
    int bytesAvailable = _input.available;
    if (bytesAvailable > _bytesLeft) {
      bytesAvailable = _bytesLeft;
    }

    // Ensure bytes to read and parse is a multiple of 2
    if ((bytesAvailable % 2) == 1) {
      bytesAvailable--;
    }

    ubyte[] data = new ubyte[bytesAvailable];

    _input.read(data);

    // Interpret each pair
    for (size_t idx = 0; idx < bytesAvailable; idx += 2) {
      ubyte count = data[idx];
      ubyte color = data[idx + 1];

      if (_deltaPairNext) {
        int x = cast(byte)count;
        int y = cast(byte)color;

        pixelmap.seek(x, -y);

        _deltaPairNext = false;
      }
      else if (_absoluteCount > 0) {
        uint clr = _palette[count];
        pixelmap.writeRGBA(clr);
        _absoluteCount--;

        if (_absoluteCount > 0) {
          clr = _palette[color];
          pixelmap.writeRGBA(clr);
          _absoluteCount--;
        }
      }
      else if (count == 0) {
        if (color == 0) {
          // End of line (reposition to next line)
          pixelmap.reposition(0, pixelmap.y - 1);
        }
        else if (color == 1) {
          // End of bitmap
          _bytesLeft = 0;
          return;
        }
        else if (color == 2) {
          // Delta (reposition)
          // Next pair gives coordinates offset from the current position
          _deltaPairNext = true;
        }
        else {
          // Absolute Mode (just literally express the follow 3-255 bytes)
          _absoluteCount = color;
        }
      }
      else {
        uint clr = _palette[color];
        for (int j = 0; j < count; j++) {
          pixelmap.writeRGBA(clr);
        }
      }
    }
  }

  void _decodeWin16bpp() {
    _bytesPerRow = _infoHeader.biWidth * 2;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin16bpp;
  }

  void _renderWin16bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);

    ushort[] row = new ushort[_bytesPerRow / 2];
    _input.read(cast(ubyte[])row);

    size_t numPixels = 0;
    foreach(color; row) {
      if (numPixels >= _infoHeader.biWidth) {
        break;
      }

      uint red   = (color & cast(ushort)_bitfields[0]) >> _bitfieldShifts[0];
      uint green = (color & cast(ushort)_bitfields[1]) >> _bitfieldShifts[1];
      uint blue  = (color & cast(ushort)_bitfields[2]) >> _bitfieldShifts[2];

      red   <<= 8 - _bitfieldSizes[0];
      green <<= 8 - _bitfieldSizes[1];
      blue  <<= 8 - _bitfieldSizes[2];

      uint clr = red | (green << 8) | (blue << 16) | 0xff000000;
      pixelmap.writeRGBA(clr);

      numPixels++;
    }

    _y++;
  }

  void _decodeWin24bpp() {
    _bytesPerRow = _infoHeader.biWidth * 3;

    if (_bytesPerRow % 4 > 0) {
      int bytesForPadding = 4 - (_bytesPerRow % 4);

      _bytesPerRow += bytesForPadding;
    }

    if (_infoHeader.biCompression != 0) {
      _state = State.Invalid;
      return;
    }

    _state = State.RenderWin24bpp;
  }

  void _renderWin24bpp(Pixelmap pixelmap) {
    // Attempt to acquire a row

    if (_input.available < _bytesPerRow) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte[] fuh = new ubyte[_bytesPerRow];
    _input.read(fuh);

    pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);

    for (size_t idx = 0; idx < _infoHeader.biWidth; idx++) {
      uint red   = fuh[(idx * 3) + 2];
      uint green = fuh[(idx * 3) + 1];
      uint blue  = fuh[(idx * 3) + 0];

      uint clr = red | (green << 8) | (blue << 16) | 0xff000000;
      pixelmap.writeRGBA(clr);
    }

    _y++;
  }

  void _decodeWin32bpp() {
    if (!(_infoHeader.biCompression == 0 || _infoHeader.biCompression == 3)) {
      _state = State.Invalid;
    }

    // RGB compression (none)
    _bytesPerRow    = _infoHeader.biWidth * 4;

    _state = State.RenderWin32bpp;
  }

  void _renderWin32bpp(Pixelmap pixelmap) {
    uint available = _input.available;
    available /= 4;

    if (available == 0) {
      // Required
      _currentState = _state;
      _state = State.Required;
      return;
    }

    uint[] fileData = new uint[available];
    _input.read(cast(ubyte[])fileData);

    if (_x == 0 && _y == 0) {
      pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);
    }

    foreach(color; fileData) {
      uint red   = (color & _bitfields[0]) >> _bitfieldShifts[0];
      uint green = (color & _bitfields[1]) >> _bitfieldShifts[1];
      uint blue  = (color & _bitfields[2]) >> _bitfieldShifts[2];

      uint clr = red | (green << 8) | (blue << 16) | 0xff000000;
      pixelmap.writeRGBA(clr | 0xff000000);
      _x++;
      if (_x == width()) {
        _x = 0;
        _y++;
        pixelmap.reposition(0, _infoHeader.biHeight - _y - 1);
      }
    }
  }

public:
  this(Stream input) {
    _input = input;
  }

  ImageDecoder decoder() {
    return new ImageDecoder(&decode,
                            &description,
                            &tags,
                            &width,
                            &height);
  }

  ImageDecoder.State decode(Pixelmap pixelmap) {
    _cpu = Architecture.currentCpu;

    bool hasMultipleFrames;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadHeaders:
          _readHeaders();
          break;

        case State.ReadBitmapSize:
          _readBitmapSize();
          break;

        case State.ReadWin:
          _readWindowsInfo();
          break;

        case State.InterpretHeader:
          _interpretHeader();
          break;

        case State.ReadWinPalette:
          _readWinPalette();
          break;

        case State.ReadWinBitfields:
          _readWinBitfields();
          break;

        case State.DecodeWin1bpp:
          _decodeWin1bpp();
          break;

        case State.RenderWin1bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _renderWin1bpp(pixelmap);
          break;

        case State.DecodeWin2bpp:
          _decodeWin2bpp();
          break;

        case State.RenderWin2bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _renderWin2bpp(pixelmap);
          break;

        case State.DecodeWin4bpp:
          _decodeWin4bpp();
          break;

        case State.RenderWin4bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          if (_infoHeader.biCompression == 2) {
            _renderRleWin4bpp(pixelmap);
          }
          else {
            _renderWin4bpp(pixelmap);
          }
          break;

        case State.DecodeWin8bpp:
          _decodeWin8bpp();
          break;

        case State.RenderWin8bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          if (_infoHeader.biCompression == 1) {
            _renderRleWin8bpp(pixelmap);
          }
          else {
            _renderWin8bpp(pixelmap);
          }
          break;

        case State.DecodeWin16bpp:
          _decodeWin16bpp();
          break;

        case State.RenderWin16bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _renderWin16bpp(pixelmap);
          break;

        case State.DecodeWin24bpp:
          _decodeWin24bpp();
          break;

        case State.RenderWin24bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _renderWin24bpp(pixelmap);
          break;

        case State.DecodeWin32bpp:
          _decodeWin32bpp();
          break;

        case State.RenderWin32bpp:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _renderWin32bpp(pixelmap);
          break;

        case State.Required:
          _state = _currentState;

          if (_state <= State.ReadWin) {
            return ImageDecoder.State.Insufficient;
          }

          return ImageDecoder.State.Accepted;

        default:
        case State.Invalid:
          return ImageDecoder.State.Invalid;
      }
    }

    return ImageDecoder.State.Invalid;
  }

  ImageDecoder.State nextFrame(Pixelmap view) {
    return ImageDecoder.State.Invalid;
  }

  char[] description() {
    return "Bitmap Image";
  }

  char[][] tags() {
    return ["bmp"];
  }

  ulong width() {
    if (_state <= State.ReadWin) {
      return 0;
    }

    return _infoHeader.biWidth;
  }

  ulong height() {
    if (_state <= State.ReadWin) {
      return 0;
    }

    return _infoHeader.biHeight;
  }
}
