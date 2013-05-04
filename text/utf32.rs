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

pub fn isLegalChar(c: &[u32]) -> bool {
  false
}

pub fn isLegal(s: &[u32]) -> bool {
  false
}

pub fn utf8Length(s: &[u32]) -> u64 {
  0
}

pub fn utf32Length(s: &[u32]) -> u64 {
  0
}

pub fn toUtf8(s: &[u32], r: &[u8]) {
}

pub fn toUtf16(s: &[u32], r: &[u16]) {
}
