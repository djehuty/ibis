#[crate_id="chrono-date_time#1.0"];
extern mod chrono_month   = "chrono-month";
extern mod chrono_weekday = "chrono-weekday";
extern mod chrono_date    = "chrono-date";
extern mod chrono_time    = "chrono-time";

pub mod chrono {
  pub mod date_time {
    use chrono_month::chrono::month::Month;
    use chrono_weekday::chrono::weekday::Weekday;
    use chrono_time::chrono::time::Time;
    use chrono_date::chrono::date::Date;

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
  }
}
