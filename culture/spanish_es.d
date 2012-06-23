module culture.spanish_es;

import culture.locale;

import chrono.month;
import chrono.weekday;

import text.format;

final class SpanishEs {
public:
  this() {
  }

  Locale locale() {
    return new Locale(&formatTime,
                      &formatTime,
                      &formatDate,
                      &formatDate,
                      &formatDateTime,
                      &formatDateTime,
                      &formatMonth,
                      &formatWeekday,
                      &formatFloatingPoint,
                      &language,
                      &country,
                      &code);
  }

  char[] formatDate(Month month, uint day, long year) {
    auto format = new Format;

    char[] ret = format.integer(day, 10);
    ret ~= " de ";
    ret ~= formatMonth(month);
    ret ~= " de ";
    ret ~= format.integer(year, 10);

    return ret;
  }

  char[] formatDate(Month month, uint day) {
    auto format = new Format;

    char[] ret = format.integer(day, 10);
    ret ~= " de ";
    ret ~= formatMonth(month);

    return ret;
  }

  char[] formatDateTime(Month month, uint day, long year, uint hour, uint minute) {
    char[] ret = formatDate(month, day, year);
    ret ~= " at ";
    ret ~= formatTime(hour, minute);
    return ret;
  }

  char[] formatDateTime(Month month, uint day, long year, uint hour, uint minute, uint second) {
    char[] ret = formatDate(month, day, year);
    ret ~= " at ";
    ret ~= formatTime(hour, minute, second);
    return ret;
  }

  char[] formatTime(uint hour, uint minute) {
    auto format = new Format;

    char[] ret = format.integer(hour, 10);
    ret ~= ":";
    if (minute < 10) {
      ret ~= "0";
    }
    ret ~= format.integer(minute, 10);
    return ret;
  }

  char[] formatTime(uint hour, uint minute, uint second) {
    auto format = new Format;

    char[] ret = format.integer(hour, 10);
    ret ~= ":";
    if (minute < 10) {
      ret ~= "0";
    }
    ret ~= format.integer(minute, 10);
    ret ~= ":";
    if (second < 10) {
      ret ~= "0";
    }
    ret ~= format.integer(second, 10);
    return ret;
  }

  char[] formatMonth(Month month) {
    char[] ret = "???";
    switch(month) {
      case Month.January:
        ret = "enero";
        break;
      case Month.February:
        ret = "febrero";
        break;
      case Month.March:
        ret = "marzo";
        break;
      case Month.April:
        ret = "abril";
        break;
      case Month.May:
        ret = "mayo";
        break;
      case Month.June:
        ret = "junio";
        break;
      case Month.July:
        ret = "julio";
        break;
      case Month.August:
        ret = "agosto";
        break;
      case Month.September:
        ret = "septiembre";
        break;
      case Month.October:
        ret = "octubre";
        break;
      case Month.November:
        ret = "noviembre";
        break;
      case Month.December:
        ret = "diciembre";
        break;
      default:
        ret = "???";
        break;
    }
    return ret;
  }

  char[] formatWeekday(Weekday weekday) {
    char[] ret = "";
    switch(weekday) {
      case Weekday.Sunday:
        ret = "domingo";
        break;
      case Weekday.Monday:
        ret = "lunes";
        break;
      case Weekday.Tuesday:
        ret = "martes";
        break;
      case Weekday.Wednesday:
        ret = "mi\u00e9rcoles";
        break;
      case Weekday.Thursday:
        ret = "jueves";
        break;
      case Weekday.Friday:
        ret = "viernes";
        break;
      case Weekday.Saturday:
        ret = "s\u00e1bado";
        break;
      default:
        ret = "???";
        break;
    }
    return ret;
  }

  char[] formatFloatingPoint(double value) {
    return "0.0";
  }

  char[] language() {
    return "fran\u00e7ais";
  }

  char[] country() {
    return "france";
  }
  
  char[] code() {
    return "fraFR";
  }
}
