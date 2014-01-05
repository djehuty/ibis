#[crate_id="system-cpu#1.0"];

pub mod system {
  pub mod cpu {
    static ENDIAN:u32 = 0;

    pub fn fromBigEndian64(x: u64) -> u64 {
      if (ENDIAN == 0) {
         (x >> 56) |
        ((x >> 40) & 0xFF00) |
        ((x >> 24) & 0xFF0000) |
        ((x >>  8) & 0xFF000000) |
        ((x <<  8) & 0xFF00000000u64) |
        ((x << 24) & 0xFF0000000000u64) |
        ((x << 40) & 0xFF000000000000u64) |
        ((x << 56) & 0xFF00000000000000u64)
      }
      else {
        x
      }
    }

    pub fn fromBigEndian32(x: u32) -> u32 {
      if (ENDIAN == 0) {
         (x >> 24)             | ((x >>  8) & 0xFF00) |
        ((x <<  8) & 0xFF0000) | ((x << 24) & 0xFF000000)
      }
      else {
        x
      }
    }

    pub fn fromBigEndian16(x: u16) -> u16 {
      if (ENDIAN == 0) {
        (x >> 8) | (x << 8)
      }
      else {
        x
      }
    }

    pub fn toBigEndian64(x: u64) -> u64 {
      if (ENDIAN == 0) {
        fromBigEndian64(x)
      }
      else {
        x
      }
    }

    pub fn toBigEndian32(x: u32) -> u32 {
      if (ENDIAN == 0) {
        fromBigEndian32(x)
      }
      else {
        x
      }
    }

    pub fn toBigEndian16(x: u16) -> u16 {
      if (ENDIAN == 0) {
        fromBigEndian16(x)
      }
      else {
        x
      }
    }

    pub fn fromLittleEndian64(x: u64) -> u64 {
      if (ENDIAN == 1) {
         (x >> 56) |
        ((x >> 40) & 0xFF00) |
        ((x >> 24) & 0xFF0000) |
        ((x >>  8) & 0xFF000000) |
        ((x <<  8) & 0xFF00000000u64) |
        ((x << 24) & 0xFF0000000000u64) |
        ((x << 40) & 0xFF000000000000u64) |
        ((x << 56) & 0xFF00000000000000u64)
      }
      else {
        x
      }
    }

    pub fn fromLittleEndian32(x: u32) -> u32 {
      if (ENDIAN == 1) {
         (x >> 24)             | ((x >>  8) & 0xFF00) |
        ((x <<  8) & 0xFF0000) | ((x << 24) & 0xFF000000)
      }
      else {
        x
      }
    }

    pub fn fromLittleEndian16(x: u16) -> u16 {
      if (ENDIAN == 1) {
        (x >> 8) | (x << 8)
      }
      else {
        x
      }
    }

    pub fn toLittleEndian64(x: u64) -> u64 {
      if (ENDIAN == 1) {
        fromLittleEndian64(x)
      }
      else {
        x
      }
    }

    pub fn toLittleEndian32(x: u32) -> u32 {
      if (ENDIAN == 1) {
        fromLittleEndian32(x)
      }
      else {
        x
      }
    }

    pub fn toLittleEndian16(x: u16) -> u16 {
      if (ENDIAN == 1) {
        fromLittleEndian16(x)
      }
      else {
        x
      }
    }
  }
}
