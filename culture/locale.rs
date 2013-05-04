use chrono::month::*;
use chrono::weekday::*;

mod chrono {
  extern mod month;
  extern mod weekday;
}

pub struct Locale {
  timeShort:     ~fn(u32, u32) -> ~str,
  timeLong:      ~fn(u32, u32, u32) -> ~str,
  dateShort:     ~fn(Month, u32) -> ~str,
  dateLong:      ~fn(Month, u32, u64) -> ~str,
  dateTimeShort: ~fn(Month, u32, u64, u32, u32) -> ~str,
  dateTimeLong:  ~fn(Month, u32, u64, u32, u32, u32) -> ~str,
  month:         ~fn(Month) -> ~str,
  weekday:       ~fn(Weekday) -> ~str,
  floatingPoint: ~fn(f64) -> ~str,
  language:      ~fn() -> ~str,
  country:       ~fn() -> ~str,
  code:          ~fn() -> ~str
}
