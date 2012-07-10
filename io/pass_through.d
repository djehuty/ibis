module io.pass_through;

import io.stream;

final class PassThrough {
private:
  Stream _source;

  Stream _input;
  Stream _output;
  Stream _stream;

  ulong  _starts[];
  ulong  _positions[];
  ulong  _lengths[];

  ulong  _length;
  ulong  _position;
  ulong  _currentRegionIndex;

  void _initStreams() {
    _stream = new Stream();
    _output = new Stream();
    _input  = new Stream();

    _stream.read      = &read;
    _stream.readInto  = &read;
    _stream.available = &available;
    _stream.length    = &length;
    _stream.position  = &position;
    _stream.write     = &write;
    _stream.append    = &append;
    _stream.seek      = &seek;

    _output.write     = &write;
    _output.append    = &append;
    _output.available = &available;
    _output.length    = &length;
    _output.position  = &position;
    _output.seek      = &seek;

    _input.read       = &read;
    _input.readInto   = &read;
    _input.available  = &available;
    _input.length     = &length;
    _input.position   = &position;
    _input.seek       = &seek;
  }

  ulong _regionLength() {
    if (_currentRegionIndex == _lengths.length) {
      return 0;
    }

    return _lengths[_currentRegionIndex];
  }

  ulong _regionPosition() {
    if (_currentRegionIndex == _positions.length) {
      return 0;
    }

    return _position - _positions[_currentRegionIndex];
  }

  ulong _regionAvailable() {
    return _regionLength() - _regionPosition();
  }

public:

  this(Stream stream) {
    _source   = stream;
    _position = 0;
    _length   = 0;

    _initStreams();
  }

  size_t length() {
    return _length;
  }

  size_t available() {
    return _length - _position;
  }

  size_t position() {
    return _position;
  }

  Stream output() {
    return _output;
  }

  Stream input() {
    return _input;
  }

  Stream stream() {
    return _stream;
  }

  void useRegion(ulong start, ulong length) {
    _starts    ~= start;
    _lengths   ~= length;
    _positions ~= _length;

    _length += length;
  }

  void append(ubyte[] data) {
  }

  void append(Stream data, size_t length) {
  }

  void write(ubyte[] data) {
  }

  void write(Stream data, size_t length) {
  }

  ubyte[] read(size_t length) {
    if (length > available()) {
      length = available();
    }

    ubyte[] ret = new ubyte[length];

    read(ret);

    return ret;
  }

  bool read(ubyte[] buffer) {
    if (available() < buffer.length) {
      return false;
    }

    size_t bufferPos = 0;
    size_t length = buffer.length;

    while (length > 0) {
      long oldPos = _source.position;
      long seekAmount = _source.position - (_starts[_currentRegionIndex] + _regionPosition());
      _source.seek(-seekAmount);

      if (length >= _regionAvailable()) {
        // Grab all within the region
        buffer[bufferPos .. _regionAvailable()] = _source.read(_regionAvailable());
        _source.seek(-_regionAvailable());

        bufferPos += _regionAvailable();
        length -= _regionAvailable();
        _position += _regionAvailable();
        _currentRegionIndex++;
      }
      else {
        buffer[bufferPos .. $] = _source.read(length);
        _source.seek(-length);

        _position += length;
        length = 0;
      }

      _source.seek(seekAmount);
    }

    return true;
  }

  bool read(Stream buffer, size_t length) {
    if (available() < length) {
      return false;
    }

    buffer.write(read(length));
    return true;
  }

  void seek(long amount) {
    long newPos = cast(long)_position + position;

    if (position < 0) {
      if ((cast(size_t)(-position)) > _position) {
        _position = 0;
        _currentRegionIndex = 0;
        return;
      }
    }
    else if (newPos > _length) {
      _position = _length;
      _currentRegionIndex = _lengths.length;
      return;
    }

    size_t bufferPos = 0;

    while (amount > 0) {
      if (amount >= _regionAvailable()) {
        // Grab all within the region
        amount -= _regionAvailable();
        _position += _regionAvailable();
        _currentRegionIndex++;
      }
      else {
        _position += amount;
        amount = 0;
      }
    }
  }
}
