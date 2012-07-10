module codec.image.pcx.decoder;

import codec.image.decoder;

import io.stream;
import io.pixelmap;

import system.architecture;
import system.cpu;

final class PcxDecoder {
private:
  enum State {
    Init,

    Invalid,
    Required,

    ReadHeaders,

    ReadPalette,

    Decode,
    Render,
  }

  align(1) struct PcxHeader {
    ubyte     manufacturer;
    ubyte     ver;

    ubyte     encodingScheme;
    ubyte     bitsPerPixel;
    ushort    left;
    ushort    top;
    ushort    right;
    ushort    bottom;

    ushort    horizontalDPI;
    ushort    verticalDPI;

    ubyte[48] palette;

    ubyte     reserved;
    ubyte     planes;

    ushort    bytesPerLine;
    ushort    paletteType;

    ushort    width;
    ushort    height;

    ubyte[54] padding;
  }

  Stream _input;

  // Cpu information
  Cpu   _cpu;

  State _state;
  State _currentState;

  uint[256] _palette;

  PcxHeader _header;

  uint _scanLineLength;
  uint _linePaddingSize;

  // Render states
  uint    _subState;
  uint    _runCount;
  uint    _runValue;
  uint    _scanLineTotal;
  uint    _total;
  ubyte[] _buffer;

  void _init() {
    _state = State.ReadHeaders;
  }

  void _readHeaders() {
    if (_input.available < _header.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_header;
    _input.read(ptr[0.._header.sizeof]);

    if (_header.manufacturer != 10) {
      _state = State.Invalid;
      return;
    }

    if (_header.ver > 5) {
      _state = State.Invalid;
      return;
    }

    // Interpret palette

    for (size_t idx = 0; idx < 16; idx++) {
      uint red   = _header.palette[(idx * 3) + 0];
      uint green = _header.palette[(idx * 3) + 1];
      uint blue  = _header.palette[(idx * 3) + 2];

      _palette[idx] = red | (green << 8) | (blue << 16) | 0xff000000;
    }

    _state = State.ReadPalette;
  }

  void _readPalette() {
    if (_header.ver >= 5) {
      // Possible second palette at the end of the file
      if (_input.available < 769) {
        _currentState = State.Required;
        _state = State.Required;
        return;
      }

      long seekAmount = _input.available - 769;
      _input.seek(seekAmount);
      ubyte[1] identifier;
      _input.read(identifier);

      if (identifier[0] != 0x0c) {
        _input.seek(-seekAmount);

        _currentState = State.Required;
        _state = State.Required;
        return;
      }

      ubyte[768] palette;

      _input.read(palette);
      _input.seek(-(seekAmount + 769));

      // Interpret palette
      for (size_t idx = 0; idx < 256; idx++) {
        uint red   = palette[(idx * 3) + 0];
        uint green = palette[(idx * 3) + 1];
        uint blue  = palette[(idx * 3) + 2];
        
        _palette[idx] = red | (green << 8) | (blue << 16) | 0xff000000;
      }
    }

    _state = State.Decode;
  }

  void _decode() {
    _scanLineLength = _header.planes * _header.bytesPerLine;
    _linePaddingSize = (_scanLineLength * (8 / _header.bitsPerPixel)) - width();

    _state = State.Render;

    if (!(_header.bitsPerPixel == 8 && _header.planes == 1)) {
      _buffer = new ubyte[_scanLineLength];
    }
  }

  void _render(Pixelmap pixelmap) {
    ubyte[] bytes;
    bytes = _input.read(_input.available);

    for (size_t idx = 0; idx < bytes.length; idx++) {
      switch (_subState) {
        case 0:
          if ((bytes[idx] & 0xC0) == 0xC0) {
            _runCount = bytes[idx] & 0x3f;
            _subState = 1;
          }
          else {
            _runCount = 1;
            _runValue = bytes[idx];
            _subState = 2;
          }
          break;

          // Looking for run value byte
        case 1:
          _runValue = bytes[idx];
          _subState = 2;
          break;
      }

      if (_subState == 2) {
        for (size_t n = 0; n < _runCount; n++) {
          if (_header.bitsPerPixel == 8 && _header.planes == 1) {
            pixelmap.writeR8G8B8A8(_palette[_runValue]);
          }
          else {
            _buffer[_scanLineTotal] = _runValue;
          }

          _scanLineTotal++;
          _total++;

          if (_scanLineTotal == _scanLineLength) {
            _scanLineTotal = 0;

            if (!(_header.bitsPerPixel == 8 && _header.planes == 1)) {
              // TODO: Interpret scan line buffer
            }
          }

          if (_total == (width() * height())) {
            _state = State.Invalid;
            return;
          }
        }

        _subState = 0;
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

    ImageDecoder.State ret = ImageDecoder.State.Invalid;
    bool hasMultipleFrames;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadHeaders:
          _readHeaders();
          break;

        case State.ReadPalette:
          _readPalette();
          break;

        case State.Decode:
          _decode();
          break;

        case State.Render:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          _render(pixelmap);
          break;

        case State.Required:
          _state = _currentState;

          if (_state <= State.ReadHeaders) {
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
    return "PCX Image";
  }

  char[][] tags() {
    return ["pcx", "pcc"];
  }

  ulong width() {
    if (_state < State.ReadHeaders) {
      return 0;
    }

    return _header.right - _header.left + 1;
  }

  ulong height() {
    if (_state < State.ReadHeaders) {
      return 0;
    }

    return _header.bottom - _header.top + 1;
  }
}
