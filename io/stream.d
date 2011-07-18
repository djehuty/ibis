module io.stream;

class Stream {
private:
	void delegate(ubyte[] buffer) _readInto;
	ubyte[] delegate(size_t length) _read;
	void delegate(ubyte[] data) _write;
	void delegate(ubyte[] data) _append;
	void delegate(long amount) _seek;
	size_t delegate() _length;
	size_t delegate() _available;
	size_t delegate() _position;

public:
	this() {
	}

	this(void delegate(ubyte[] buffer) readInto,
	     ubyte[] delegate(size_t length) read,
	     void delegate(ubyte[] data) write,
	     void delegate(ubyte[] data) append,
	     void delegate(long amount) seek,
	     size_t delegate() length,
	     size_t delegate() available,
	     size_t delegate() position) {

		_readInto = readInto;
		_read = read;
		_write = write;
		_append = append;
		_seek = seek;
		_length = length;
		_available = available;
		_position = position;
	}

	// Properties //

	size_t length() {
		return _length();
	}

	size_t available() {
		return _available();
	}

	size_t position() {
		return _position();
	}

	// Events //

	void read(ubyte[] delegate(size_t length) f) {
		_read = f;
	}

	void readInto(void delegate(ubyte[] buffer) f) {
		_readInto = f;
	}

	void write(void delegate(ubyte[] data) f) {
		_write = f;
	}

	void append(void delegate(ubyte[] data) f) {
		_append = f;
	}

	void seek(void delegate(long amount) f) {
		_seek = f;
	}

	void length(size_t delegate() f) {
		_length = f;
	}

	void available(size_t delegate() f) {
		_available = f;
	}

	void position(size_t delegate() f) {
		_position = f;
	}

	// Methods //

	void append(ubyte[] data) {
		_append(data);
	}

	void append(Stream data, size_t length) {
		_append(data.read(length));
	}

	void write(ubyte[] data) {
		_write(data);
	}

	void write(Stream data, size_t length) {
		_write(data.read(length));
	}

	void read(ubyte[] buffer) {
		_readInto(buffer);
	}

	void read(Stream buffer, size_t length) {
		buffer.write(_read(length));
	}

	ubyte[] read(size_t length) {
		return _read(length);
	}

	void seek(long position) {
		_seek(position);
	}
}