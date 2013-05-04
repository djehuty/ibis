static MODULUS:u32    = 2147483647_u32;
static MULTIPLIER:u32 = 48271_u32;
static CHECK:u32      = 399268537_u32;

pub struct Random {
  state: u32
}

impl Random {
  fn mutate(&mut self) {
    static Q:u32 = MODULUS / MULTIPLIER;
    static R:u32 = MODULUS % MULTIPLIER;

    let t = MULTIPLIER * (self.state % Q) - R * (self.state / Q);
    self.state = if (t > 0) { t } else { t + MODULUS };
  }

  pub fn next_u32(&mut self) -> u32 {
    self.mutate();

    self.state
  }

  pub fn next_bounded_u32(&mut self, min:i32, max:i32) -> i32 {
    if (min >= max) {
      min
    }
    else {
      (self.next_u32() % ((max - min) as u32)) as i32 + min
    }
  }

  pub fn next_u64(&mut self) -> u64 {
    let high = self.next_u32() as u64 << 32;
    high + self.next_u32() as u64
  }

  pub fn next_bounded_u64(&mut self, min:i64, max:i64) -> i64 {
    if (min >= max) {
      min
    }
    else {
      (self.next_u64() % ((max - min) as u64)) as i64 + min
    }
  }

  pub fn next_f32(&mut self) -> f32 {
    let numerator = (self.next_u32() >> (32-24)) as f32;
    let denominator = (1 << 24) as f32;

    numerator / denominator
  }

  pub fn next_f64(&mut self) -> f64 {
    let accumulator = (self.next_u32() >> (32-26)) as u64 << 27
                    + (self.next_u32() >> (32-27)) as u64;

    let numerator = accumulator as f64;
    let denominator = (1_u64 << 53) as f64;

    numerator / denominator
  }

  pub fn next_bool(&mut self) -> bool {
    (self.next_u32() % 2) == 0
  }
}
