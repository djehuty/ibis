#[link(name = "sha224", vers = "1.0")];

use hash::digest::*;

use std::uint;

mod hash {
  extern mod digest;
}

static K: [u32, ..64] = [
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
];

pub fn hash_string(data: &str) -> Digest {
  let foo: ~[u8] = data.byte_iter().collect();
  hash(foo)
}

pub fn hash(data: &[u8]) -> Digest {
  let a0 = 0xc1059ed8;
  let b0 = 0x367cd507;
  let c0 = 0x3070dd17;
  let d0 = 0xf70e5939;
  let e0 = 0xffc00b31;
  let f0 = 0x68581511;
  let g0 = 0x64f98fa7;
  let h0 = 0xbefa4fa4;

  let mut a = a0;
  let mut b = b0;
  let mut c = c0;
  let mut d = d0;
  let mut e = e0;
  let mut f = f0;
  let mut g = g0;
  let mut h = h0;

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

    do uint::range_step(0, 48, 1) |i| {
      let s0 = ((words[i+1] >> 7) | (words[i+1] << 25)) ^ ((words[i+1] >> 18) | (words[i+1] << 14)) ^ ((words[i+1] >> 3));
      let s1 = ((words[i+14] >> 17) | (words[i+14] << 15)) ^ ((words[i+14] >> 19) | (words[i+14] << 13)) ^ ((words[i+14] >> 10));
      words[i+16] = words[i] + s0 + words[i+9] + s1;

      true
    };

    do uint::range_step(0, 64, 1) |i| {
      let s0  = ((a >> 2) | (a << 30)) ^ ((a >> 13) | (a << 19)) ^ ((a >> 22) | (a << 10));
      let maj = (a & b) ^ (a & c) ^ (b & c);
      let t2  = s0 + maj;
      let s1  = ((e >> 6) | (e << 26)) ^ ((e >> 11) | (e << 21)) ^ ((e >> 25) | (e << 7));
      let ch  = (e & f) ^ ((!e) & g);
      let t1  = h + s1 + ch + K[i] + words[i];

      h = g;
      g = f;
      f = e;
      e = d + t1;
      d = c;
      c = b;
      b = a;
      a = t1 + t2;

      true
    };

    a += a0;
    b += b0;
    c += c0;
    d += d0;
    e += e0;
    f += f0;
    g += g0;
    h += h0;

    true
  };

  Digest { data: ~[a, b, c, d, e, f, g] }
}
