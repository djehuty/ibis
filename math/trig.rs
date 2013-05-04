mod math {
  extern mod abs;
}

fn rempio2(x: f64, y: &mut [f64]) -> u32 {
  static PIO2_1:f64 =  1.57079632673412561417e+00; /* 0x3FF921FB, 0x54400000 */
  static PIO2_1T:f64 = 6.07710050650619224932e-11; /* 0x3DD0B461, 0x1A626331 */
  static PIO2_2:f64  = 6.07710050630396597660e-11; /* 0x3DD0B461, 0x1A600000 */
  static PIO2_2T:f64 = 2.02226624879595063154e-21; /* 0x3BA3198A, 0x2E037073 */
  static PIO2_3:f64  = 2.02226624871116645580e-21; /* 0x3BA3198A, 0x2E000000 */
  static PIO2_3T:f64 = 8.47842766036889956997e-32; /* 0x397B839A, 0x252049C1 */
  static HALF:f64    = 0.5;
  static ZERO:f64    = 0.0;

  static TWO24:f64   = 1.67772160000000000000e+07; /* 0x41700000, 0x00000000 */
  static INVPIO2:f64 = 6.36619772367581382433e-01; /* 0x3FE45F30, 0x6DC9C883 */

  static TWO_OVER_PI:[u32, ..66] = [
    0xA2F983, 0x6E4E44, 0x1529FC, 0x2757D1, 0xF534DD, 0xC0DB62,
    0x95993C, 0x439041, 0xFE5163, 0xABDEBB, 0xC561B7, 0x246E3A,
    0x424DD2, 0xE00649, 0x2EEA09, 0xD1921C, 0xFE1DEB, 0x1CB129,
    0xA73EE8, 0x8235F5, 0x2EBB44, 0x84E99C, 0x7026B4, 0x5F7E41,
    0x3991D6, 0x398353, 0x39F49C, 0x845F8B, 0xBDF928, 0x3B1FF8,
    0x97FFDE, 0x05980F, 0xEF2F11, 0x8B5A0A, 0x6D1F6D, 0x367ECF,
    0x27CB09, 0xB74F46, 0x3F669E, 0x5FEA2D, 0x7527BA, 0xC7EBE5,
    0xF17B3D, 0x0739F7, 0x8A5292, 0xEA6BFB, 0x5FB11F, 0x8D5D08,
    0x560330, 0x46FC7B, 0x6BABF0, 0xCFBC20, 0x9AF436, 0x1DA9E3,
    0x91615E, 0xE61B08, 0x659985, 0x5F14A0, 0x68408D, 0xFFD880,
    0x4D7327, 0x310606, 0x1556CA, 0x73A8C9, 0x60E27B, 0xC08C6B
  ];

  static NPIO2_HW:[u32, ..32] = [
    0x3FF921FB, 0x400921FB, 0x4012D97C, 0x401921FB, 0x401F6A7A, 0x4022D97C,
    0x4025FDBB, 0x402921FB, 0x402C463A, 0x402F6A7A, 0x4031475C, 0x4032D97C,
    0x40346B9C, 0x4035FDBB, 0x40378FDB, 0x403921FB, 0x403AB41B, 0x403C463A,
    0x403DD85A, 0x403F6A7A, 0x40407E4C, 0x4041475C, 0x4042106C, 0x4042D97C,
    0x4043A28C, 0x40446B9C, 0x404534AC, 0x4045FDBB, 0x4046C6CB, 0x40478FDB,
    0x404858EB, 0x404921FB
  ];

  let int_rep = unsafe { cast::reinterpret_cast::<f64, u64>(&x) };
  let highx = int_rep >> 32;

  let ix = (highx & 0x7fffffff) as u32;

  if (ix <= 0x3fe921fb) { // |x| <= pi/4, no need to reduce
    y[0] = x;
    y[1] = 0_f64;

    return 0;
  }

  if (ix < 0x4002d97c) {
    if (highx > 0) {
      if (ix != 0x3ff921fb) {
        let z = x - PIO2_1;
        y[0] = z - PIO2_1T;
        y[1] = (z - y[0]) - PIO2_1T;
      }
      else {
        let z = x - PIO2_1 - PIO2_2;
        y[0] = z - PIO2_2T;
        y[1] = (z - y[0]) - PIO2_2T;
      }

      return 1;
    }
    else { // negative x
      if (ix != 0x3ff921fb) {
        let z = x + PIO2_1;
        y[0] = z + PIO2_1T;
        y[1] = (z - y[0]) + PIO2_1T;
      }
      else {
        let z = x + PIO2_1 + PIO2_2;
        y[0] = z + PIO2_2T;
        y[1] = (z - y[0]) + PIO2_2T;
      }

      return -1;
    }
  }

  if (ix <= 0x413921fb) { // |x| <= 2^19 * (pi/2)
    let mut t = math::abs::abs_f64(x);
    let n = ((t * INVPIO2) + HALF) as u32;
    let f = n as f64;

    let mut r = t - (f * PIO2_1);
    let mut w = f * PIO2_1T;

    if (n < 32 && ix != NPIO2_HW[n-1]) {
      y[0] = r - w;
    }
    else {
      let j = ix >> 20;

      y[0] = r - w;

      let high = unsafe { cast::reinterpret_cast::<f64, u64>(&y[0]) } >> 32;
      let i2 = j - ((high >> 20) & 0x7ff) as u32;

      if (i2 > 16) { // Need a 2nd iteration
        t = r;
        w = f * PIO2_2;
        r = t - w;
        w = (f * PIO2_2T) - ((t - r) - w);
        y[0] = r - w;

        let high = unsafe { cast::reinterpret_cast::<f64, u64>(&y[0]) } >> 32;

        let i3 = j - ((high >> 20) & 0x7ff) as u32;
        if (i3 > 49) { // 3rd iteration (151 bits accurate)
          t = r;
          w = f * PIO2_3;
          r = t - w;
          w = (f * PIO2_3T) - ((t - r) - w);

          y[0] = r - w;
        }
      }
    }

    y[1] = (r - y[0]) - w;

    if (highx < 0) {
      y[0] = -y[0];
      y[1] = -y[1];
      return -n;
    }

    return n;
  }

  return 0;
}

fn _cos(x: f64, y: f64) -> f64 {
  let int_rep = unsafe { cast::reinterpret_cast::<f64, u64>(&x) };
  let highx = int_rep >> 32;

  let ix = (highx & 0x7fffffff) as u32;

  if (ix < 0x3e400000) {
    if (int_rep == 0) {
      return 1.0;
    }
  }

  let z = x*x;

  let mut r = -1.13596475577881948265e-11;
  r *= z;
  r += 2.08757232129817482790e-09;
  r *= z;
  r += -2.75573143513906633035e-07;
  r *= z;
  r += 2.48015872894767294178e-05;
  r *= z;
  r += -1.38888888888741095749e-03;
  r *= z;
  r += 4.16666666666666019037e-02;
  r *= z;

  if (ix < 0x3fd33333) { // if |x| < 0.3
    return 1.0 - ((0.5 * z) - ((z * r) - (x * y)));
  }

  let qx =
    if (ix > 0x3fe90000) { // x > 0.78125
      0.28125
    }
    else {
      let qx_part = (ix as u64) << 32;

      unsafe { cast::reinterpret_cast::<u64, f64>(&qx_part) }
    };

  let hz = (0.5*z) - qx;
  let a = 1.0 - qx;

  a - (hz - ((z*r) - (x*y)))
}

fn _sin(x: f64, y: f64, iy: bool) -> f64 {
  let int_rep = unsafe { cast::reinterpret_cast::<f64, u64>(&x) };
  let highx = int_rep >> 32;

  let ix = (highx & 0x7fffffff) as u32;

  if (ix < 0x3e400000) {	// |x| < 2^(-27)
    if ((x as u32) == 0) {
      return x;
    }
  }

  let z = x * x;
  let v = z * x;
  let mut r = 1.58969099521155010221e-10;
  r *= z;
  r += -2.50507602534068634195e-08;
  r *= z;
  r += 2.75573137070700676789e-06;
  r *= z;
  r += -1.98412698298579493134e-04;
  r *= z;
  r += 8.33333333332248946124e-03;

  if (iy) {
    x - (((z * ((0.5 * y) - (v * r))) - y) - (v * -1.66666666666666324348e-01))
  }
  else {
    x + (v * (-1.66666666666666324348e-01 + (z * r)))
  }
}

pub fn cos(x: f64) -> f64 {
  // Get the high 32 bits of the input
  let int_rep = unsafe { cast::reinterpret_cast::<f64, u64>(&x) };
  let highx = int_rep >> 32;

  let ix = (highx & 0x7fffffff) as u32;

  // Take the absolute value of x
  // Note: cos(-x) == cos(x)
  if (ix <= 0x3fe921fb) {
    _cos(x, 0.0)
  }
  // cos(double.inf) or cos(double.nan) == nan
  else if (ix >= 0x7ff00000) {
    x - x // preserve sign
  }
  // Different routine depending on quadrant
  else {
    let mut y = ~[0.0, 0.0];

    match(rempio2(x, y) & 0x3) {
      0 =>  _cos(y[0], y[1]),
      1 => -_sin(y[0], y[1], true),
      2 => -_cos(y[0], y[1]),
      _ =>  _sin(y[0], y[1], true)
    }
  }
}

pub fn sin(x: f64) -> f64 {
  // Get the high 32 bits of the input
  let int_rep = unsafe { cast::reinterpret_cast::<f64, u64>(&x) };
  let highx = int_rep >> 32;

  let ix = (highx & 0x7fffffff) as u32;

  // Take the absolute value of x
  // Note: cos(-x) == cos(x)
  if (ix <= 0x3fe921fb) {
    _sin(x, 0.0, false)
  }
  // sin(double.inf) or sin(double.nan) == nan
  else if (ix >= 0x7ff00000) {
    x - x // preserve sign
  }
  else {
    // Different routine depending on quadrant
    let mut y = ~[0.0, 0.0];

    match (rempio2(x, y) & 0x3) {
      0 =>  _sin(y[0], y[1], true),
      1 =>  _cos(y[0], y[1]),
      2 => -_sin(y[0], y[1], true),
      _ => -_cos(y[0], y[1])
    }
  }
}
