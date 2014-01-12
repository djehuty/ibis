#[crate_id="culture-locale#1.0"];

extern mod chrono_month   = "chrono-month";
extern mod chrono_weekday = "chrono-weekday";

pub mod culture {
  pub mod locale {
    use chrono_month::chrono::month::Month;
    use chrono_weekday::chrono::weekday::Weekday;

    pub struct Locale {
      timeShort:     fn(u32, u32) -> ~str,
      timeLong:      fn(u32, u32, u32) -> ~str,
      dateShort:     fn(Month, u32) -> ~str,
      dateLong:      fn(Month, u32, u64) -> ~str,
      dateTimeShort: fn(Month, u32, u64, u32, u32) -> ~str,
      dateTimeLong:  fn(Month, u32, u64, u32, u32, u32) -> ~str,
      month:         fn(Month) -> ~str,
      weekday:       fn(Weekday) -> ~str,
      floatingPoint: fn(f64) -> ~str,
      language:      fn() -> ~str,
      country:       fn() -> ~str,
      code:          fn() -> ~str
    }

    impl Locale {
      pub fn timeShort(&self, hour: u32, minute: u32) -> ~str {
        (self.timeShort)(hour, minute)
      }

      pub fn timeLong(&self, hour: u32, minute: u32, second: u32) -> ~str {
        (self.timeLong)(hour, minute, second)
      }

      pub fn dateShort(&self, month: Month, day: u32) -> ~str {
        (self.dateShort)(month, day)
      }

      pub fn dateLong(&self, month: Month, day: u32, year: u64) -> ~str {
        (self.dateLong)(month, day, year)
      }

      pub fn dateTimeShort(&self, month: Month, day: u32, year: u64, hour: u32, minute: u32) -> ~str {
        (self.dateTimeShort)(month, day, year, hour, minute)
      }

      pub fn dateTimeLong(&self, month: Month, day: u32, year: u64, hour: u32, minute: u32, second: u32) -> ~str {
        (self.dateTimeLong)(month, day, year, hour, minute, second)
      }

      pub fn month(&self, month: Month) -> ~str {
        (self.month)(month)
      }

      pub fn weekday(&self, weekday: Weekday) -> ~str {
        (self.weekday)(weekday)
      }

      pub fn floatingPoint(&self, value: f64) -> ~str {
        (self.floatingPoint)(value)
      }

      pub fn language(&self) -> ~str {
        (self.language)()
      }

      pub fn country(&self) -> ~str {
        (self.country)()
      }

      pub fn code(&self) -> ~str {
        (self.code)()
      }
    }
  }
}
