module text.parser;

import chrono.date_time;
import chrono.date;
import chrono.time;
import chrono.month;

final class Parser {
private:
  char[] _string;
  size_t _position;

public:
  this(char[] string) {
    _string = string;
  }

  long nextInteger() {
    size_t curpos;

    if (_position == _string.length) {
      return 0;
    }

    for(curpos = _position; curpos < _string.length; curpos++) {
      if (_string[curpos] != ' ' &&
          _string[curpos] != '\t' &&
          _string[curpos] != '\r' &&
          _string[curpos] != '\n') {

        break;
      }
    }

    bool negative = false;

    if (_string[curpos] == '-') {
      negative = true;
      curpos++;
      if (curpos == _string.length) {
        return 0;
      }
    }

    if (_string[curpos] < '0' ||
        _string[curpos] > '9') {

      return 0;
    }

    long tmpval = 0;

    for ( ; curpos < _string.length; curpos++) {
      if (_string[curpos] < '0' ||
          _string[curpos] > '9') {

        break;
      }

      tmpval *= 10;
      tmpval += cast(long)(_string[curpos] - '0');
    }

    if (negative) {
      tmpval = -tmpval;
    }

    _position = curpos;

    return cast(long)tmpval;
  }

  static long integer(char[] string) {
    return (new Parser(string)).nextInteger();
  }

  char[] nextString() {
    foreach(size_t idx, chr; _string[_position..$]) {
      size_t currentPosition = idx + _position;
      if (chr != ' ' &&
          chr != '\t' &&
          chr != '\r' &&
          chr != '\n') {

        _position = currentPosition;
        break;
      }
    }

    foreach(size_t idx, chr; _string[_position..$]) {
      size_t currentPosition = idx + _position;
      if (chr == ' ' || chr == '\t' || chr == '\n' || chr == '\r') {
        size_t start = _position;
        _position    = currentPosition;

        return _string[start..currentPosition];
      }
    }

    size_t start = _position;
    _position = _string.length;
    return _string[start..$];
  }

  char[] string(char[] input) {
    return (new Parser(input)).nextString();
  }

  DateTime nextDateTime(char[] format) {
    Month  month  = Month.January;
    uint   day    = 1;
    long   year   = 0;
    long   hour   = 0;
    long   minute = 0;
    long   second = 0;
    long   micros = 0;
    char[] zone   = "UTC";

    size_t last_idx = 0;
    bool inCurly = false;
    char[] formatTag;
    foreach(size_t idx, chr; format) {
      if (chr == '{') {
        inCurly = true;
        last_idx = idx + 1;
      }
      else if (chr == '}' && inCurly) {
        inCurly = false;
        formatTag = format[last_idx..idx];

        switch (formatTag) {
          case "Weekday":
            // Parse string out
            _position += 3;
            break;
          case "Day":
            // Parse number out
            day = nextInteger();
            break;
          case "Month":
            // Parse month as string
            char[] tmp = nextString();
            if (tmp.length > 2) {
              switch (tmp[0..3]) {
                case "Jan":
                  month = Month.January;
                  break;
                case "Feb":
                  month = Month.February;
                  break;
                case "Mar":
                  month = Month.March;
                  break;
                case "Apr":
                  month = Month.April;
                  break;
                case "May":
                  month = Month.May;
                  break;
                case "Jun":
                  month = Month.June;
                  break;
                case "Jul":
                  month = Month.July;
                  break;
                case "Aug":
                  month = Month.August;
                  break;
                case "Sep":
                  month = Month.September;
                  break;
                case "Oct":
                  month = Month.October;
                  break;
                case "Nov":
                  month = Month.November;
                  break;
                default:
                  month = Month.December;
                  break;
              }
            }
            break;
          case "Year":
            year = nextInteger();
            break;
          case "Hour":
            hour = nextInteger();
            micros += hour * 3600 * 1000000;
            break;
          case "Minute":
            minute = nextInteger();
            micros += minute * 60 * 1000000;
            break;
          case "Second":
            second = nextInteger();
            micros += second * 1000000;
            break;
          case "Zone":
            zone = nextString();
            break;
          default:
            // Ignore
            break;
        }
      }
      else if (!inCurly) {
        // Parse character for character in format string
        if (_position != _string.length && _string[_position] == chr) {
          _position++;
        }
      }
    }
    return new DateTime(month, day, year, micros);
  }

  static DateTime dateTime(char[] string, char[] format) {
    return (new Parser(string)).nextDateTime(format);
  }

  Date nextDate(char[] format) {
    return nextDateTime(format).date;
  }

  static Date date(char[] string, char[] format) {
    return (new Parser(string)).nextDate(format);
  }

  Time nextTime(char[] format) {
    return nextDateTime(format).time;
  }

  static Time time(char[] string, char[] format) {
    return (new Parser(string)).nextTime(format);
  }
}
