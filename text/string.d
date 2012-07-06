module text.string;

import text.unicode;

final class String {
private:
  char[] _string;

  static char[] _substring(char[] str, long start, long len) {
    uint[] _indices = Unicode.calcIndices(str);

    if (start >= _indices.length || len == 0) {
      return "";
    }

    if (len < 0) {
      len = -1;
    }

    if (len >= 0 && start + len >= _indices.length) {
      len = -1;
    }

    // subdivide

    if (len == -1) {
      start = _indices[start];
      char[] ret = str[start..$].dup;
      return ret;
    }

    // this is the index for one character past the
    // end of the substring of the original string...hence, len is
    // now the exclusive end of the range to slice the array.
    len = _indices[start+len];

    start = _indices[start];

    return str[start..len].dup;
  }

  static char[] _replace(char[] str, dchar find, dchar replace) {
    char[] ret = str.dup;
    uint[] _indices = Unicode.calcIndices(str);

    for(int i = 0; i < _indices.length; i++) {
      dchar cmpChar = Unicode.toUtf32Char(ret[_indices[i]..$]);
      if (cmpChar == find) {
        dchar[1] chrs = [replace];
        ret = ret[0.._indices[i]] ~ Unicode.toUtf8(chrs) ~ ret[_indices[i+1]..$];
        _indices = Unicode.calcIndices(ret);
      }
    }

    return ret;
  }

  static long _findReverse(char[] source, char[] search, long start) {
    if (start == long.max) {
      start = source.length;
    }

    if (search == "") {
      return -1;
    }

    uint[] _indices       = Unicode.calcIndices(source);
    uint[] search_indices = Unicode.calcIndices(search);

    bool found;

    int o;
    foreach_reverse (size_t i, aPos; _indices[0..start]) {
      found = true;
      o = i - 1;

      foreach (bPos; search_indices) {
        o++;
        if(o >= _indices.length) {
          found = false;
          break;
        }

        dchar aChr, bChr;

        aChr = Unicode.toUtf32Char(source[_indices[o]..$]);
        bChr = Unicode.toUtf32Char(search[bPos..$]);

        if (aChr != bChr) {
          found = false;
          break;
        }
      }
      if (found) {
        return i;
      }
    }

    return -1;
  }

  static long _find(char[] source, char[] search, long start) {
    // look through string for term search
    // in some, hopefully later on, efficient manner

    uint[] _indices = Unicode.calcIndices(source);
    uint[] search_indices = Unicode.calcIndices(search);

    if (search == "") {
      return -1;
    }

    if (start >= _indices.length) {
      return -1;
    }

    bool found;

    int o;

    foreach (i, aPos; _indices[start..$]) {
      found = true;
      o=i-1+start;
      foreach (bPos; search_indices) {
        o++;
        if (o >= _indices.length) {
          found = false;
          break;
        }

        dchar aChr, bChr;

        aChr = Unicode.toUtf32Char(source[_indices[o]..$]);
        bChr = Unicode.toUtf32Char(search[bPos..$]);

        if (aChr != bChr) {
          found = false;
          break;
        }
      }
      if (found) {
        return i+start;
      }
    }

    return -1;
  }

  static char[] _times(char[] str, int amount) {
    if (amount <= 0) {
      return "";
    }

    char[] ret = "";
    for(int i = 0; i < amount; i++) {
      ret ~= str;
    }
    return ret;
  }

  static bool _startsWith(char[] str, char[] find) {
    if (str.length < find.length) {
      return false;
    }

    return str[0..find.length] == find;
  }

  static bool _endsWith(char[] str, char[] find) {
    if (str.length < find.length) {
      return false;
    }

    return str[str.length-find.length..str.length] == find;
  }

  static char[] _charAt(char[] string, long index) {
    uint[] _indices = Unicode.calcIndices(string);

    long start, end;

    if (_indices.length > index) {
      start = _indices[index];
    }
    else {
      return null;
    }

    if (_indices.length > index + 1) {
      end = _indices[index + 1];
    }
    else {
      end = string.length;
    }

    return string[start..end];
  }

  static char[] _insertAt(char[] string, char[] addition, long index) {
    uint[] _indices = Unicode.calcIndices(string);

    int pos;
    if (_indices.length > index) {
      pos = _indices[index];
    }
    else if (index == _indices.length) {
      pos = string.length;
    }
    else {
      return null;
    }

    return string[0..pos] ~ addition ~ string[pos..$];
  }

public:
  this() {
    _string = "";
  }

  this(char[] string) {
    _string = string.dup;
  }

  char[] substring(long start) {
    return _substring(_string, start, -1);
  }

  char[] substring(long start, long len) {
    return _substring(_string, start, len);
  }

  static char[] substring(char[] string, long start) {
    return _substring(string, start, -1);
  }

  static char[] substring(char[] string, long start, long len) {
    return _substring(string, start, len);
  }

  char[] replace(dchar find, dchar replace) {
    return _replace(_string, find, replace);
  }

  static char[] replace(char[] string, dchar find, dchar replace) {
    return _replace(string, find, replace);
  }

  long findReverse(char[] search, long start) {
    return _findReverse(_string, search, start);
  }

  static long findReverse(char[] string, char[] search, long start) {
    return _findReverse(string, search, start);
  }

  long find(char[] search, long start) {
    return _find(_string, search, start);
  }

  static long find(char[] string, char[] search, long start) {
    return _find(string, search, start);
  }

  char[] times(long amount) {
    return _times(_string, amount);
  }

  static char[] times(char[] string, long amount) {
    return _times(string, amount);
  }

  bool startsWith(char[] search) {
    return _startsWith(_string, search);
  }

  static bool startsWith(char[] string, char[] search) {
    return _startsWith(string, search);
  }

  bool endsWith(char[] search) {
    return _endsWith(_string, search);
  }

  static bool endsWith(char[] string, char[] search) {
    return _endsWith(string, search);
  }

  char[] charAt(long index) {
    return _charAt(_string, index);
  }

  static char[] charAt(char[] string, long index) {
    return _charAt(string, index);
  }

  char[] insertAt(char[] addition, long index) {
    return _insertAt(_string, addition, index);
  }

  static char[] insertAt(char[] string, char[] addition, long index) {
    return _insertAt(string, addition, index);
  }
}
