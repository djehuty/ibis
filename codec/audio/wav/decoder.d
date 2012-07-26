module codec.audio.wav.decoder;

import codec.audio.decoder;

import io.stream;
import io.waveform;

import chrono.time;

import system.architecture;
import system.cpu;

import binding.c;

final class WavDecoder {
private:
  enum State {
    Init,

    Invalid,
    Required,
    Complete,

    ReadRiff,
    ReadChunk,
    SkipChunk,

    ReadFmt,
    ReadData,
  }

  align(2) struct RiffHeader {
    uint magic;
    uint filesize;
    uint rifftype;
  }

  RiffHeader _riffHeader;

  align(2) struct ChunkHeader {
    uint id;
    uint size;
  }

  ChunkHeader _chunk;

  align(2) struct FmtHeader {
    ushort compressionCode;
    ushort numChannels;
    uint   sampleRate;
    uint   averageBytesPerSecond;
    ushort blockAlign;
    ushort significantBitsPerSample;
  }

  bool _fmtHeaderExists;
  FmtHeader _fmtHeader;

  uint  _dataToRead;
  uint  _dataTotalBytes;

  ulong _dataPositionStart;
  ulong _dataPositionEnd;

  State _state;
  State _currentState;

  Cpu   _cpu;

  void _init() {
    _state = State.ReadRiff;
    _dataToRead = 0;
  }

  void _readRiff() {
    if (_input.available < RiffHeader.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_riffHeader;
    _input.read(ptr[0 .. RiffHeader.sizeof]);

    if (_riffHeader.magic != *(cast(uint*)"RIFF".ptr)) {
      // RIFF header is incorrect.
      printf("invalid riff\n");
      _state = State.Invalid;
      return;
    }

    if (_riffHeader.rifftype != *(cast(uint*)"WAVE".ptr)) {
      // RIFF header is incorrect.
      printf("invalid riff\n");
      _state = State.Invalid;
      return;
    }

    _state = State.ReadChunk;
  }

  void _readChunk() {
    if (_input.available < ChunkHeader.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_chunk;
    _input.read(ptr[0 .. ChunkHeader.sizeof]);

    if (_chunk.id == *(cast(uint*)"data".ptr)) {
      _state = State.ReadData;
      _dataTotalBytes = _chunk.size;
      _dataToRead = _dataTotalBytes;
      _dataPositionStart = _input.position;
      _dataPositionEnd = _input.position + _chunk.size;
      printf("data size: %d\n" , _chunk.size);
      return;
    }
    else if (_chunk.id == *(cast(uint*)"fmt ".ptr)) {
      _state = State.ReadFmt;
      printf("fmt size: %d\n" , _chunk.size);
      return;
    }
    else {
      // Shrug
      _state = State.SkipChunk;
    }
  }

  void _skipChunk() {
    if (_input.available < _chunk.size) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    _input.seek(_chunk.size);
    _state = State.ReadChunk;
  }

  void _readFmt() {
    if (_input.available < FmtHeader.sizeof) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    ubyte* ptr = cast(ubyte*)&_fmtHeader;
    _input.read(ptr[0 .. FmtHeader.sizeof]);

    _fmtHeaderExists = true;

    if (_fmtHeader.compressionCode != 0x01 &&
        _fmtHeader.compressionCode != 0x03 &&
        _fmtHeader.compressionCode != 0x50) {
      printf("invalid compression %x\n", _fmtHeader.compressionCode);
      _state = State.Invalid;
      return;
    }

    if (_fmtHeader.compressionCode == 0x01 ||
        _fmtHeader.compressionCode == 0x03) {
      printf("compression: PCM %d\n", _fmtHeader.compressionCode);
      // Native PCM
    }
    else {
      printf("compression: External %d\n", _fmtHeader.compressionCode);
      // Alternative Compression
    }

    printf("num channels: %d\n", _fmtHeader.numChannels);
    printf("rate: %d\n", _fmtHeader.sampleRate);
    printf("byterate: %d\n", _fmtHeader.averageBytesPerSecond);

    _state = State.ReadChunk;
  }

  void _readData(Waveform output) {
    if (_input.available == 0) {
      _currentState = _state;
      _state = State.Required;
      return;
    }

    uint bufferSize = _fmtHeader.averageBytesPerSecond << 1;

    switch (_fmtHeader.compressionCode) {
      case 0x50:
        // mp2
        break;

      case 0x01:
      case 0x03:
        // pcm

        uint bytesRead = _input.available;
        if (bytesRead > _dataToRead) {
          bytesRead = _dataToRead;
        }

        // output.(_input, bytesRead);

        _dataToRead -= bytesRead;
        break;
    }

    if (_dataToRead == 0) {
      _state = State.Complete;
      return;
    }
  }

  Stream _input;

public:
  this(Stream input) {
    _input = input;
  }

  AudioDecoder decoder() {
    return new AudioDecoder(&decode, &description, &tags);
  }

  AudioDecoder.State decode(Waveform output) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadRiff:
          _readRiff();
          break;

        case State.ReadChunk:
          _readChunk();
          break;

        case State.SkipChunk:
          _skipChunk();
          break;

        case State.ReadFmt:
          _readFmt();
          break;

        case State.ReadData:
          if (output is null) {
            return AudioDecoder.State.WaveformRequired;
          }

          _readData(output);
          break;

        case State.Required:
          _state = _currentState;

          if (_state < State.ReadChunk) {
            return AudioDecoder.State.Insufficient;
          }

          return AudioDecoder.State.Accepted;

        case State.Complete:
          return AudioDecoder.State.Complete;

        default:
        case State.Invalid:
          return AudioDecoder.State.Invalid;
      }
    }

    return AudioDecoder.State.Invalid;
  }

  AudioDecoder.State seek(long microseconds) {
    _cpu = Architecture.currentCpu;

    for(;;) {
      switch (_state) {
        case State.Init:
          _init();
          break;

        case State.ReadRiff:
          _readRiff();
          break;

        case State.ReadChunk:
          _readChunk();
          break;

        case State.SkipChunk:
          _skipChunk();
          break;

        case State.ReadFmt:
          _readFmt();
          break;

        case State.ReadData:
          // Cool. Seek.
          // TODO: check chunk bounds. handle multiple data chunks.
          ulong toSeekBytes = cast(ulong)(cast(double)_fmtHeader.averageBytesPerSecond * (cast(double)microseconds / 1000000.0));
          ulong seekToPosition = _dataPositionStart + toSeekBytes;

          if (seekToPosition > _input.position) {
            // seek ahead (may not have enough)
            _input.seek(cast(long)_input.position - cast(long)seekToPosition);
          }
          else {
            // seek back
            _input.seek(cast(long)seekToPosition - cast(long)_input.position);
          }
          return AudioDecoder.State.Complete;

        case State.Required:
          _state = _currentState;

          if (_state < State.ReadChunk) {
            return AudioDecoder.State.Insufficient;
          }

          return AudioDecoder.State.Accepted;

        case State.Complete:
          return AudioDecoder.State.Complete;

        default:
        case State.Invalid:
          return AudioDecoder.State.Invalid;
      }
    }

    return AudioDecoder.State.Invalid;
  }

  Time duration() {
    if (!_fmtHeaderExists) {
      return new Time;
    }

    if (_fmtHeader.averageBytesPerSecond == 0) {
      return new Time;
    }

    double amtSeconds = cast(double)_dataTotalBytes;
    amtSeconds /= cast(double)_fmtHeader.averageBytesPerSecond;
    return new Time(cast(long)(amtSeconds * 1000000));
  }

  char[] description() {
    return "Wave Audio";
  }

  char[][] tags() {
    return ["wav"];
  }
}
