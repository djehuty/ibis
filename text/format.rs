mod math {
  extern mod abs;
}

pub fn integer(value: i64, base: u32) -> ~str {
  let negative = value < 0;
  let displayed = math::abs::abs_i64(value);

  let mut tmp = displayed;
  let mut len = 1;

  while (tmp >= base as i64) {
    tmp /= base as i64;
    len += 1;
  }

  let mut ret = ~"";

  tmp = displayed;

  while (len > 0) {
    let off = ((tmp as u64) % (base as u64)) as u32;

    let replace =
      if off < 10 {
        (('0' as u32) + off) as char
      }
      else {
        (('a' as u32) + (off - 10)) as char
      };

    ret = str::from_char(replace) + ret;

    tmp /= base as i64;
    len -= 1;
  }

  if (negative) {
    ret = str::from_char('-') + ret;
  }

  ret
}

pub fn floatingPoint(value: f64, base: u32, point: ~str) -> ~str {
  let components = floatingPointComponents(value, base);

  match components {
    (a, ~"") => a,
    (a, b) => a + point + b
  }
}

pub fn floatingPointComponents(value: f64, base: u32) -> (~str, ~str) {
  let int_rep = unsafe { cast::reinterpret_cast::<f64, i64>(&value) };
  let exp = ((int_rep >> 52) & 0x7ff);
  let unbiased_exp = (exp as i64) - 1023;

  if (value == -1.0_f64/0.0_f64) {
    (~"-inf", ~"")
  }
  else if (value == 1.0_f64/0.0_f64) {
    (~"inf", ~"")
  }
  else if (exp == 0x7ff) {
    (~"nan", ~"")
  }
  else if (value == 0.0 || exp == 0 || unbiased_exp < -52) {
    (~"0", ~"")
  }
  else {
    let mantissa = (int_rep & 0xfffffffffffff) | 0x10000000000000;

    let intPart =
      if (unbiased_exp >= 52) {
        mantissa << (unbiased_exp - 52)
      }
      else if (unbiased_exp >= 0) {
        mantissa >> (52 - unbiased_exp)
      }
      else {
        0
      };

    let mut fracPart =
      if (unbiased_exp >= 52) {
        0
      }
      else if (unbiased_exp >= 0) {
        (mantissa << (unbiased_exp + 1)) & 0x1fffffffffffff
      }
      else { // exp < 0
        (mantissa & 0x1fffffffffffff) >> (-(unbiased_exp + 1))
      };

    let mut a = ~"";
    let mut b = ~"";

    if ((int_rep as i64) < 0_i64) {
      a = ~"-";
    }

    a += integer(intPart as i64, base);

    for uint::range(0, 8) |_| {
      fracPart *= 10;
      b += str::from_char((((fracPart >> 53) as u16) + '0' as u16) as char);
      fracPart &= 0x1fffffffffffff;
    }

    // round last digit
    let last_char = b[b.len() - 1];
    let mut round_up = last_char >= ('5' as u8);
    let mut blen = b.len() - 1;

    while round_up {
      if (b[blen - 1] == '9' as u8) {
        b[blen - 1] = 0;
        blen -= 1;
        round_up = blen > 0
      }
      else {
        b[blen - 1] += 1;
        round_up = false;
      }
    }

    // get rid of useless zeroes (and point if necessary)
    for uint::range_step(blen - 1, 0, -1) |i| {
      if b[i] == '0' as u8 {
        b[i] = 0;
        blen -= 1;
      }
      else {
        break;
      }
    }

    b = { str::from_bytes(str::to_bytes(b.slice(0, blen))) };

    if a.len() == 0 && blen == 0 {
      (~"0", ~"")
    }
    else {
      (a, b)
    }
  }
}
