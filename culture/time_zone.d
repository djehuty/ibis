module culture.time_zone;

import culture.time_zone_selector;

import chrono.month;

final class TimeZone {
private:
  long function(long year, Month month, uint day, uint hour, uint minute) _offsetFunc;
  long function(long year, Month month, uint day, uint hour, uint minute) _savingsFunc;

public:

  this(long function(long year, Month month, uint day, uint hour, uint minute) offsetFunc,
       long function(long year, Month month, uint day, uint hour, uint minute) savingsFunc) {
    _offsetFunc  = offsetFunc;
    _savingsFunc = savingsFunc;
  }

  static TimeZone fromString(char[] timezone) {
    long function(long year, Month month, uint day, uint hour, uint minute) offsetFunc;
    long function(long year, Month month, uint day, uint hour, uint minute) savingsFunc;

    if (TimeZoneSelector.funcs(timezone, offsetFunc, savingsFunc)) {
      return new TimeZone(offsetFunc, savingsFunc);
    }

    return null;
  }

  long offset(long year, Month month, uint day, uint hour, uint minute) {
    return _offsetFunc(year, month, day, hour, minute);
  }

  long savings(long year, Month month, uint day, uint hour, uint minute) {
    return _savingsFunc(year, month, day, hour, minute);
  }
}
