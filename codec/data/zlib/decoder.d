module codec.data.zlib.decoder;

import codec.data.deflate.decoder;

import codec.data.decoder;

import io.stream;

import system.architecture;
import system.cpu;

final class ZlibDecoder {
private:
  enum State {
    Init,

    Invalid,
    Required,

    ReadHeader,
    StreamDeflate,
    ReadAlder32,

    Complete,
  }

  align(1) struct ZlibHeader {
    ubyte cmf;
    ubyte flg;
  }

  ZlibHeader _header;

  ubyte _compressionMethod; // CM
  ubyte _compressionInfo;   // CINFO
  ubyte _isDictionary;      // FDICT
  ubyte _compressionLevel;  // FLEVEL
  ubyte _fCheck;            // FCHECK

  DeflateDecoder _decoder;

  State  _state;
  State  _currentState;

  Stream _input;

  Cpu _cpu;

  void _init() {
    _state = State.ReadHeader;
  }

  void _readHeader() {
    if (_input.available < 2) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_header;
    _input.read(ptr[0.._header.sizeof]);

    _compressionMethod = cast(ubyte)(_header.cmf & 0xf);
    _compressionInfo   = cast(ubyte)(_header.cmf >> 4);

    _isDictionary      = cast(ubyte)(_header.flg & 32);
    _fCheck            = cast(ubyte)(_header.flg & 0xf);
    _compressionLevel  = cast(ubyte)(_header.flg >> 6);

    if (_compressionMethod == 8) {
      // Deflate
      if (_compressionInfo > 7) {
        // Window size is invalid
        _state = State.Invalid;
        return;
      }
    }
    else {
      _state = State.Invalid;
      return;
    }

    _state = State.StreamDeflate;
  }

  void _streamDeflate(Stream output) {
    auto deflateState = _decoder.decode(output);

    if (deflateState == DataDecoder.State.Accepted) {
      _currentState = _state;
      _state = State.Required;
      return;
    }
    else if (deflateState == DataDecoder.State.Invalid) {
      _state = State.Invalid;
      return;
    }

    _state = State.ReadAlder32;
  }

  void _readAlder32() {
    if (_input.available < 4) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.seek(4);
    _state = State.Complete;
  }

public:
  this(Stream input) {
    _decoder = new DeflateDecoder(input);
    _input = input;
  }

  DataDecoder.State decode(Stream output) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadHeader:
          _readHeader();
          break;

        case State.StreamDeflate:
          if (output is null) {
            return DataDecoder.State.StreamRequired;
          }

          _streamDeflate(output);
          break;

        case State.ReadAlder32:
          _readAlder32();
          break;

        case State.Required:
          _state = _currentState;
          return DataDecoder.State.Accepted;

        case State.Complete:
          return DataDecoder.State.Complete;

        default:
          break;
      }
    }

    return DataDecoder.State.Invalid;
  }

  DataDecoder decoder() {
    return new DataDecoder(&decode,
                           &description,
                           &tags);
  }

  char[] description() {
    return "ZLIB Stream";
  }

  char[][] tags() {
    return [];
  }
}
