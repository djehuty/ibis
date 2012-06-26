module chrono.date_time;

import chrono.month;
import chrono.weekday;
import chrono.date;
import chrono.time;

final class DateTime {
private:
  Month _month;
  uint _day;
  long _year;
  long _micros;

public:
  this() {
    _month = Month.January;
    _day = 1;
    _year = 0;
    _micros = 0;
  }

  this(Month month, uint day, long year) {
    _month = month;
    _day = day;
    _year = year;
    _micros = 0;
  }

  this(Month month, uint day, long year, long microseconds) {
    _month = month;
    _day = day;
    _year = year;
    _micros = microseconds;
  }

  Month month() {
    return _month;
  }

  uint day() {
    return _day;
  }

  long year() {
    return _year;
  }

  Date date() {
    return new Date(_month, _day, _year);
  }

  Time time() {
    return new Time(_micros);
  }

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

  bool isLeapYear() {
    if (_year % 400 == 0) {
      return true;
    }
    else if (_year % 100 == 0) {
      return false;
    }
    else if (_year % 4 == 0) {
      return true;
    }
    return false;
  }

  Weekday dayOfWeek() {
    // magicNum is a number manipulated in order to determine the day
    // of the week as part of the Gregorian calendar algorithm
    int yearNum = -1;

    // there's gotta be a better way to do this.
    if ((_year >= 1700 && _year <= 1799) ||
        (_year >= 2100 && _year <= 2199) ||
        (_year >= 2500 && _year <= 2599) ) {
      yearNum = 4;
    }
    else if ((_year >= 1800 && _year <= 1899) ||
             (_year >= 2200 && _year <= 2299) ||
             (_year >= 2600 && _year <= 2699) ) {
      yearNum = 2;
    }
    else if ((_year >= 1900 && _year <= 1999) ||
             (_year >= 2300 && _year <= 2399) ){
      yearNum = 0;
    }
    else if ((_year >= 2000 && _year <= 2099) ||
             (_year >= 2400 && _year <= 2499) ){
      yearNum = 6;
    }
    else {
      // year with unknown value
    }

    int yearDigitNum = (_year % 100);
    int leapYearNum = yearDigitNum / 4;
    int monthNum = -1;

    switch(_month){
      case Month.January:
      case Month.October:
        monthNum = 0;
        break;
      case Month.February:
      case Month.March:
      case Month.November:
        monthNum = 3;
        break;
      case Month.April:
      case Month.July:
        monthNum = 6;
        break;
      case Month.May:
        monthNum = 1;
        break;
      case Month.June:
        monthNum = 4;
        break;
      case Month.August:
        monthNum = 2;
        break;
      case Month.September:
      case Month.December:
        monthNum = 5;
        break;
      default:
        break;
    }

    int dayNum = (yearNum + yearDigitNum + leapYearNum + monthNum + _day) % 7;

    return cast(Weekday)dayNum;
  }
}
