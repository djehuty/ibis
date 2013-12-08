#[link(name = "hash-sha512", vers = "1.0", package_id = "hash-sha512")];

#[feature(globs)];
use std::iter;
use hash::digest::*;

mod hash {
  extern mod digest = "hash-digest";
}

static K: [u64, ..80] = [
  0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc,
  0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118,
  0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
  0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694,
  0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
  0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
  0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4,
  0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70,
  0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
  0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
  0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30,
  0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
  0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8,
  0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3,
  0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
  0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b,
  0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178,
  0x06f067aa72176fba, 0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
  0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c,
  0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817
];

pub fn hash_string(data: &str) -> Digest {
  let foo: ~[u8] = data.bytes().collect();
  hash(foo)
}

pub fn hash(data: &[u8]) -> Digest {
  let a0 = 0x6a09e667f3bcc908;
  let b0 = 0xbb67ae8584caa73b;
  let c0 = 0x3c6ef372fe94f82b;
  let d0 = 0xa54ff53a5f1d36f1;
  let e0 = 0x510e527fade682d1;
  let f0 = 0x9b05688c2b3e6c1f;
  let g0 = 0x1f83d9abfb41bd6b;
  let h0 = 0x5be0cd19137e2179;

  let mut a = a0;
  let mut b = b0;
  let mut c = c0;
  let mut d = d0;
  let mut e = e0;
  let mut f = f0;
  let mut g = g0;
  let mut h = h0;

  let mut words: [u64, ..80] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  let number_bytes = (((data.len() + 17) / 128) + 1) * 128;

  let bit_length = data.len() as u64 * 8;

  for x in iter::range_step(0, number_bytes, 128) {
    for i in iter::range_step(0, 16, 1) {
      words[i] = {
        let mut index = (i as uint) * 8 + x;
        let mut left = 8;

        let mut chunk = 0 as u64;
        while (left > 0) {
          chunk = if (index < data.len()) {
                    (chunk << 8) | data[index] as u64
                  }
                  else if (index == data.len()) {
                    (chunk << 8) | 0x80 as u64
                  }
                  else if (index < number_bytes-8) {
                    (chunk << 8) | 0x00 as u64
                  }
                  else {
                    (chunk << 8) | ((bit_length >> (number_bytes - index - 1) * 8) & 0xff) as u64
                  };
          index += 1;
          left  -= 1;
        }

        chunk
      };
    }

    for i in iter::range_step(0, 64, 1) {
      let s0 = ((words[i+1] >> 1) | (words[i+1] << 63)) ^ ((words[i+1] >> 8) | (words[i+1] << 56)) ^ ((words[i+1] >> 7));
      let s1 = ((words[i+14] >> 19) | (words[i+14] << 45)) ^ ((words[i+14] >> 61) | (words[i+14] << 3)) ^ ((words[i+14] >> 6));
      words[i+16] = words[i] + s0 + words[i+9] + s1;
    }

    for i in iter::range_step(0, 80, 1) {
      let s0  = ((a >> 28) | (a << 36)) ^ ((a >> 34) | (a << 30)) ^ ((a >> 39) | (a << 25));
      let maj = (a & b) ^ (a & c) ^ (b & c);
      let t2  = s0 + maj;
      let s1  = ((e >> 14) | (e << 50)) ^ ((e >> 18) | (e << 46)) ^ ((e >> 41) | (e << 23));
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
    }

    a += a0;
    b += b0;
    c += c0;
    d += d0;
    e += e0;
    f += f0;
    g += g0;
    h += h0;
  }

  Digest { data: ~[(a >> 32) as u32, (a & 0xffffffff) as u32,
                   (b >> 32) as u32, (b & 0xffffffff) as u32,
                   (c >> 32) as u32, (c & 0xffffffff) as u32,
                   (d >> 32) as u32, (d & 0xffffffff) as u32,
                   (e >> 32) as u32, (e & 0xffffffff) as u32,
                   (f >> 32) as u32, (f & 0xffffffff) as u32,
                   (g >> 32) as u32, (g & 0xffffffff) as u32,
                   (h >> 32) as u32, (h & 0xffffffff) as u32] }
}
