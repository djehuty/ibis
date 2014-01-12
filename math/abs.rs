#[crate_id="math-abs#1.0"];

pub mod math {
  pub mod abs {
    use std::cast;

    pub fn abs_f64(x: f64) -> f64 {
      unsafe {
        cast::transmute_copy::<u64, f64>(
          &(cast::transmute_copy::<f64, u64>(&x) & 0x7fffffffffffffff)
        )
      }
    }

    pub fn abs_f32(x: f32) -> f32 {
      unsafe {
        cast::transmute_copy::<u32, f32>(
          &(cast::transmute_copy::<f32, u32>(&x) & 0x7fffffff)
        )
      }
    }

    pub fn abs_i32(x: i32) -> i32 {
      if x < 0 {
        -x
      }
      else {
        x
      }
    }

    pub fn abs_i64(x: i64) -> i64 {
      if x < 0 {
        -x
      }
      else {
        x
      }
    }
  }
}
