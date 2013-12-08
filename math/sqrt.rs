#[link(name = "math-sqrt", vers = "1.0", package_id = "math-sqrt")];

use std::cast;

pub fn sqrt_f64(x: f64) -> f64 {
  if x == 0.0 {
    0.0
  }
  else {
    // Use an estimate for 1 / sqrt(x)
    let int_rep = unsafe { cast::transmute_copy::<f64, u64>(&x) };
    let high = int_rep >> 32;
    let frak = ((0xbfcdd90a - high) >> 1) as u64 << 32;
    let result = frak | (int_rep & 0xffffffff);
    let mut y = unsafe { cast::transmute_copy::<u64, f64>(&result) };

    // Newton Approximation
    let z = x * 0.5; // 1/2

    // 5 iterations are enough for 64 bits
    y = (1.5 * y) - (y*y) * (y*z);
    y = (1.5 * y) - (y*y) * (y*z);
    y = (1.5 * y) - (y*y) * (y*z);
    y = (1.5 * y) - (y*y) * (y*z);
    y = (1.5 * y) - (y*y) * (y*z);

    x * y
  }
}
