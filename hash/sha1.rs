#[link(name = "sha1", vers = "1.0")];

use hash::digest::*;

use std::uint;

mod hash {
  extern mod digest;
}

pub fn hash_string(data: &str) -> Digest {
  let foo: ~[u8] = data.byte_iter().collect();
  hash(foo)
}

pub fn hash(data: &[u8]) -> Digest {
  let a0 = 0x67452301;
  let b0 = 0xEFCDAB89;
  let c0 = 0x98BADCFE;
  let d0 = 0x10325476;
  let e0 = 0xC3D2E1F0;

  let mut a = a0;
  let mut b = b0;
  let mut c = c0;
  let mut d = d0;
  let mut e = e0;

  let mut words: [u32, ..80] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  let number_bytes = (((data.len() + 9) / 64) + 1) * 64;

  let bit_length = data.len() as u64 * 8;

  do uint::range_step(0, number_bytes, 64) |x| {
    do uint::range_step(0, 16, 1) |i| {
      words[i] = {
        let mut index = i*4 + x;
        let mut left = 4;

        let mut chunk = 0 as u32;
        while (left > 0) {
          chunk = if (index < data.len()) {
                    (chunk << 8) | data[index] as u32
                  }
                  else if (index == data.len()) {
                    (chunk << 8) | 0x80 as u32
                  }
                  else if (index < number_bytes-8) {
                    (chunk << 8) | 0x00 as u32
                  }
                  else {
                    (chunk << 8) | ((bit_length >> (number_bytes - index - 1) * 8) & 0xff) as u32
                  };
          index += 1;
          left  -= 1;
        }

        chunk
      };

      true
    };

    do uint::range_step(0, 64, 1) |i| {
      words[i+16] = (words[i+13] ^ words[i+8] ^ words[i+2] ^ words[i]);
      words[i+16] = (words[i+16] << 1) | (words[i+16] >> 31);
      true
    };

    do uint::range_step(0, 80, 1) |i| {
      let k = if      (i < 20) { 0x5A827999 }
              else if (i < 40) { 0x6ed9eba1 }
              else if (i < 60) { 0x8f1bbcdc }
              else             { 0xca62c1d6 };

      let f = if      (i < 20)            { (b & c) | (!b & d) }
              else if (i < 40 || i >= 60) { (b ^ c ^ d) }
              else                        { (b & c) | (b & d) | (c & d) };

      let temp = ((a << 5) | (a >> 27)) + f + e + k + words[i];

      e = d;
      d = c;
      c = (b << 30) | (b >> 2);
      b = a;
      a = temp;

      true
    };

    a += a0;
    b += b0;
    c += c0;
    d += d0;
    e += e0;

    true
  };

  Digest { data: ~[a, b, c, d, e] }
}
