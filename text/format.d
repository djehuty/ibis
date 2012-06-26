module text.format;

final class Format {
private:

  union longDouble {
    long l;
    double f;
  }

  static char[] _dtoa(double val, uint base = 10) {
    char[][] foo = _pdtoa(val, base);

    char[] ret = foo[0];
    if (foo[1].length > 0) {
      ret ~= "." ~ foo[1];
    }

    return ret;
  }

  static char[][] _pdtoa(double val, uint base = 10) {
    if (val is double.infinity) {
      return ["inf",""];
    }
    else if (val !<>= 0.0) {
      return ["nan",""];
    }
    else if (val == 0.0) {
      return ["0",""];
    }

    long mantissa;
    long intPart;
    long fracPart;

    long exp;

    longDouble iF;
    iF.f = val;

    // Conform to the IEEE standard
    exp = ((iF.l >> 52) & 0x7ff);
    if (exp == 0) {
      return ["0",""];
    }
    else if (exp == 0x7ff) {
      return ["inf",""];
    }
    exp -= 1023;

    mantissa = (iF.l & 0xfffffffffffff) | 0x10000000000000;
    fracPart = 0;
    intPart = 0;

    if (exp < -52) {
      return ["0",""];
    }
    else if (exp >= 52) {
      intPart = mantissa << (exp - 52);
    }
    else if (exp >= 0) {
      intPart = mantissa >> (52 - exp);
      fracPart = (mantissa << (exp + 1)) & 0x1fffffffffffff;
    }
    else { // exp < 0
      fracPart = (mantissa & 0x1fffffffffffff) >> (-(exp + 1));
    }

    char[][] ret = ["", ""];
    if (iF.l < 0) {
      ret[0] = "-";
    }

    ret[0] ~= integer(intPart, base);

    for (uint k; k < 7; k++) {
      fracPart *= 10;
      ret[1] ~= cast(char)((fracPart >> 53) + '0');
      fracPart &= 0x1fffffffffffff;
    }

    // round last digit
    bool roundUp = (ret[1][$-1] >= '5');
    ret[1] = ret[1][0..$-1];

    while (roundUp) {
      if (ret[0].length == 0 && ret[1].length == 0) {
        return ["0",""];
      }
      else if (ret[1][$-1] == '9') {
        ret[1] = ret[1][0..$-1];
        continue;
      }
      ret[1][$-1]++;
      break;
    }

    // get rid of useless zeroes (and point if necessary)
    foreach_reverse(uint i, chr; ret[1]) {
      if (chr != '0') {
        ret[1] = ret[1][0..i+1];
        break;
      }
    }

    return ret;
  }

public:

  static char[] integer(long value, uint base) {
    int intlen;
    long tmp = value;

    bool negative;

    if (tmp < 0) {
      negative = true;
      tmp = -tmp;
      intlen = 2;
    }
    else {
      negative = false;
      intlen = 1;
    }

    while (tmp >= base) {
      tmp /= base;
      intlen++;
    }

    //allocate

    char[] ret = new char[intlen];

    intlen--;

    if (negative) {
      tmp = -value;
    } else {
      tmp = value;
    }

    do {
      uint off = cast(uint)(tmp % base);
      char replace;
      if (off < 10) {
        replace = cast(char)('0' + off);
      }
      else if (off < 36) {
        off -= 10;
        replace = cast(char)('a' + off);
      }
      ret[intlen] = replace;
      tmp /= base;
      intlen--;
    } while (tmp != 0);


    if (negative) {
      ret[intlen] = '-';
    }

    return ret;
  }

  static char[] floatingPoint(double value, uint base) {
    return _dtoa(value, base);
  }
}
