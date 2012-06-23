module io.console;

import io.stream;

import drawing.color;

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
  Color _fg;
  Color _bg;

  Stream _input;
  Stream _output;
  Stream _stream;

  int _toNearestConsoleColor(Color clr) {
    // 16 colors on console
    // For each channel, it can be 00, 88, or ff
    // That is, something mid range

    int nearRed, nearGreen, nearBlue;
    int ret;

    nearRed = cast(int)((clr.red * 3.0) + 0.5);
    nearGreen = cast(int)((clr.green * 3.0) + 0.5);
    nearBlue = cast(int)((clr.blue * 3.0) + 0.5);

    if ((nearRed == nearGreen) && (nearGreen == nearBlue)) {
      // gray
      if (clr.red < (Color.DarkGray.red / 2.0)) {
        // Closer to black
        ret = 0;
      }
      else if (clr.red < ((Color.Gray.red - Color.DarkGray.red) / 2.0) + Color.DarkGray.red) {
        // Closer to dark gray
        ret = 8;
      }
      else if (clr.red < ((Color.White.red - Color.Gray.red) / 2.0) + Color.Gray.red) {
        // Closer to light gray
        ret = 7;
      }
      else {
        // Closer to white
        ret = 15;
      }
    }
    else {
      // Nearest color match
      static int[][] translations = [
        [1,0,0], // 1, Dark Red
        [0,1,0], // 2, Dark Green
        [1,1,0], // 3, Dark Yellow
        [0,0,1], // 4, Dark Blue
        [1,0,1], // 5, Dark Magenta
        [0,1,1], // 6, Dark Cyan

        [2,0,0], // 9, Dark Red
        [0,2,0], // 10, Dark Green
        [2,2,0], // 11, Dark Yellow
        [0,0,2], // 12, Dark Blue
        [2,0,2], // 13, Dark Magenta
        [0,2,2], // 14, Dark Cyan
      ];

      double mindistance = 4 * 3;

      foreach(size_t i, coord; translations) {
        // Compare euclidian distance
        double distance = 0.0;
        double intermediate;

        intermediate = coord[0] - nearRed;
        intermediate *= intermediate;

        distance += intermediate;

        intermediate = coord[1] - nearGreen;
        intermediate *= intermediate;

        distance += intermediate;

        intermediate = coord[2] - nearBlue;
        intermediate *= intermediate;

        distance += intermediate;

        // Omitting square root, it is unnecessary for comparison
        if (mindistance > distance) {
          mindistance = distance;
          ret = i;
          ret++;
          if (ret > 6) {
            ret += 2;
          }
        }
      }
    }

    return ret;
  }

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

  Color foregroundColor() {
    return _fg;
  }

  Color backgroundColor() {
    return _bg;
  }

  void foregroundColor(Color value) {
    _fg = value;

    version(linux) {
      int fgidx = _toNearestConsoleColor(value);
      int bright = 0;
      if (fgidx > 7) {
        fgidx %= 8;
        bright = 1;
      }
      printf("\x1B[%d;%dm\0".ptr, bright, 30 + fgidx);
    }
  }

  void backgroundColor(Color value) {
    _bg = value;

    version(linux) {
      int bgidx = _toNearestConsoleColor(value);
      bgidx %= 8;
      printf("\x1B[%dm\0".ptr, 40 + bgidx);
    }
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
      printf("%.*s\0".ptr, data.length, cast(char*)data.ptr);
    }
  }

  void write(Stream buffer, size_t length) {
    write(buffer.read(length));
  }
}
