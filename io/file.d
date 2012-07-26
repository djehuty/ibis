module io.file;

import io.stream;

version(Windows) {
}
else version(linux) {
  version(GNU) {
    import gcc.builtins;
    alias __builtin_Clong Clong_t;
    alias __builtin_Culong Culong_t;
  }
  else version(X86_64) {
    alias long Clong_t;
    alias ulong Culong_t;
  }
  else {
    alias int Clong_t;
    alias uint Culong_t;
  }

  extern(C) int*    fopen(char* filename, char* mode);
  extern(C) size_t  fread(void* ptr, size_t size, size_t count, int* stream);
  extern(C) size_t  fwrite(void* ptr, size_t size, size_t count, int* stream);
  extern(C) int     fclose(int* stream);
  extern(C) int     fseek(int* stream, Clong_t offset, int origin);
  extern(C) Clong_t ftell(int* stream);

  enum { SEEK_SET, SEEK_CUR, SEEK_END }
}

final class File {
private:
  int* _ptr;

	Stream _input;
	Stream _output;
	Stream _stream;

	ubyte[] _read(size_t length) {
		return read(length);
	}

	bool _readInto(ubyte[] buffer) {
    return read(buffer);
	}

	void _initStreams() {
		_input = new Stream();
		_output = new Stream();
		_stream = new Stream();

		_input.read = &_read;
		_input.readInto = &_readInto;
		_input.available = &available;
		_input.length = &length;
		_input.position = &position;
    _input.seek = &seek;

		_output.write = &write;
		_output.append = &append;
		_output.available = &available;
		_output.length = &length;
		_output.position = &position;
    _output.seek = &seek;

		_stream.read = &_read;
		_stream.readInto = &_readInto;
		_stream.available = &available;
		_stream.length = &length;
		_stream.position = &position;
		_stream.write = &write;
		_stream.append = &append;
    _stream.seek = &seek;
	}

public:
  this() {
    _initStreams();
  }

  this(void* location) {
    // location is a string for the filename
    _ptr = fopen(cast(char*)location, "r+b\0".ptr);
    _initStreams();
  }

  ~this() {
    fclose(_ptr);
  }

  // Properties //

  ulong length() {
    auto cur = ftell(_ptr);
    fseek(_ptr, 0, SEEK_END);
    auto ret = ftell(_ptr);
    fseek(_ptr, cur, SEEK_SET);
    return ret;
  }

  ulong available() {
    return length() - position();
  }

  ulong position() {
    auto cur = ftell(_ptr);
    return cur;
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

  ubyte[] read(ulong length) {
    ubyte[] buffer = new ubyte[length];
    fread(buffer.ptr, length, 1, _ptr);
    return buffer;
  }

	bool read(ubyte[] buffer) {
    if (available() < buffer.length) {
      return false;
    }

    fread(buffer.ptr, buffer.length, 1, _ptr);
    return true;
  }

	void read(Stream buffer, ulong length) {
    buffer.write(read(length));
  }

	void write(ubyte[] data) {
    fwrite(data.ptr, data.length, 1, _ptr);
  }

	void write(Stream buffer, ulong length) {
    write(buffer.read(length));
  }

	void append(ubyte[] data) {
    auto cur = ftell(_ptr);
    fseek(_ptr, 0, SEEK_END);
    write(data);
    fseek(_ptr, cur, SEEK_SET);
  }

	void append(Stream buffer, ulong length) {
    append(buffer.read(length));
  }

	void seek(long offset) {
    fseek(_ptr, offset, SEEK_CUR);
  }
}
