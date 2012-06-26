module culture.locale;

import chrono.month;
import chrono.weekday;

final class Locale {
private:
  char[] delegate(uint, uint)                          _timeShortFunc;
  char[] delegate(uint, uint, uint)                    _timeLongFunc;
  char[] delegate(Month, uint)                         _dateShortFunc;
  char[] delegate(Month, uint, long)                   _dateLongFunc;
  char[] delegate(Month, uint, long, uint, uint)       _dateTimeShortFunc;
  char[] delegate(Month, uint, long, uint, uint, uint) _dateTimeLongFunc;
  char[] delegate(Month)                               _monthFunc;
  char[] delegate(Weekday)                             _weekdayFunc;
  char[] delegate(double)                              _floatingPointFunc;

  char[] delegate()                                    _languageFunc;
  char[] delegate()                                    _countryFunc;
  char[] delegate()                                    _codeFunc;

public:
  this(char[] delegate(uint, uint)                          timeShortFunc,
       char[] delegate(uint, uint, uint)                    timeLongFunc,
       char[] delegate(Month, uint)                         dateShortFunc,
       char[] delegate(Month, uint, long)                   dateLongFunc,
       char[] delegate(Month, uint, long, uint, uint)       dateTimeShortFunc,
       char[] delegate(Month, uint, long, uint, uint, uint) dateTimeLongFunc,
       char[] delegate(Month)                               monthFunc,
       char[] delegate(Weekday)                             weekdayFunc,
       char[] delegate(double)                              floatingPointFunc,
       char[] delegate()                                    languageFunc,
       char[] delegate()                                    countryFunc,
       char[] delegate()                                    codeFunc) {
    _timeLongFunc      = timeLongFunc;
    _timeShortFunc     = timeShortFunc;
    _dateLongFunc      = dateLongFunc;
    _dateShortFunc     = dateShortFunc;
    _dateTimeShortFunc = dateTimeShortFunc;
    _dateTimeLongFunc  = dateTimeLongFunc;
    _monthFunc         = monthFunc;
    _weekdayFunc       = weekdayFunc;
    _floatingPointFunc = floatingPointFunc;
    _languageFunc      = languageFunc;
    _countryFunc       = countryFunc;
    _codeFunc          = codeFunc;
  }

  char[] formatTime(uint hour, uint minute) {
    return _timeShortFunc(hour, minute);
  }

  char[] formatTime(uint hour, uint minute, uint second) {
    return _timeLongFunc(hour, minute, second);
  }

  char[] formatDate(Month month, uint day) {
    return _dateShortFunc(month, day);
  }

  char[] formatDate(Month month, uint day, long year) {
    return _dateLongFunc(month, day, year);
  }

  char[] formatDateTime(Month month, uint day, long year,
                        uint hour, uint minute) {
    return _dateTimeShortFunc(month, day, year, hour, minute);
  }

  char[] formatDateTime(Month month, uint day, long year,
                        uint hour, uint minute, uint second) {
    return _dateTimeLongFunc(month, day, year, hour, minute, second);
  }

  char[] formatMonth(Month month) {
    return _monthFunc(month);
  }

  char[] formatWeekday(Weekday weekday) {
    return _weekdayFunc(weekday);
  }

  char[] formatFloatingPoint(double value) {
    return _floatingPointFunc(value);
  }

  char[] country() {
    return _countryFunc();
  }

  char[] language() {
    return _languageFunc();
  }

  char[] code() {
    return _codeFunc();
  }
}
