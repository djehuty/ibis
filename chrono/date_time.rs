use chrono::month::*;
use chrono::weekday::*;
use chrono::date::*;
use chrono::time::*;

mod chrono {
  extern mod month;
  extern mod weekday;
  extern mod date;
  extern mod time;
}

pub struct DateTime {
  month:        Month,
  day:          uint,
  year:         u64,
  microseconds: u64
}

impl DateTime {
  pub fn isLeapYear(&self) -> bool {
    let date = Date { month: self.month, day: self.day, year: self.year };

    date.isLeapYear()
  }

  pub fn dayOfWeek(&self) -> Weekday {
    let date = Date { month: self.month, day: self.day, year: self.year };

    date.dayOfWeek()
  }

  pub fn hour(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.hour()
  }

  pub fn minute(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.minute()
  }


  pub fn second(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.second()
  }

  pub fn millisecond(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.millisecond()
  }

  pub fn microsecond(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.microsecond()
  }

  pub fn hours(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.hours()
  }

  pub fn minutes(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.minutes()
  }

  pub fn seconds(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.seconds()
  }

  pub fn milliseconds(&self) -> u64 {
    let time = Time { microseconds: self.microseconds };

    time.milliseconds()
  }
}
