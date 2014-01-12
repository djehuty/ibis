#[crate_id="text-format#1.0"];

extern mod math_abs = "math-abs";

pub mod text {
  pub mod format {
    use std::str;
    use std::cast;

    pub fn integer(value: i64, base: u32) -> ~str {
      let negative = value < 0;
      let displayed = ::math_abs::math::abs::abs_i64(value);

      let mut tmp = displayed;
      let mut len = 1;

      while (tmp >= base as i64) {
        tmp /= base as i64;
        len += 1;
      }

      let mut ret = ~"";

      tmp = displayed;

      while (len > 0) {
        let off = ((tmp as u64) % (base as u64)) as u8;

        let replace =
          if off < 10 {
            (('0' as u8) + off) as char
          }
          else {
            (('a' as u8) + (off - 10)) as char
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
      let int_rep = unsafe { cast::transmute_copy::<f64, i64>(&value) };
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
          a = a.append("-");
        }

        a = a.append(integer(intPart as i64, base));

        for _ in range(0, 8) {
          fracPart *= 10;
          let foo: ~str = str::from_char((((fracPart >> 53) as u8) + '0' as u8) as char);
          b = b.append(foo);
          fracPart &= 0x1fffffffffffff;
        };

        // round last digit
        let last_char = b[b.len() - 1];
        let mut round_up = last_char >= ('5' as u8);
        let mut rounded_string = ~"";

        let mut rounded_up_index = b.len() - 1;

        while round_up {
          if (b[rounded_up_index - 1] == '9' as u8) {
            rounded_up_index -= 1;
            round_up = rounded_up_index > 0
          }
          else {
            round_up = false;
          }
        }

        // Round
        rounded_string = rounded_string.append(b.slice(0, rounded_up_index));
        rounded_string.push_char(((b.char_at(rounded_up_index) as u8) + 1) as char);

        if a.len() == 0 && b.len() == 0 {
          (~"0", ~"")
        }
        else {
          (a, b.slice(0, b.len()).to_owned())
        }
      }
    }
  }
}
