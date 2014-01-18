#[crate_id="system-time#1.0"];
#[feature(globs)];

extern mod chrono_date_time = "chrono-date_time";
extern mod chrono_date      = "chrono-date";
extern mod chrono_time      = "chrono-time";
extern mod chrono_month     = "chrono-month";

#[cfg(target_os = "linux")]
mod os {
  pub type time_t = i32;
  pub type c_long    = i64;

  pub struct tm {
    tm_sec:    i32,
    tm_min:    i32,
    tm_hour:   i32,
    tm_mday:   i32,
    tm_mon:    i32,
    tm_year:   i32,
    tm_wday:   i32,
    tm_yday:   i32,
    tm_isdst:  i32,
    tm_zone:   *char,
    tm_gmtoff: i32,
  }

  pub struct timeval {
    tv_sec:  c_long,
    tv_usec: c_long,
  }

  #[nolink]
  extern {
    pub fn gmtime_r(tim: *time_t, output: *mut tm) -> *tm;
    pub fn localtime_r(tim: *time_t, output: *mut tm) -> *tm;
    pub fn gettimeofday(tval: *mut timeval, data: *u8) -> i32;
  }
}

mod chrono {
  pub mod date_time {
    pub use chrono_date_time::chrono::date_time::*;
  }

  pub mod time {
    pub use chrono_time::chrono::time::*;
  }

  pub mod date {
    pub use chrono_date::chrono::date::*;
  }

  pub mod month {
    pub use chrono_month::chrono::month::*;
  }
}

pub mod system {
  pub mod time {
    use chrono::month::*;
    use chrono::date_time::*;
    use chrono::date::*;
    use chrono::time::*;

    pub fn current_date_time() -> ~DateTime {
      let dt   = current_date();
      let time = current_time();

      ~DateTime {
        month:        dt.month,
        day:          dt.day,
        year:         dt.year,
        microseconds: time.microseconds,
      }
    }

    pub fn current_time() -> ~Time {
      let mut gmt = ::os::tm {
        tm_sec:    0,
        tm_min:    0,
        tm_hour:   0,
        tm_mday:   0,
        tm_mon:    0,
        tm_year:   0,
        tm_wday:   0,
        tm_yday:   0,
        tm_isdst:  0,
        tm_zone:   0 as *char,
        tm_gmtoff: 0,
      };

      let usec = unsafe {
        let mut tval = ::os::timeval {
          tv_sec:  0,
          tv_usec: 0,
        };

        ::os::gettimeofday(&mut tval as *mut ::os::timeval, 0 as *u8);
        ::os::gmtime_r(&tval.tv_sec as *::os::c_long as *::os::time_t, &mut gmt as *mut ::os::tm);

        tval.tv_usec
      };

      let mut micros: u64 = gmt.tm_sec  as u64          +
                            gmt.tm_min  as u64 * 60     +
                            gmt.tm_hour as u64 * 60 * 60;
      micros *= 1000000;
      micros += usec as u64;

      ~Time {
        microseconds: micros
      }
    }

    pub fn current_date() -> ~Date {
      let mut gmt = ::os::tm {
        tm_sec:    0,
        tm_min:    0,
        tm_hour:   0,
        tm_mday:   0,
        tm_mon:    0,
        tm_year:   0,
        tm_wday:   0,
        tm_yday:   0,
        tm_isdst:  0,
        tm_zone:   0 as *char,
        tm_gmtoff: 0,
      };

      unsafe {
        let mut tval = ::os::timeval {
          tv_sec:  0,
          tv_usec: 0,
        };

        ::os::gettimeofday(&mut tval as *mut ::os::timeval, 0 as *u8);
        ::os::gmtime_r(&tval.tv_sec as *::os::c_long as *::os::time_t, &mut gmt as *mut ::os::tm);
      }

      let month = match gmt.tm_mon {
        1  => January,
        2  => February,
        3  => March,
        4  => April,
        5  => May,
        6  => June,
        7  => July,
        8  => August,
        9  => September,
        10 => October,
        11 => November,
        12 => December,
        _  => January,
      };

      ~Date {
        month:        month,
        day:          gmt.tm_mday as uint,
        year:         gmt.tm_year as u64 + 1900,
      }
    }
  }
}
