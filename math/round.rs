#[link(name = "math-round", vers = "1.0", package_id = "math-round")];

use std::cast;

static huge:f64 = 1.0e300;

pub fn nearest(x: f64) -> f64 {
  floor(x + 0.5)
}

pub fn floor(x: f64) -> f64 {
  let int_rep = unsafe { cast::transmute_copy::<f64, u64>(&x) };

  // TODO: endianness?
  let mut i0 = int_rep as i32;
  let mut i1 = (int_rep >> 32) as i32;

  let j0 = ((i0 >> 20) & 0x7ff) - 0x3ff;

  if (j0 < 20) {
    if (j0 < 0) {
      // Raise inexact if x ! = 0
      if (huge + x > 0.0) {
        // Return 0 * sign(x) if | x | < 1
        if (i0 >= 0) {
          i0 = 0;
          i1 = 0;
        }
        else if (((i0 & 0x7fffffff) | i1) != 0) {
          i0 = 0xbff00000 as i32;
          i1 = 0;
        }
      }
    }
    else {
      let i = 0x000fffff >> j0;

      if (((i0 & i) | i1) == 0) {
        // x is integral
        return x;
      }

      if (huge + x > 0.0) {
        // Raise inexact flag
        if (i0 < 0) {
          i0 += (0x00100000) >> j0;
        }

        i0 &= !i;
        i1 = 0;
      }
    }
  }
  else if (j0 > 51) {
    if (j0 == 0x400) {
      // Inf or NaN
      return x + x;
    }
    else {
      // x is integral
      return x;
    }
  }
  else {
    let i = 0xffffffffu32 >> (j0 - 20);

    if ((i1 as u32 & i) == 0) {
      return x; // x is integral
    }

    if (huge + x > 0.0) {
      // Raise inexact flag
      if (i0 < 0) {
        if (j0 == 20) {
          i0 += 1;
        }
        else {
          let j = i1 + (1 << (52 - j0));

          if (j < i1) {
            // Got a carry
            i0 += 1;
          }

          i1 = j;
        }
      }

      i1 = (i1 as u32 & !i) as i32;
    }
  }

  // TODO: endianness
  let new_int_rep = (i0 as u64 << 32) | (i1 as u64);

  unsafe { cast::transmute_copy::<u64, f64>(&new_int_rep) }
}

pub fn ceiling(x: f64) -> f64 {
  let int_rep = unsafe { cast::transmute_copy::<f64, u64>(&x) };

  // TODO: endianness?
  let mut i0 = int_rep as i32;
  let mut i1 = (int_rep >> 32) as i32;

  let j0 = ((i0 >> 20) & 0x7ff) - 0x3ff;
  if (j0 < 20) {
    if (j0 < 0) {
      // Raise inexact if x != 0
      if (huge + x > 0.0) {
        // Return 0 * sign(x) if |x| < 1
        if (i0 < 0) {
          i0 = 0x80000000 as i32;
          i1 = 0;
        }
        else if ((i0 | i1) != 0) {
          i0 = 0x3ff00000;
          i1 = 0;
        }
      }
    }
    else {
      let i = 0x000fffff >> j0;

      if (((i0 & i) | i1) == 0) {
        // x is integral
        return x;
      }

      if (huge + x > 0.0) {
        // Raise inexact flag
        if (i0 > 0) {
          i0 += (0x00100000) >> j0;
        }

        i0 &= !i;
        i1 = 0;
      }
    }
  }
  else if (j0 > 51) {
    if (j0 == 0x400) {
      // Inf or NaN
      return x + x;
    }
    else {
      // x is integral
      return x;
    }
  }
  else {
    let i = 0xffffffffu32 >> (j0 - 20);

    if ((i1 as u32 & i) == 0) {
      // x is integral
      return x;
    }

    if (huge + x > 0.0) {
      // Raise inexact flag

      if (i0 > 0) {
        if (j0 == 20) {
          i0 += 1;
        }
        else {
          let j = i1 + (1 << (52 - j0));

          if (j < i1) {
            // Got a carry
            i0 += 1;
          }

          i1 = j;
        }
      }

      i1 = (i1 as u32 & !i) as i32;
    }
  }

  // TODO: endianness
  let new_int_rep = (i0 as u64 << 32) | (i1 as u64);

  unsafe { cast::transmute_copy::<u64, f64>(&new_int_rep) }
}
