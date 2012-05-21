module io.console;

import io.stream;

version(Windows) {
}
else version(linux) {
  extern(C) int printf(char* format, ...);
}
else {
  static assert(false, "I do not know how to compile the Console class.");
}

class Console {
private:
  Stream _input;
  Stream _output;
  Stream _stream;

  ubyte[] _read(size_t length) {
    return null;
  }

  void _readInto(ubyte[] buffer) {
  }

  size_t _zero() {
    return 0;
  }

	void _initStreams() {
		_input = new Stream();
		_output = new Stream();
		_stream = new Stream();

		_input.read = &_read;
		_input.readInto = &_readInto;
		_input.available = &_zero;
		_input.length = &_zero;
		_input.position = &_zero;

		_output.write = &write;
		_output.append = &write;
		_output.available = &_zero;
		_output.length = &_zero;
		_output.position = &_zero;

		_stream.read = &_read;
		_stream.readInto = &_readInto;
		_stream.available = &_zero;
		_stream.length = &_zero;
		_stream.position = &_zero;
		_stream.write = &write;
		_stream.append = &write;
	}

public:
  this() {
    _initStreams();
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

  ubyte[] read(size_t length) {
    return _read(length);
  }

  void read(ubyte[] buffer) {
    _readInto(buffer);
  }

  void read(Stream buffer, size_t length) {
  }

  void write(ubyte[] data) {
    version(linux) {
      printf("%*s", data.length, cast(char*)data.ptr);
    }
  }

  void write(Stream buffer, size_t length) {
    write(buffer.read(length));
  }
}
