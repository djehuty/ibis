module chrono.time;

final class Time {
private:
  // Time since midnight.
  long _micros;

public:
  this() {
    _micros = 0;
  }

  this(long microseconds) {
    _micros = microseconds;
  }

  this(long hour, long minute, long second, long microsecond) {
    _micros = hour;
    _micros *= 60;
    _micros += minute;
    _micros *= 60;
    _micros += second;
    _micros *= 1000000;
    _micros += microsecond;
  }

  // Properties //

  long hour() {
    long h, ms, s, m;
    long tmp = _micros;

    tmp /= 1000000;
    tmp /= 60;
    tmp /= 60;

    return tmp;
  }

  long minute() {
    long h, ms, s, m;
    long tmp = _micros;

    tmp /= 1000000;
    tmp /= 60;

    return tmp;
  }

  long second() {
    long h, ms, s, m;
    long tmp = _micros;

    tmp /= 1000000;

    return tmp;
  }

  long milliseconds() {
    long h, ms, s, m;
    long tmp = _micros;

    return tmp / 1000;
  }

  long microseconds() {
    return _micros;
  }

  // Methods //

  Time add(Time b) {
    return new Time(_micros + b._micros);
  }

  Time subtract(Time b) {
    return new Time(_micros - b._micros);
  }

  int compare(Time b) {
    return cast(int)(_micros - b._micros);
  }

  bool isEqualTo(Time b) {
    return _micros == b._micros;
  }
}
