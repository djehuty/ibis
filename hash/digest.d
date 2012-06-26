module hash.digest;

import text.format;

final class Digest {
private:
  uint[] _data;

public:
  this(uint[] data) {
    _data = data.dup;
  }

  uint[] data() {
    return _data.dup;
  }

  char[] toString() {
    char[] ret = "";
    foreach (datum; _data) {
      char[] tmp = Format.integer(datum, 16);
      for (uint i = 0; i < 8 - tmp.length; i++) {
        ret ~= "0";
      }
      ret ~= tmp;
    }
    return ret;
  }

  bool isEqualTo(Digest b) {
    return b._data == _data;
  }

  int compareTo(Digest b) {
    if (_data > b._data) {
      return 1;
    }
    else if (_data < b._data) {
      return -1;
    }
    else {
      return 0;
    }
  }
}
