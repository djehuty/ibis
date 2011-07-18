module io.buffer;

import io.stream;

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
		if (_pos + length > _data.length) {
			throw new Exception("OutOfBounds");
		}

		if (length == 0) {
			return [];
		}

		auto ret = _data[_pos.._pos+length];
		_pos += length;
		return ret;
	}

	void _readInto(ubyte[] buffer) {
		buffer[0..buffer.length] = _read(buffer.length)[0..buffer.length];
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

		_output.write = &write;
		_output.append = &append;
		_output.available = &available;
		_output.length = &length;
		_output.position = &position;

		_stream.read = &_read;
		_stream.readInto = &_readInto;
		_stream.available = &available;
		_stream.length = &length;
		_stream.position = &position;
		_stream.write = &write;
		_stream.append = &append;
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

		_space[_data.length.._data.length+data.length] = data;
		_data = _space[0.._data.length+data.length];
	}

	void append(Stream data, size_t length) {
		append(data.read(length));
	}

	void write(ubyte[] data) {
		if (_space.length < _pos + data.length) {
			_resize(_pos + data.length);
		}

		_space[_pos.._pos+data.length] = data;

		if (_pos + data.length > _data.length) {
			_data = _space[0.._pos+data.length];
		}

		_pos += data.length;
	}

	void write(Stream data, size_t length) {
		write(data.read(length));
	}

	ubyte[] read(size_t length) {
		return _read(length);
	}

	void read(ubyte[] buffer) {
		_readInto(buffer);
	}

	void read(Stream buffer, size_t length) {
		buffer.write(read(length));
	}

	void seek(long position) {
		if (position < 0) {
			if ((cast(size_t)(-position)) > _pos) {
				_pos = 0;
				return;
			}
		}
		else if (position + _pos > _data.length) {
			_pos = _data.length;
			return;
		}
		_pos += position;
	}
}