mod text {
  extern mod unicode;
}

static UNI_SUR_HIGH_START:   u32 = 0xD800;
static UNI_SUR_HIGH_END:     u32 = 0xDBFF;
static UNI_SUR_LOW_START:    u32 = 0xDC00;
static UNI_SUR_LOW_END:      u32 = 0xDFFF;

static UNI_REPLACEMENT_CHAR: u32 = 0x0000FFFD;

static UNI_MAX_BMP:          u32 = 0x0000FFFF;
static UNI_MAX_UTF16:        u32 = 0x0010FFFF;
static UNI_MAX_UTF32:        u32 = 0x7FFFFFFF;
static UNI_MAX_LEGAL_UTF32:  u32 = 0x0010FFFF;

/*
 * Magic values subtracted from a buffer value during UTF8 conversion.
 * This table contains as many values as there might be trailing bytes
 * in a UTF-8 sequence.
 */
static OFFSETS_FROM_UTF8: [u32, ..6] = [0x00000000, 0x00003080, 0x000E2080,
                                        0x03C82080, 0xFA082080, 0x82082080];


/*
 * Index into the table below with the first byte of a UTF-8 sequence to
 * get the number of trailing bytes that are supposed to follow it.
 * Note that *legal* UTF-8 values can't have 4 or 5-bytes. The table is
 * left as-is for anyone who may want to do such conversion, which was
 * allowed in earlier algorithms.
 */
static TRAILING_BYTES: [uint, ..256] = [
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
  2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
];

pub fn isLegalChar(c: &[u8]) -> bool {
  if (c.len() > 4 || c.len() == 0) {
    return false;
  }

  if (c.len() > 3 && (c[3] < 0x80 || c[3] > 0xbf)) {
    return false;
  }

  if (c.len() > 2 && (c[2] < 0x80 || c[2] > 0xbf)) {
    return false;
  }

  if (c.len() > 1) {
    if (c[1] > 0xbf) {
      return false;
    }

    match c[0] {
      0xe0 => if (c[1] < 0xa0) { return false },
      0xed => if (c[1] < 0x9f) { return false },
      0xf0 => if (c[1] < 0x90) { return false },
      0xf4 => if (c[1] < 0x8f) { return false },
         _ => if (c[1] < 0x80) { return false }
    }
  }

  if (c[0] > 0x80 && c[0] < 0xc2) {
    return false;
  }

  true
}

pub fn isLegal(s: &[u8]) -> bool {
  let mut i = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];
    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      return false;
    }
    i = end;
  }

  true
}

pub fn utf16Length(s: &[u8]) -> u64 {
  let mut i = 0;
  let mut l = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];

    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      break;
    }

    let mut ch:u32 = 0;
    for s.slice(i, end).each |b| {
      ch <<= 6;
      ch += *b as u32;
    }
    ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[i]]];

    if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
      // Illegal
      break;
    }
    else if ch <= UNI_MAX_BMP {
      l = l + 1;
    }
    else if ch > UNI_MAX_UTF16 {
      // Illegal
      break;
    }
    else {
      l = l + 2;
    }

    i = end;
  }

  l
}

pub fn utf32Length(s: &[u8]) -> u64 {
  let mut i = 0;
  let mut l = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];

    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      break;
    }

    let mut ch:u32 = 0;
    for s.slice(i, end).each |b| {
      ch <<= 6;
      ch += *b as u32;
    }
    ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[i]]];

    if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
      // Illegal
      break;
    }
    else if ch <= UNI_MAX_LEGAL_UTF32 {
      l = l + 1;
    }
    else {
      // Illegal
      break;
    }

    i = end;
  }

  l
}

pub fn toUtf16(s: &[u8], r: &mut[u16]) {
  let mut i = 0;
  let mut l = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];

    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      break;
    }

    let mut ch:u32 = 0;
    for s.slice(i, end).each |b| {
      ch <<= 6;
      ch += *b as u32;
    }
    ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[i]]];

    if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
      // Illegal
      break;
    }
    else if ch <= UNI_MAX_BMP {
      r[l] = ch as u16;
      l = l + 1;
    }
    else if ch > UNI_MAX_UTF16 {
      // Illegal
      break;
    }
    else {
      r[l] = ch as u16;
      l = l + 1;
      r[l] = ((ch >> 10) & 0x3ff) as u16;
      l = l + 1;
    }

    i = end;
  }
}

pub fn toUtf32(s: &[u8], r: &mut[u32]) {
  let mut i = 0;
  let mut l = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];

    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      break;
    }

    let mut ch:u32 = 0;
    for s.slice(i, end).each |b| {
      ch <<= 6;
      ch += *b as u32;
    }
    ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[i]]];

    if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
      // Illegal
      break;
    }
    else if ch <= UNI_MAX_LEGAL_UTF32 {
      r[l] = ch;
      l = l + 1;
    }
    else {
      // Illegal
      break;
    }

    i = end;
  }
}

pub fn length(s: &[u8]) -> u64 {
  let mut i = 0;
  let mut len = 0;
  while i < s.len() {
    let end = i + 1 + TRAILING_BYTES[s[i]];

    if (end > s.len() || isLegalChar(s.slice(i,end)) == false) {
      break;
    }

    let mut ch:u32 = 0;
    for s.slice(i, end).each |b| {
      ch <<= 6;
      ch += *b as u32;
    }
    ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[i]]];

    if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
      // Illegal
      break;
    }
    else if ch <= UNI_MAX_LEGAL_UTF32 {
      if !text::unicode::isCombiningMark(ch) {
        len += 1;
      }
    }
    else {
      // Illegal
      break;
    }

    i = end;
  }

  len
}

pub fn firstUtf32Char(s: &[u8]) -> u32 {
  let end = 1 + TRAILING_BYTES[s[0]];

  if (end > s.len() || isLegalChar(s.slice(0,end)) == false) {
    // Illegal
    return 0;
  }

  let mut ch:u32 = 0;
  for s.slice(0, end).each |b| {
    ch += *b as u32;
    ch <<= 6;
  }
  ch -= OFFSETS_FROM_UTF8[TRAILING_BYTES[s[0]]];

  if ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END {
    // Illegal
    return 0;
  }
  else if ch > UNI_MAX_LEGAL_UTF32 {
    // Illegal
    return 0;
  }

  ch
}
