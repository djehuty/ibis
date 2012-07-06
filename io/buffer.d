module io.buffer;

import io.stream;

import binding.c;

class Buffer {
private:
  static const size_t INITIAL_SIZE = 128;

  Stream _input;
  Stream _output;
  Stream _stream;

  ubyte[] _space;
  ubyte[] _data;
  size_t _pos;
  
  void _resize(size_t length) {
    ubyte[] reallocated = new ubyte[length];
    if (length < _space.length) {
      reallocated[0..length] = _space[0..length];
    }
    else {
      reallocated[0.._space.length] = _space[0.._space.length];
    }
    _space = reallocated;
  }

  ubyte[] _read(size_t length) {
    size_t end = _pos + length;

    if (end > _data.length) {
      throw new Exception("OutOfBounds");
    }

    if (length == 0) {
      return [];
    }

    auto ret = _data[_pos .. end];

    _pos += length;
    return ret;
  }

  bool _readInto(ubyte[] buffer) {
    if (available() < buffer.length) {
      return false;
    }

    buffer[0..buffer.length] = _read(buffer.length)[0..buffer.length];
    return true;
  }

  void _initStreams() {
    _stream = new Stream();
    _output = new Stream();
    _input  = new Stream();

    _stream.read      = &_read;
    _stream.readInto  = &_readInto;
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

    _input.read       = &_read;
    _input.readInto   = &_readInto;
    _input.available  = &available;
    _input.length     = &length;
    _input.position   = &position;
  }

public:
  this(){
    _space = new ubyte[INITIAL_SIZE];
    _data = _space[0..0];
    _initStreams();
  }

  this(size_t size) {
    _space = new ubyte[size];
    _data = _space[0..0];
    _initStreams();
  }

  this(size_t size, ubyte value) {
    _space = new ubyte[size];
    _data = _space;
    _data[0..$] = value;
    _initStreams();
  }

  // Properties //

  size_t length() {
    return _data.length;
  }

  size_t available() {
    return _data.length - _pos;
  }

  size_t position() {
    return _pos;
  }

  Stream input() {
    return _input;
  }

  Stream output() {
    return _output;
  }

  Stream stream() {
    return _stream;
  }

  // Methods //

  void append(ubyte[] data) {
    if (_space.length < _data.length + data.length) {
      _resize(_data.length + data.length);
    }

    _space[_data.length .. _data.length + data.length] = data;
    _data = _space[0 .. _data.length + data.length];
  }

  void append(Stream data, size_t length) {
    append(data.read(length));
  }

  void write(ubyte[] data) {
    size_t necessaryLength = _pos + data.length;
    if (_space.length < necessaryLength) {
      _resize(necessaryLength);
    }

    _space[_pos .. necessaryLength] = data;

    if (necessaryLength > _data.length) {
      _data = _space[0 .. necessaryLength];
    }

    _pos += data.length;
  }

  void write(Stream data, size_t length) {
    write(data.read(length));
  }

  ubyte[] read(size_t length) {
    return _read(length);
  }

  bool read(ubyte[] buffer) {
    return _readInto(buffer);
  }

  bool read(Stream buffer, size_t length) {
    if (available() < length) {
      return false;
    }

    buffer.write(read(length));
    return true;
  }

  void seek(long position) {
    long newPos = cast(long)_pos + position;

    if (position < 0) {
      if ((cast(size_t)(-position)) > _pos) {
        _pos = 0;
        return;
      }
    }
    else if (newPos > _data.length) {
      _pos = _data.length;
      return;
    }
    _pos = newPos;
  }
}
