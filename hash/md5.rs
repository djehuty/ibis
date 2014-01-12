#[crate_id="hash-md5#1.0"];
#[feature(globs)];

extern mod hash_digest = "hash-digest";

pub mod hash {
  pub mod md5 {
    use std::iter;
    use hash_digest::hash::digest::*;

    static R: [u32, ..64] = [ 7, 12, 17, 22, 7, 12, 17, 22,
                              7, 12, 17, 22, 7, 12, 17, 22,
                              5,  9, 14, 20, 5,  9, 14, 20,
                              5,  9, 14, 20, 5,  9, 14, 20,
                              4, 11, 16, 23, 4, 11, 16, 23,
                              4, 11, 16, 23, 4, 11, 16, 23,
                              6, 10, 15, 21, 6, 10, 15, 21,
                              6, 10, 15, 21, 6, 10, 15, 21];

    static K: [u32, ..64] = [ 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
                              0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
                              0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
                              0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                              0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
                              0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
                              0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
                              0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                              0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
                              0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                              0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
                              0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                              0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
                              0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                              0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
                              0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391];

    static G: [uint, ..64] = [  0,  1,  2,  3,  4,  5,  6,  7,
                                8,  9, 10, 11, 12, 13, 14, 15,
                                1,  6, 11,  0,  5, 10, 15,  4,
                                9, 14,  3,  8, 13,  2,  7, 12,
                                5,  8, 11, 14,  1,  4,  7, 10,
                               13,  0,  3,  6,  9, 12, 15,  2,
                                0,  7, 14,  5, 12,  3, 10,  1,
                                8, 15,  6, 13,  4, 11,  2,  9];

    // TODO: Need an iterator version for the hashing!
    pub fn hash_string(data: &str) -> Digest {
      let foo: ~[u8] = data.bytes().collect();
      hash(foo)
    }

    pub fn hash(data: &[u8]) -> Digest {
      let a0 = 0x67452301;
      let b0 = 0xefcdab89;
      let c0 = 0x98badcfe;
      let d0 = 0x10325476;

      let mut a = a0;
      let mut b = b0;
      let mut c = c0;
      let mut d = d0;

      let number_bytes = (((data.len() + 9) / 64) + 1) * 64;

      let bit_length = data.len() as u64 * 8;

      for x in iter::range_step(0, number_bytes, 64) {
        for i in iter::range_step(0, 64, 1) {
          if (i < 16) {
            a += (b & c) | (!b & d);
          }
          else if (i < 32) {
            a += (b & d) | (!d & c);
          }
          else if (i < 48) {
            a += (b ^ c ^ d);
          }
          else {
            a += c ^ (!d | b);
          }

          let chunk = {
            let mut index = G[i] * 4 + x;
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
                        (chunk << 8) | ((bit_length >> (7 - number_bytes + index + 1) * 8) & 0xff) as u32
                      };
              index += 1;
              left  -= 1;
            }

            ((chunk & 0xff) << 24) | ((chunk & 0xff00) << 8) | ((chunk & 0xff0000) >> 8) | ((chunk & 0xff000000) >> 24)
          };

          a += chunk + K[i];
          a  = (a << R[i]) | (a >> 32 - R[i]);
          a += b;

          let tmp = d;
          d = c;
          c = b;
          b = a;
          a = tmp;
        }

        a += a0;
        b += b0;
        c += c0;
        d += d0;
      }

      a = ((a & 0xff) << 24) | ((a & 0xff00) << 8) | ((a & 0xff0000) >> 8) | ((a & 0xff000000) >> 24);
      b = ((b & 0xff) << 24) | ((b & 0xff00) << 8) | ((b & 0xff0000) >> 8) | ((b & 0xff000000) >> 24);
      c = ((c & 0xff) << 24) | ((c & 0xff00) << 8) | ((c & 0xff0000) >> 8) | ((c & 0xff000000) >> 24);
      d = ((d & 0xff) << 24) | ((d & 0xff00) << 8) | ((d & 0xff0000) >> 8) | ((d & 0xff000000) >> 24);

      Digest { data: ~[a, b, c, d] }
    }
  }
}
