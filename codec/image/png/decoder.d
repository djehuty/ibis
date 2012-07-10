module codec.image.png.decoder;

import codec.image.decoder;

import codec.data.zlib.decoder;
import codec.data.decoder;

import io.pass_through;

import io.stream;
import io.buffer;
import io.pixelmap;

import system.architecture;
import system.cpu;

import binding.c;

final class PngDecoder {
private:
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

    Decode,
    DecodeReadFilterType,

    UnfilterNone,
    UnfilterSub,
    UnfilterUp,
    UnfilterAverage,
    UnfilterPaeth,

    Render,

    Complete,
  }

  enum Chunk {
    IHDR = 0x52444849,
    PLTE = 0x45544c50,
    IDAT = 0x54414449,
    IEND = 0x444e4549,
  }

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

  enum FilterType : ubyte {
    None,
    Sub,
    Up,
    Average,
    Paeth
  }

  align(1) struct PngChunkHeader {
    uint length;
    uint type;
  }

  align(1) struct IHDR {
    uint  width;
    uint  height;
    ubyte bitDepth;
    ubyte colorType;
    ubyte compressionMethod;
    ubyte filterMethod;
    ubyte interlaceMethod;
  }

  align(1) struct PngColor {
    ubyte red;
    ubyte green;
    ubyte blue;
  }

  ubyte[8] _header;

  PngChunkHeader _chunkHeader;
  uint           _chunkCRC;

  uint _runningCRC;

  uint          _paletteCount;
  PngColor[256] _palette;
  uint[256]     _paletteRealized;

  // Chunks
  bool _haveIHDR;
  IHDR _IHDR;

  // Data
  ulong  _bytesDecoded;
  Buffer _decodedByteBuffer;
  Stream _decodedBytes;

  PassThrough _decoderSource;

  ZlibDecoder _decoder;

  // For Unfiltering
  ubyte _numSamples;
  uint  _nsamp;
  uint  _psamp;

  uint  _x;
  uint  _y;

  int  _expectedBytes;

  ImageType _imageType;

  // Array for holding the prior scanline's decoded bytes
  ubyte[][8] _bytes = [null, null, null, null, null, null, null, null];

  ubyte[8] _priorScannedByte;
  ubyte[8] _priorPixel;

  uint[8] _curComponent;

  ubyte _priorScannedComponent;

  // Width of the subimage
  uint[7] _interlaceWidths;

  // Height of the subimage
  uint[7] _interlaceHeights;

  // Current interlace pass
  uint _interlacePass;

  // Current scanline of the current pass
  uint _interlaceCurLine;

  // Decoder state
  State _filterState;

  static const uint _interlaceIncrementsY[7] = [8, 8, 8, 4, 4, 2, 2];

  static const uint _interlaceStartsX[7]     = [0, 4, 0, 2, 0, 1, 0];
  static const uint _interlaceStartsY[7]     = [0, 0, 4, 0, 2, 0, 1];

  // For low bpp color conversion
  static const ubyte _1bpp[2]  = [  0, 255];
  static const ubyte _2bpp[4]  = [  0,  85, 170, 255];
  static const ubyte _4bpp[16] = [  0,  17,  34,  51,  68,  85, 102,
                                  119, 136, 153, 170, 187, 204, 221,
                                  238, 255];

  Stream _input;

  // Cpu information
  Cpu   _cpu;

  State _state;
  State _currentState;

  void _init() {
    _decoderSource = new PassThrough(_input);
    _decoder = new ZlibDecoder(_decoderSource.input);

    _state = State.ReadHeader;
    _filterState = State.DecodeReadFilterType;
  }

  void _readHeader() {
    if (_input.available < 8) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.read(_header);

    // Verify Header
    if (_header != [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]) {
      _state = State.Invalid;
      return;
    }

    _state = State.ReadChunkHeader;
  }

  void _readChunkHeader() {
    if (_input.available < _header.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_chunkHeader;
    _input.read(ptr[0.._chunkHeader.sizeof]);

    _chunkHeader.length = _cpu.fromBigEndian32(_chunkHeader.length);

    switch (_chunkHeader.type) {
      case Chunk.IHDR:
        _state = State.ReadIHDR;
        break;

      case Chunk.PLTE:
        _state = State.ReadPLTE;
        break;

      case Chunk.IDAT:
        _state = State.ReadIDAT;
        break;

      case Chunk.IEND:
        _state = State.Complete;
        break;

      default:
        _state = State.SkipChunk;
        break;
    }
  }

  void _skipChunk() {
    if (_input.available < _chunkHeader.length) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.seek(_chunkHeader.length);
    _state = State.ReadChunkCRC;
  }

  void _readIHDR() {
    if (_input.available < IHDR.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }
    
    ubyte* ptr = cast(ubyte*)&_IHDR;
    _input.read(ptr[0..IHDR.sizeof]);

    _haveIHDR = true;

    _IHDR.width = _cpu.fromBigEndian32(_IHDR.width);
    _IHDR.height = _cpu.fromBigEndian32(_IHDR.height);

    _paletteCount = 0;

    switch (_IHDR.colorType) {
      case 0: // Grayscale
        switch (_IHDR.bitDepth) {
          case 1:
          case 2:
          case 4:
          case 8:
          case 16:
            printf("grayscale\n");
            break;

          default: // Invalid color and bit depth combination
            _state = State.Invalid;
            return;
        }
        break;

      case 2: // Truecolor
        switch (_IHDR.bitDepth) {
          case 8:
          case 16:
            printf("truecolor\n");
            break;

          default: // Invalid color and bit depth combination
            _state = State.Invalid;
            return;
        }
        break;

      case 3: // Indexed Color
        switch (_IHDR.bitDepth) {
          case 1:
          case 2:
          case 4:
          case 8:
            printf("indexed\n");
            break;

          default: // Invalid color and bit depth combination
            _state = State.Invalid;
        }
        break;

      case 4: // Grayscale with Alpha
        switch (_IHDR.bitDepth) {
          case 8:
          case 16:
            printf("grayscale + alpha\n");
            break;

          default: // Invalid color and bit depth combination
            _state = State.Invalid;
            return;
        }
        break;

      case 6: // Truecolor with Alpha
        switch (_IHDR.bitDepth) {
          case 8:
          case 16:
            printf("truecolor + alpha\n");
            break;

          default: // Invalid color and bit depth combination
            _state = State.Invalid;
            return;
        }
        break;

      default:
        _state = State.Invalid;
        return;
    }

    if (_IHDR.filterMethod != 0) {
      _state = State.Invalid;
      return;
    }

    if (_IHDR.compressionMethod != 0) {
      _state = State.Invalid;
      return;
    }

    if (_IHDR.interlaceMethod > 0) {
      // Set up interlace pass dimensions
      printf("interlacing\n");
      _setUpInterlacing();
    }

    _imageType = cast(ImageType)(((_IHDR.colorType + 1) << 16) + _IHDR.bitDepth);

    switch (_IHDR.colorType) {
      case 3: // Indexed (1 sample per pixel, samples are indices)
      case 0: // Grayscale (1 sample per pixel)
        _numSamples = 1;
        switch (_IHDR.bitDepth) {
          case 1:
            _expectedBytes = 1 + cast(uint)((cast(float)_IHDR.width / 8.0) + 0.5);
            break;
          case 2:
            _expectedBytes = 1 + cast(uint)((cast(float)_IHDR.width / 4.0) + 0.5);
            break;
          case 4:
            _expectedBytes = 1 + cast(uint)((cast(float)_IHDR.width / 2.0) + 0.5);
            break;
          case 8:
            _expectedBytes = _IHDR.width; 
            break;
          case 16:
            _expectedBytes = _IHDR.width * 2;
            _numSamples = 2;
            break;
          default:
            break;
        }
        break;

      case 2: // Truecolor
        switch (_IHDR.bitDepth) {
          case 8:
            _expectedBytes = _IHDR.width * 3;
            _numSamples = 3;
            break;

          case 16:
            _expectedBytes = _IHDR.width * 3 * 2;
            _numSamples = 6;
            break;

          default:
            break;
        }
        break;

      case 4: // Grayscale Alpha
        switch (_IHDR.bitDepth) {
          case 8:
            _expectedBytes = _IHDR.width * 2;
            _numSamples = 2;
            break;

          case 16:
            _expectedBytes = _IHDR.width * 2 * 2;
            _numSamples = 4;
            break;

          default:
            break;
        }
        break;

      case 6: // Truecolor Alpha
        switch (_IHDR.bitDepth) {
          case 8:
            _expectedBytes = _IHDR.width * 4;
            _numSamples = 4;
            break;

          case 16:
            _expectedBytes = _IHDR.width * 4 * 2;
            _numSamples = 8;
            break;

          default:
            break;
        }
        break;

      default:
        break;
    }

    // Init Decoder Data
    for (size_t i = 0; i < 8; i++) {
      _bytes[i] = new ubyte[_expectedBytes];
      _bytes[i][0 .. _expectedBytes] = 0;
    }

    _nsamp = 0;
    _psamp = 0;

    _x = 0;
    _y = 0;

    _state = State.ReadChunkCRC;
  }

  void _setUpInterlacing() {
    _interlacePass = 0;
    _interlaceCurLine = 0;

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

    // TODO: ceiling
    for (size_t i = 0; i < 3; i++) {
      _interlaceWidths[(i * 2)]     = cast(uint)(cast(float)(_IHDR.width)            / (8 >> i));
      _interlaceWidths[(i * 2) + 1] = cast(uint)(cast(float)(_IHDR.width - (4 >> i)) / (8 >> i));
    }
    _interlaceWidths[6] = _IHDR.width;

    for (size_t i = 0; i < 3; i++) {
      _interlaceHeights[(i * 2) + 1] = cast(uint)(cast(float)(_IHDR.height)            / (8 >> i));
      _interlaceHeights[(i * 2) + 2] = cast(uint)(cast(float)(_IHDR.height - (4 >> i)) / (8 >> i));
    }
    _interlaceHeights[0] = _interlaceHeights[1];
  }

  void _readPLTE() {
    // Read Palette Entries

    // The chunk length divided by 3 is the number of entries
    // since each entry is 3 bytes (1 per color channel)

    // If the chunk length is not divisible by 3, it is corrupt

    if ((_chunkHeader.length  % 3) > 0) {
      // Corrupt Palette
      _state = State.Invalid;
      return;
    }

    _paletteCount = _chunkHeader.length / 3;

    if (_paletteCount > 256) {
      // Too many entries

      printf("whoa\n");
      _state = State.Invalid;
      return;
    }
    else if (_paletteCount == 0) {
      // Too few entries, just going to ignore
      _state = State.ReadChunkCRC;
      return;
    }

    if (_input.available < _chunkHeader.length) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)_palette.ptr;
    _input.read(ptr[0.._chunkHeader.length]);

    for (size_t i = 0; i < _paletteCount; i++) {
      _paletteRealized[i] = 0xff000000 | (_palette[i].red)
                                       | (_palette[i].green <<  8)
                                       | (_palette[i].blue  << 16);
    }

    for (size_t i = _paletteCount; i < 256; i++) {
      _paletteRealized[i] = 0;
    }

    _state = State.ReadChunkCRC;
  }

  void _readIDAT() {
    // Decompress Some Bits If We Can
    if (_decodedBytes is null) {
      _decodedByteBuffer = new Buffer(_expectedBytes);
      _decodedBytes = _decodedByteBuffer.stream;
    }

    _decoderSource.useRegion(_input.position, _chunkHeader.length);
    _bytesDecoded = 0;

    _state = State.Decode;
  }

  void _decode() {
    if (_bytesDecoded == _chunkHeader.length) {
      // Decoded all of the IDAT chunk
      _state = State.ReadChunkCRC;
      return;
    }

    if (_input.available == 0) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    // How many bits?
    long curPos = _decoderSource.position;

    if (_decoder.decode(_decodedBytes) == DataDecoder.State.Accepted) {
    }

    long numBytesDecoded = _decoderSource.position - curPos;
    _bytesDecoded += numBytesDecoded;
    _input.seek(numBytesDecoded);

    // Render those bits in _decodedBytes!
    _state = _filterState;
  }

  void _decodeReadFilterType() {
    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte filterType;
    ubyte* ptr = &filterType;
    _decodedBytes.read(ptr[0..1]);

    switch (filterType) {
      case FilterType.None:
        _state = State.UnfilterNone;
        break;

      case FilterType.Sub:
        _state = State.UnfilterSub;
        break;

      case FilterType.Up:
        _state = State.UnfilterUp;
        break;

      case FilterType.Average:
        _state = State.UnfilterAverage;
        break;

      case FilterType.Paeth:
        _state = State.UnfilterPaeth;
        break;

      default:
        _state = State.Invalid;
        break;
    }

    for (size_t i = 0; i < _numSamples; i++) {
      _priorScannedByte[i] = 0;
      _priorPixel[i]       = 0;
    }

    _nsamp = 0;
    _psamp = 0;

    _filterState = _state;
  }

  void _interlaceCompleteLine() {
    _interlaceCurLine++;

    if (_interlaceCurLine == _interlaceHeights[_interlacePass]) {
      // Entering a new interlace pass
      _interlaceCurLine = 0;

      // Reset the prior scanline array
      for (size_t i = 0; i < 8; i++) {
        _bytes[i][0.._expectedBytes] = 0;
      }

      do {
        _interlacePass++;
      } while ((_interlacePass < 7) && (_interlaceWidths[_interlacePass] == 0));

      _y = _interlaceStartsY[_interlacePass];
    }
    else {
      _y += _interlaceIncrementsY[_interlacePass];
    }

    _x = _interlaceStartsX[_interlacePass];
  }

  void _unfilterNone() {
    if (_x >= _IHDR.width) {
      // We are done.

      if (_IHDR.interlaceMethod > 0) {
        _interlaceCompleteLine();

        if (_interlacePass >= 7) {
          // Done decoding
          _state = State.Complete;
        }
      }
      else {
        _x = 0;
        _y++;
      }

      if (_y >= _IHDR.height) {
        _state = State.Complete;
        return;
      }

      _filterState = State.DecodeReadFilterType;
      _state = _filterState;
      return;
    }

    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte b;
    ubyte* ptr = &b;
    _decodedBytes.read(ptr[0..1]);

    _curComponent[_psamp]  = b;
    _bytes[_psamp][_nsamp] = b;

    _psamp++;
    if (_psamp == _numSamples) {
      _nsamp++;
      _psamp = 0;

      _state = State.Render;
    }
  }

  void _unfilterSub() {
    if (_x >= _IHDR.width) {
      // We are done.

      if (_IHDR.interlaceMethod > 0) {
        _interlaceCompleteLine();

        if (_interlacePass >= 7) {
          // Done decoding
          _state = State.Complete;
        }
      }
      else {
        _x = 0;
        _y++;
      }

      if (_y >= _IHDR.height) {
        _state = State.Complete;
        return;
      }

      _filterState = State.DecodeReadFilterType;
      _state = _filterState;
      return;
    }

    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte b;
    ubyte* ptr = &b;
    _decodedBytes.read(ptr[0..1]);

    _priorPixel[_psamp]   += b;
    _curComponent[_psamp]  = _priorPixel[_psamp];
    _bytes[_psamp][_nsamp] = cast(ubyte)_curComponent[_psamp];

    _psamp++;
    if (_psamp == _numSamples) {
      _nsamp++;
      _psamp = 0;

      _state = State.Render;
    }
  }

  void _unfilterUp() {
    if (_x >= _IHDR.width) {
      // We are done.

      if (_IHDR.interlaceMethod > 0) {
        _interlaceCompleteLine();

        if (_interlacePass >= 7) {
          // Done decoding
          _state = State.Complete;
        }
      }
      else {
        _x = 0;
        _y++;
      }

      if (_y >= _IHDR.height) {
        _state = State.Complete;
        return;
      }

      _filterState = State.DecodeReadFilterType;
      _state = _filterState;
      return;
    }

    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte b;
    ubyte* ptr = &b;
    _decodedBytes.read(ptr[0..1]);

    _bytes[_psamp][_nsamp] += b;
    _curComponent[_psamp]   = _bytes[_psamp][_nsamp];

    _psamp++;
    if (_psamp == _numSamples) {
      _nsamp++;
      _psamp = 0;

      _state = State.Render;
    }
  }

  void _unfilterAverage() {
    if (_x >= _IHDR.width) {
      // We are done.

      if (_IHDR.interlaceMethod > 0) {
        _interlaceCompleteLine();

        if (_interlacePass >= 7) {
          // Done decoding
          _state = State.Complete;
        }
      }
      else {
        _x = 0;
        _y++;
      }

      if (_y >= _IHDR.height) {
        _state = State.Complete;
        return;
      }

      _filterState = State.DecodeReadFilterType;
      _state = _filterState;
      return;
    }

    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte b;
    ubyte* ptr = &b;
    _decodedBytes.read(ptr[0..1]);

    _curComponent[_psamp]  = cast(uint)_priorPixel[_psamp];
    _curComponent[_psamp] += cast(uint)_bytes[_psamp][_nsamp];
    _curComponent[_psamp] /= 2;
    _curComponent[_psamp] += b;
    _bytes[_psamp][_nsamp] = cast(ubyte)_curComponent[_psamp];
    _curComponent[_psamp]  = _bytes[_psamp][_nsamp];

    _priorPixel[_psamp]    = _bytes[_psamp][_nsamp];

    _psamp++;
    if (_psamp == _numSamples) {
      _nsamp++;
      _psamp = 0;

      _state = State.Render;
    }
  }

  void _unfilterPaeth() {
    if (_x >= _IHDR.width) {
      // We are done.

      if (_IHDR.interlaceMethod > 0) {
        _interlaceCompleteLine();

        if (_interlacePass >= 7) {
          // Done decoding
          _state = State.Complete;
        }
      }
      else {
        _x = 0;
        _y++;
      }

      if (_y >= _IHDR.height) {
        _state = State.Complete;
        return;
      }

      _filterState = State.DecodeReadFilterType;
      _state = _filterState;
      return;
    }

    if (_decodedBytes.available < 1) {
      _state = State.Decode;
      return;
    }

    ubyte b;
    ubyte* ptr = &b;
    _decodedBytes.read(ptr[0..1]);

    _priorScannedComponent    = _priorScannedByte[_psamp];
    _priorScannedByte[_psamp] = _bytes[_psamp][_nsamp];

		int p;
		int pa;
		int pb;
		int pc;

    p  = cast(int)_priorPixel[_psamp];
    p += cast(int)_priorScannedByte[_psamp];
    p -= cast(int)_priorScannedComponent;

    if (p > cast(int)_priorPixel[_psamp]) {
      pa = p - cast(int)_priorPixel[_psamp];
    }
    else {
      pa = cast(int)_priorPixel[_psamp] - p;
    }

    if (p > cast(int)_priorScannedByte[_psamp]) {
      pb = p - cast(int)_priorScannedByte[_psamp];
    }
    else {
      pb = cast(int)_priorScannedByte[_psamp] - p;
    }

    if (p > cast(int)_priorScannedComponent) {
      pc = p - cast(int)_priorScannedComponent;
    }
    else {
      pc = cast(int)_priorScannedComponent - p;
    }

    ubyte paethPredictor;

    if (pa <= pb && pa <= pc) {
      paethPredictor = _priorPixel[_psamp];
    }
    else if (pb <= pc) {
      paethPredictor = _priorScannedByte[_psamp];
    }
    else {
      paethPredictor = _priorScannedComponent;
    }

    ubyte recon = cast(ubyte)(b + paethPredictor);

    _priorPixel[_psamp]   = recon;
    _curComponent[_psamp] = recon;

    _bytes[_psamp][_nsamp] = cast(ubyte)_curComponent[_psamp];

    _psamp++;
    if (_psamp == _numSamples) {
      _nsamp++;
      _psamp = 0;

      _state = State.Render;
    }
  }

  void _readChunkCRC() {
    if (_input.available < 4) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_chunkCRC;
    _input.read(ptr[0.._chunkCRC.sizeof]);

    _state = State.ReadChunkHeader;
  }

  void _renderGrayscalePixel(Pixelmap pixelmap, ubyte pixel) {
    uint rgba = (pixel <<  0)
              | (pixel <<  8)
              | (pixel << 16)
              | 0xff000000;

    pixelmap.writeR8G8B8A8(rgba);
    _x++;
  }

  void _renderGrayscale1bpp(Pixelmap pixelmap) {
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 7) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 6) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 5) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 4) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 3) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 2) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 1) & 0x1]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _1bpp[(_curComponent[0] >> 0) & 0x1]);
  }

  void _renderGrayscale2bpp(Pixelmap pixelmap) {
    _renderGrayscalePixel(pixelmap, _2bpp[(_curComponent[0] >> 6) & 0x3]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _2bpp[(_curComponent[0] >> 4) & 0x3]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _2bpp[(_curComponent[0] >> 2) & 0x3]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _2bpp[(_curComponent[0] >> 0) & 0x3]);
  }

  void _renderGrayscale4bpp(Pixelmap pixelmap) {
    _renderGrayscalePixel(pixelmap, _4bpp[(_curComponent[0] >> 4) & 0xf]);
    if (_x == _IHDR.width) return;
    _renderGrayscalePixel(pixelmap, _4bpp[(_curComponent[0] >> 0) & 0xf]);
  }

  void _renderGrayscale8bpp(Pixelmap pixelmap) {
    uint rgba = (_curComponent[0] <<  0)
              | (_curComponent[0] <<  8)
              | (_curComponent[0] << 16)
              | 0xff000000;

    pixelmap.writeR8G8B8A8(rgba);
    _x++;
  }

  void _renderGrayscale16bpp(Pixelmap pixelmap) {
    ulong rgba = (cast(ulong)_curComponent[0] <<  0)
               | (cast(ulong)_curComponent[1] <<  8)
               | (cast(ulong)_curComponent[0] << 16)
               | (cast(ulong)_curComponent[1] << 24)
               | (cast(ulong)_curComponent[0] << 32)
               | (cast(ulong)_curComponent[1] << 40)
               | 0xffff000000000000;

    pixelmap.writeR16G16B16A16(rgba);
    _x++;
  }

  void _renderTruecolor8bpp(Pixelmap pixelmap) {
    uint rgba = (_curComponent[0] <<  0)
              | (_curComponent[1] <<  8)
              | (_curComponent[2] << 16)
              | 0xff000000;

    pixelmap.writeR8G8B8A8(rgba);
    _x++;
  }

  void _renderTruecolor16bpp(Pixelmap pixelmap) {
    ulong rgba = (cast(ulong)_curComponent[0] <<  0)
               | (cast(ulong)_curComponent[1] <<  8)
               | (cast(ulong)_curComponent[2] << 16)
               | (cast(ulong)_curComponent[3] << 24)
               | (cast(ulong)_curComponent[4] << 32)
               | (cast(ulong)_curComponent[5] << 40)
               | 0xffff000000000000;

    pixelmap.writeR16G16B16A16(rgba);
    _x++;
  }

  void _renderIndexedPixel(Pixelmap pixelmap, ubyte index) {
    if (index > _paletteCount) {
      index = 0;
    }

    pixelmap.writeR8G8B8A8(_paletteRealized[index]);
    _x++;
  }

  void _renderIndexed1bpp(Pixelmap pixelmap) {
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 7) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 6) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 5) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 4) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 3) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 2) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 1) & 0x1);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 0) & 0x1);
  }

  void _renderIndexed2bpp(Pixelmap pixelmap) {
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 6) & 0x3);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 4) & 0x3);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 2) & 0x3);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 0) & 0x3);
  }

  void _renderIndexed4bpp(Pixelmap pixelmap) {
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 4) & 0xf);
    if (_x == _IHDR.width) return;
    _renderIndexedPixel(pixelmap, (_curComponent[0] >> 0) & 0xf);
  }

  void _renderIndexed8bpp(Pixelmap pixelmap) {
    _renderIndexedPixel(pixelmap, _curComponent[0]);
  }

  void _renderGrayscaleAlpha8bpp(Pixelmap pixelmap) {
    uint rgba = (_curComponent[0] <<  0)
              | (_curComponent[0] <<  8)
              | (_curComponent[0] << 16)
              | (_curComponent[1] << 24);

    pixelmap.writeR8G8B8A8(rgba);
    _x++;
  }

  void _renderGrayscaleAlpha16bpp(Pixelmap pixelmap) {
    ulong rgba = (cast(ulong)_curComponent[0] <<  0)
               | (cast(ulong)_curComponent[1] <<  8)
               | (cast(ulong)_curComponent[0] << 16)
               | (cast(ulong)_curComponent[1] << 24)
               | (cast(ulong)_curComponent[0] << 32)
               | (cast(ulong)_curComponent[1] << 40)
               | (cast(ulong)_curComponent[2] << 48)
               | (cast(ulong)_curComponent[3] << 56);

    pixelmap.writeR16G16B16A16(rgba);
    _x++;
  }

  void _renderTruecolorAlpha8bpp(Pixelmap pixelmap) {
    uint rgba = (_curComponent[0] <<  0)
              | (_curComponent[1] <<  8)
              | (_curComponent[2] << 16)
              | (_curComponent[3] << 24);

    pixelmap.writeR8G8B8A8(rgba);
    _x++;
  }

  void _renderTruecolorAlpha16bpp(Pixelmap pixelmap) {
    ulong rgba = (cast(ulong)_curComponent[0] <<  0)
               | (cast(ulong)_curComponent[1] <<  8)
               | (cast(ulong)_curComponent[2] << 16)
               | (cast(ulong)_curComponent[3] << 24)
               | (cast(ulong)_curComponent[4] << 32)
               | (cast(ulong)_curComponent[5] << 40)
               | (cast(ulong)_curComponent[6] << 48)
               | (cast(ulong)_curComponent[7] << 56);

    pixelmap.writeR16G16B16A16(rgba);
    _x++;
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

        case State.ReadHeader:
          _readHeader();
          break;

        case State.SkipChunk:
          _skipChunk();
          break;

        case State.ReadChunkHeader:
          _readChunkHeader();
          break;

        case State.ReadChunkCRC:
          _readChunkCRC();
          break;

        case State.ReadIHDR:
          _readIHDR();
          break;

        case State.ReadIDAT:
          _readIDAT();
          break;

        case State.ReadPLTE:
          _readPLTE();
          break;

        case State.Decode:
          _decode();
          break;

        case State.DecodeReadFilterType:
          _decodeReadFilterType();
          break;

        case State.UnfilterNone:
          _unfilterNone();
          break;

        case State.UnfilterSub:
          _unfilterSub();
          break;

        case State.UnfilterUp:
          _unfilterUp();
          break;

        case State.UnfilterAverage:
          _unfilterAverage();
          break;

        case State.UnfilterPaeth:
          _unfilterPaeth();
          break;

        case State.Render:
          if (pixelmap is null) {
            return ImageDecoder.State.PixelmapRequired;
          }

          switch (_imageType) {
            case ImageType.Grayscale1bpp:
              _renderGrayscale1bpp(pixelmap);
              break;
            case ImageType.Grayscale2bpp:
              _renderGrayscale2bpp(pixelmap);
              break;
            case ImageType.Grayscale4bpp:
              _renderGrayscale4bpp(pixelmap);
              break;
            case ImageType.Grayscale8bpp:
              _renderGrayscale8bpp(pixelmap);
              break;
            case ImageType.Grayscale16bpp:
              _renderGrayscale16bpp(pixelmap);
              break;

            case ImageType.Truecolor8bpp:
              _renderTruecolor8bpp(pixelmap);
              break;
            case ImageType.Truecolor16bpp:
              _renderTruecolor16bpp(pixelmap);
              break;

            case ImageType.Indexed1bpp:
              _renderIndexed1bpp(pixelmap);
              break;
            case ImageType.Indexed2bpp:
              _renderIndexed2bpp(pixelmap);
              break;
            case ImageType.Indexed4bpp:
              _renderIndexed4bpp(pixelmap);
              break;
            case ImageType.Indexed8bpp:
              _renderIndexed8bpp(pixelmap);
              break;

            case ImageType.GrayscaleAlpha8bpp:
              _renderGrayscaleAlpha8bpp(pixelmap);
              break;
            case ImageType.GrayscaleAlpha16bpp:
              _renderGrayscaleAlpha16bpp(pixelmap);
              break;

            case ImageType.TruecolorAlpha8bpp:
              _renderTruecolorAlpha8bpp(pixelmap);
              break;
            case ImageType.TruecolorAlpha16bpp:
              _renderTruecolorAlpha16bpp(pixelmap);
              break;
          }

          _state = _filterState;
          break;

        case State.Required:
          _state = _currentState;

          if (_state <= State.ReadChunkHeader) {
            return ImageDecoder.State.Insufficient;
          }

          return ImageDecoder.State.Accepted;

        case State.Complete:
          return ImageDecoder.State.Complete;

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
    return "Portable Network Graphic Image";
  }

  char[][] tags() {
    return ["png"];
  }

  ulong width() {
    if (!_haveIHDR) {
      return 0;
    }

    return _IHDR.width;
  }

  ulong height() {
    if (!_haveIHDR) {
      return 0;
    }

    return _IHDR.height;
  }
}
