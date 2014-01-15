#[crate_id="locale-french_fr#1.0"];
#[feature(globs)];

extern mod culture_locale = "culture-locale";

extern mod chrono_month   = "chrono-month";
extern mod chrono_weekday = "chrono-weekday";
extern mod chrono_date    = "chrono-date";
extern mod chrono_time    = "chrono-time";

extern mod text_format    = "text-format";

mod culture {
  pub mod locale {
    pub use culture_locale::culture::locale::*;
  }
}

mod chrono {
  pub mod weekday {
    pub use chrono_weekday::chrono::weekday::*;
  }

  pub mod month {
    pub use chrono_month::chrono::month::*;
  }

  pub mod date {
    pub use chrono_date::chrono::date::*;
  }

  pub mod time {
    pub use chrono_time::chrono::time::*;
  }
}

mod text {
  pub mod format {
    pub use text_format::text::format::*;
  }
}

pub mod locale {
  pub mod french_fr {
    use chrono::month::*;
    use chrono::weekday::*;
    pub fn locale() -> ::culture::locale::Locale {
      ::culture::locale::Locale { timeShort:     timeShort,
               timeLong:      timeLong,
               dateShort:     dateShort,
               dateLong:      dateLong,
               dateTimeShort: dateTimeShort,
               dateTimeLong:  dateTimeLong,
               month:         month,
               weekday:       weekday,
               floatingPoint: floatingPoint,
               language:      language,
               country:       country,
               code:          code }
    }

    pub fn timeShort(hour: u32, minute: u32) -> ~str {
      let ret = ::text::format::integer(hour as i64, 10) + " h ";

      if (minute < 10) {
        ret + "0" + ::text::format::integer(minute as i64, 10)
      }
      else {
        ret + ::text::format::integer(minute as i64, 10)
      }
    }

    pub fn timeLong(hour: u32, minute: u32, second: u32) -> ~str {
      let mut ret = ::text::format::integer(hour as i64, 10) + ":";

      ret =
        if (minute < 10) {
          ret + "0" + ::text::format::integer(minute as i64, 10)
        }
        else {
          ret + ::text::format::integer(minute as i64, 10)
        };

      ret = ret.append(":");

      if (second < 10) {
        ret + "0" + ::text::format::integer(second as i64, 10)
      }
      else {
        ret + ::text::format::integer(second as i64, 10)
      }
    }

    pub fn dateShort(month: Month, day: u32) -> ~str {
      ::locale::french_fr::month(month) + " " + ::text::format::integer(day as i64, 10)
    }

    pub fn dateLong(month: Month, day: u32, year: u64) -> ~str {
      ::locale::french_fr::month(month) + " " + ::text::format::integer(day as i64, 10)
                     + " " + ::text::format::integer(year as i64, 10)
    }

    pub fn dateTimeShort(month: Month, day: u32, year: u64, hour: u32, minute: u32) -> ~str {
      timeShort(hour, minute) + " on " + dateLong(month, day, year)
    }

    pub fn dateTimeLong(month: Month, day: u32, year: u64, hour: u32, minute: u32, second: u32) -> ~str {
      timeLong(hour, minute, second) + " on " + dateLong(month, day, year)
    }

    pub fn month(month: Month) -> ~str {
      match month {
        January   => ~"janvier",
        February  => ~"f\u00e9vier",
        March     => ~"mars",
        April     => ~"avril",
        May       => ~"mai",
        June      => ~"juin",
        July      => ~"juillet",
        August    => ~"ao\u00fbt",
        September => ~"septembre",
        October   => ~"octobre",
        November  => ~"novembre",
        December  => ~"d\u00e9cember"
      }
    }

    pub fn weekday(weekday: Weekday) -> ~str {
      match weekday {
        Sunday    => ~"dimanche",
        Monday    => ~"lundi",
        Tuesday   => ~"mardi",
        Wednesday => ~"mercredi",
        Thursday  => ~"jeudi",
        Friday    => ~"vendredi",
        Saturday  => ~"samedi"
      }
    }

    pub fn floatingPoint(value: f64) -> ~str {
      ::text::format::floatingPoint(value, 10, ~".")
    }

    pub fn language() -> ~str {
      ~"fran\u00e7ais"
    }

    pub fn country() -> ~str {
      ~"france"
    }

    pub fn code() -> ~str {
      ~"fraFR"
    }
  }
}
