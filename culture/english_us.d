module culture.english_us;

import culture.locale;

import chrono.month;
import chrono.weekday;

import text.format;

final class EnglishUS {
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

  char[] formatDate(Month month, uint day) {
    char[] ret = formatMonth(month);
    ret ~= " " ~ Format.integer(day, 10);

    if (day > 10 && day < 14) {
      ret ~= "th";
    }
    else {
      switch (day % 10) {
        case 1:
          ret ~= "st";
          break;
        case 2:
          ret ~= "nd";
          break;
        case 3:
          ret ~= "rd";
          break;
        default:
          ret ~= "th";
          break;
      }
    }

    return ret;
  }

  char[] formatDate(Month month, uint day, long year) {
    char[] ret = formatMonth(month);
    ret ~= " " ~ Format.integer(day, 10);

    if (day > 10 && day < 14) {
      ret ~= "th";
    }
    else {
      switch (day % 10) {
        case 1:
          ret ~= "st";
          break;
        case 2:
          ret ~= "nd";
          break;
        case 3:
          ret ~= "rd";
          break;
        default:
          ret ~= "th";
          break;
      }
    }

    ret ~= ", ";
    ret ~= Format.integer(year, 10);

    return ret;
  }

  char[] formatDateTime(Month month, uint day, long year, uint hour, uint minute) {
    char[] ret = formatTime(hour, minute);
    ret ~= " on ";
    ret ~= formatDate(month, day, year);
    return ret;
  }

  char[] formatDateTime(Month month, uint day, long year, uint hour, uint minute, uint second) {
    char[] ret = formatTime(hour, minute, second);
    ret ~= " on ";
    ret ~= formatDate(month, day, year);
    return ret;
  }

  char[] formatTime(uint hour, uint minute) {
    char[] ret = Format.integer(hour, 10);
    ret ~= ":";
    if (minute < 10) {
      ret ~= "0";
    }
    ret ~= Format.integer(minute, 10);
    return ret;
  }

  char[] formatTime(uint hour, uint minute, uint second) {
    char[] ret = Format.integer(hour, 10);
    ret ~= ":";
    if (minute < 10) {
      ret ~= "0";
    }
    ret ~= Format.integer(minute, 10);
    ret ~= ":";
    if (second < 10) {
      ret ~= "0";
    }
    ret ~= Format.integer(second, 10);
    return ret;
  }

  char[] formatMonth(Month month) {
    char[] ret = "???";
    switch(month) {
      case Month.January:
        ret = "January";
        break;
      case Month.February:
        ret = "February";
        break;
      case Month.March:
        ret = "March";
        break;
      case Month.April:
        ret = "April";
        break;
      case Month.May:
        ret = "May";
        break;
      case Month.June:
        ret = "June";
        break;
      case Month.July:
        ret = "July";
        break;
      case Month.August:
        ret = "August";
        break;
      case Month.September:
        ret = "September";
        break;
      case Month.October:
        ret = "October";
        break;
      case Month.November:
        ret = "November";
        break;
      case Month.December:
        ret = "December";
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
        ret = "Sunday";
        break;
      case Weekday.Monday:
        ret = "Monday";
        break;
      case Weekday.Tuesday:
        ret = "Tuesday";
        break;
      case Weekday.Wednesday:
        ret = "Wednesday";
        break;
      case Weekday.Thursday:
        ret = "Thursday";
        break;
      case Weekday.Friday:
        ret = "Friday";
        break;
      case Weekday.Saturday:
        ret = "Saturday";
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
    return "English";
  }

  char[] country() {
    return "United States of America";
  }

  char[] code() {
    return "engUS";
  }
}
