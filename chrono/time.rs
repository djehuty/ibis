#[link(name = "time", vers = "1.0")];

pub struct Time {
  microseconds: u64,
}

impl Time {
  pub fn new(hour: u64, minute: u8, second: u8, microsecond: u32) -> Time {
    let mut micros = hour;
    micros *= 60;
    micros += minute as u64;
    micros *= 60;
    micros += second as u64;
    micros *= 1000000;
    micros += microsecond as u64;

    Time { microseconds: micros }
  }

  pub fn hour(&self) -> u64 {
    self.microseconds / 1000000 / 60 / 60
  }

  pub fn minute(&self) -> u64 {
    self.microseconds / 1000000 / 60 % 60
  }

  pub fn second(&self) -> u64 {
    self.microseconds / 1000000 % 60
  }

  pub fn millisecond(&self) -> u64 {
    self.microseconds / 1000 % 1000
  }

  pub fn microsecond(&self) -> u64 {
    self.microseconds % 1000000
  }

  pub fn hours(&self) -> u64 {
    self.microseconds / 1000000 / 60 / 60
  }

  pub fn minutes(&self) -> u64 {
    self.microseconds / 1000000 / 60
  }

  pub fn seconds(&self) -> u64 {
    self.microseconds / 1000000
  }

  pub fn milliseconds(&self) -> u64 {
    self.microseconds / 1000
  }

  pub fn add(&self, b: Time) -> Time {
    Time { microseconds: self.microseconds + b.microseconds }
  }

  pub fn subtract(&self, b: Time) -> Time {
    Time { microseconds: self.microseconds - b.microseconds }
  }

  pub fn compare(&self, b: Time) -> int {
    (self.microseconds - b.microseconds) as int
  }

  pub fn equals(&self, b: Time) -> bool {
    self.microseconds == b.microseconds
  }
}
