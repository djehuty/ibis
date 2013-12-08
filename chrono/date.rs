#[link(name = "chrono-date", vers = "1.0", package_id = "chrono-date")];

#[feature(globs)];
use chrono::month::*;
use chrono::weekday::*;

mod chrono {
  extern mod month = "chrono-month";
  extern mod weekday = "chrono-weekday";
}

pub struct Date {
  month: Month,
  day:   uint,
  year:  u64
}

impl Date {
  pub fn isLeapYear(&self) -> bool {
    (self.year % 400 == 0) || (!(self.year % 100 == 0) && (self.year % 4 == 0))
  }

  pub fn dayOfWeek(&self) -> Weekday {
    let yearNum =
      if ((self.year >= 1700 && self.year <= 1799) ||
          (self.year >= 2100 && self.year <= 2199) ||
          (self.year >= 2500 && self.year <= 2599) ) {
        4
      }
      else if ((self.year >= 1800 && self.year <= 1899) ||
               (self.year >= 2200 && self.year <= 2299) ||
               (self.year >= 2600 && self.year <= 2699) ) {
        2
      }
      else if ((self.year >= 1900 && self.year <= 1999) ||
               (self.year >= 2300 && self.year <= 2399) ){
        0
      }
      else if ((self.year >= 2000 && self.year <= 2099) ||
               (self.year >= 2400 && self.year <= 2499) ){
        6
      }
      else {
        -1
      };

    let yearDigitNum = (self.year % 100);
    let leapYearNum = yearDigitNum / 4;

    let monthNum =
      match self.month {
        January   => 0,
        October   => 0,
        February  => 3,
        March     => 3,
        November  => 3,
        April     => 6,
        July      => 6,
        May       => 1,
        June      => 4,
        August    => 2,
        September => 5,
        December  => 5
      };

    let dayNum = (yearNum + yearDigitNum + leapYearNum + monthNum + self.day as u64) % 7;

    match dayNum {
      0 => Sunday,
      1 => Monday,
      2 => Tuesday,
      3 => Wednesday,
      4 => Thursday,
      5 => Friday,
      _ => Saturday,
    }
  }
}
