module culture.french_fr;

import culture.locale;

import chrono.month;
import chrono.weekday;

import text.format;

final class FrenchFr {
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
    ret ~= " ";
    ret ~= formatMonth(month);
    ret ~= " ";
    ret ~= format.integer(year, 10);

    return ret;
  }

  char[] formatDate(Month month, uint day) {
    auto format = new Format;

    char[] ret = format.integer(day, 10);
    ret ~= " ";
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
    ret ~= " h ";
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
        ret = "janvier";
        break;
      case Month.February:
        ret = "f\u00e9vier";
        break;
      case Month.March:
        ret = "mars";
        break;
      case Month.April:
        ret = "avril";
        break;
      case Month.May:
        ret = "mai";
        break;
      case Month.June:
        ret = "juin";
        break;
      case Month.July:
        ret = "juillet";
        break;
      case Month.August:
        ret = "ao\u00fbt";
        break;
      case Month.September:
        ret = "septembre";
        break;
      case Month.October:
        ret = "octobre";
        break;
      case Month.November:
        ret = "novembre";
        break;
      case Month.December:
        ret = "d\u00e9cembre";
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
        ret = "dimanche";
        break;
      case Weekday.Monday:
        ret = "lundi";
        break;
      case Weekday.Tuesday:
        ret = "mardi";
        break;
      case Weekday.Wednesday:
        ret = "mercredi";
        break;
      case Weekday.Thursday:
        ret = "jeudi";
        break;
      case Weekday.Friday:
        ret = "vendredi";
        break;
      case Weekday.Saturday:
        ret = "samedi";
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
