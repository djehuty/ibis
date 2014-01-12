#[crate_id="text-unicode#1.0"];

static COMBINING_MARKS: [[u32, ..2], ..168] = [
  // Combining Diacritical Marks
  [0x300, 0x36f],

  // Hebrew
  [0x591, 0x5bd], [0x5c1, 0x5c1], [0x5c2, 0x5c2], [0x5c4, 0x5c5],
  [0x5c7, 0x5c7],

  // Arabic
  [0x610, 0x61a], [0x64b, 0x65e], [0x670, 0x670], [0x6d6, 0x6dc],
  [0x6df, 0x6e4], [0x6e7, 0x6e8], [0x6ea, 0x6ed],

  // Syriac
  [0x711, 0x711], [0x730, 0x74a],

  //Thanna
  [0x7a6, 0x7b0],

  //NKO
  [0x7eb, 0x7f3],

  // Devanagari
  [0x901, 0x902], [0x93c, 0x93c], [0x941, 0x948], [0x94d, 0x94d],
  [0x951, 0x954], [0x962, 0x963],

  // Bengali
  [0x981, 0x981], [0x9bc, 0x9bc], [0x9c1, 0x9c4], [0x9cd, 0x9cd],
  [0x9e2, 0x9e3],

  // Gurmukhi
  [0xa01, 0xa02], [0xa3c, 0xa3c], [0xa41, 0xa42], [0xa47, 0xa48],
  [0xa4b, 0xa4d], [0xa51, 0xa51], [0xa70, 0xa71], [0xa75, 0xa75],
  [0xa81, 0xa82], [0xabc, 0xabc], [0xac1, 0xac5],

  // Oriya
  [0xb01, 0xb01], [0xb3c, 0xb3c], [0xb3f, 0xb3f], [0xb41, 0xb44],
  [0xb4d, 0xb4d], [0xb56, 0xb56], [0xb62, 0xb63],

  // Tamil
  [0xb82, 0xb82], [0xbc0, 0xbc0], [0xbcd, 0xbcd],

  // Telugu
  [0xc3e, 0xc3e], [0xc3f, 0xc3f], [0xc40, 0xc40], [0xc46, 0xc48],
  [0xc4a, 0xc4d], [0xc55, 0xc55], [0xc56, 0xc56], [0xc62, 0xc62],
  [0xc63, 0xc63],

  // Kannada
  [0xcbc, 0xcbc], [0xcbf, 0xcbf], [0xcc6, 0xcc6], [0xccc, 0xccc],
  [0xccd, 0xccd], [0xce2, 0xce2], [0xce3, 0xce3],

  // Malayalam
  [0xd41, 0xd44], [0xd4d, 0xd4d], [0xd62, 0xd62], [0xd63, 0xd63],

  // Sinhala
  [0xdca, 0xdca], [0xdd2, 0xdd4], [0xdd6, 0xdd6],

  // Thai
  [0xe31, 0xe31], [0xe34, 0xe3a], [0xe47, 0xe4e],

  // Lao
  [0xeb1, 0xeb1], [0xeb4, 0xeb9], [0xebb, 0xebb], [0xebc, 0xebc],
  [0xec8, 0xecd],

  // Tibetan
  [0xf18, 0xf18], [0xf19, 0xf19], [0xf35, 0xf35], [0xf37, 0xf37],
  [0xf39, 0xf39], [0xf71, 0xf7e], [0xf80, 0xf84], [0xf86, 0xf86],
  [0xf87, 0xf87], [0xf90, 0xfbc], [0xfc6, 0xfc6],

  // Myanmar
  [0x102d, 0x1030], [0x1032, 0x1037], [0x1039, 0x1039], [0x103a, 0x103a],
  [0x103d, 0x103d], [0x103e, 0x103e], [0x1058, 0x1058], [0x1059, 0x1059],
  [0x105e, 0x1060], [0x1071, 0x1074], [0x1082, 0x1082], [0x1085, 0x1085],
  [0x1086, 0x1086], [0x108d, 0x108d],

  // Ethiopic
  [0x135f, 0x135f],

  // Tagalog
  [0x1712, 0x1714],

  // Hanunoo
  [0x1732, 0x1734],

  // Buhid
  [0x1752, 0x1753],

  // Tagbanwa
  [0x1772, 0x1773],

  // Khmer
  [0x17b7, 0x17bd], [0x17c6, 0x17c6], [0x17c9, 0x17d3], [0x17dd, 0x17dd],

  // Mongolian
  [0x180b, 0x180d], [0x18a9, 0x18a9],

  // Limbu
  [0x1920, 0x1922], [0x1927, 0x1928], [0x1932, 0x1932], [0x1939, 0x193b],

  // Buginese
  [0x1a17, 0x1a18],

  // Balinese
  [0x1b00, 0x1b03], [0x1b34, 0x1b34], [0x1b36, 0x1b3a], [0x1b3c, 0x1b3c],
  [0x1b42, 0x1b42], [0x1b6b, 0x1b73],

  // Sundanese
  [0x1b80, 0x1b81], [0x1ba2, 0x1ba5], [0x1ba8, 0x1ba9],

  // Lepcha
  [0x1c2c, 0x1c33], [0x1c36, 0x1c37],

  // Combining Diacritical Marks Supplement
  [0x1dc0, 0x1dff],

  // Combining Diacritical Marks for Symbols
  [0x20d0, 0x20ff],

  // Combining Cyrillic
  [0x2d30, 0x2dff],

  // Ideographic
  [0x302a, 0x302d],

  // Hangul
  [0x302e, 0x302f],

  // Combining Katakana-Hiragana
  [0x3099, 0x3099], [0x309a, 0x309a],

  // Combining Cyrillic
  [0xa66f, 0xa66f], [0xa67c, 0xa67d],

  // Syloti
  [0xa802, 0xa802], [0xa806, 0xa806], [0xa80b, 0xa80b], [0xa825, 0xa826],

  // Saurashtra
  [0xa8c4, 0xa8c4],

  // Kayah
  [0xa926, 0xa92d],

  // Rejang
  [0xa947, 0xa951],

  // Cham
  [0xaa29, 0xaa2e], [0xaa31, 0xaa32], [0xaa35, 0xaa36], [0xaa43, 0xaa43],
  [0xaa4c, 0xaa4c],

  // Hebrew Judeo-Spanish Varika
  [0xfb1e, 0xfb1e],

  // Variation Selector
  [0xfe00, 0xfe0f],

  // Combining Half Marks
  [0xfe20, 0xfeff],

  // Phaistos Disc Sign Combining Oblique Stroke
  [0x101dd, 0x101dd],

  // Kharoshthi
  [0x10a01, 0x10a03], [0x10a05, 0x10a06], [0x10a0c, 0x10a0f],
  [0x10a38, 0x10a39], [0x10a3a, 0x10a3a], [0x10a3f, 0x10a3f],

  // Musical Symbols
  [0x1d167, 0x1d169], [0x1d17b, 0x1d182], [0x1d185, 0x1d18b],
  [0x1d1aa, 0x1d1ad],

  // Combining Greek Musical Symbols
  [0x1d242, 0x1d244]
];

pub fn isCombiningMark(c: u32) -> bool {
  for range in COMBINING_MARKS.iter() {
    if c >= range[0] && c <= range[1] {
      return true;
    }
  };

  return false;
}

pub fn combine(a: u32, combiningMark: u32) -> u32 {
  let combiningMarkChar = match std::char::from_u32(combiningMark) {
    Some(chr) => chr,
    _ => '\0'
  };

  let matchChar = match std::char::from_u32(a) {
    Some(chr) => chr,
    _ => '\0'
  };

  let ret:char = match combiningMarkChar {
    '\u0300' => match matchChar {
                  'a' => 'à',
                  'e' => 'è',
                  'i' => 'ì',
                  'o' => 'ò',
                  'u' => 'ù',
                  'A' => 'À',
                  'E' => 'È',
                  'I' => 'Ì',
                  'O' => 'Ò',
                  'U' => 'Ù',
                  'W' => 'Ẁ',
                  'w' => 'ẁ',
                  'Y' => 'Ỳ',
                  'y' => 'ỳ',
                  ' ' => '`',
                    _ => matchChar
                },
    '\u0301' => match matchChar { // acute
                  'a' => '\u00e1',
                  'e' => '\u00e9',
                  'i' => '\u00ed',
                  'o' => '\u00f3',
                  'u' => '\u00fa',
                  'y' => '\u00fd',
                  'A' => '\u00c1',
                  'E' => '\u00c9',
                  'I' => '\u00cd',
                  'O' => '\u00d3',
                  'U' => '\u00da',
                  'Y' => '\u00dd',
                  'C' => '\u0106',
                  'c' => '\u0107',
                  'L' => '\u0139',
                  'l' => '\u013a',
                  'N' => '\u0143',
                  'n' => '\u0144',
                  'R' => '\u0154',
                  'r' => '\u0155',
                  'S' => '\u015a',
                  's' => '\u015b',
                  'Z' => '\u0179',
                  'z' => '\u017a',
                  '\u00c6' => '\u01fc', // Latin AE (capital)
                  '\u00e6' => '\u01fd', // Latin AE (small)
                  '\u00d8' => '\u01fe', // O with stroke (capital)
                  '\u00f8' => '\u01ff', // O with stroke (small)
                  'W' => '\u1e82',
                  'w' => '\u1e83',
                  ' ' => '\u00b4',
                    _ => matchChar
                },
    '\u0302' => match matchChar { // circumflex
                  'a' => '\u00e2',
                  'e' => '\u00ea',
                  'i' => '\u00ee',
                  'o' => '\u00f4',
                  'c' => '\u0109',
                  'g' => '\u011d',
                  'h' => '\u0125',
                  'j' => '\u0135',
                  's' => '\u015d',
                  'u' => '\u00fb',
                  'w' => '\u0175',
                  'y' => '\u0177',
                  'A' => '\u00c2',
                  'E' => '\u00ca',
                  'I' => '\u00ce',
                  'O' => '\u00d4',
                  'C' => '\u0108',
                  'G' => '\u011c',
                  'H' => '\u0124',
                  'J' => '\u0134',
                  'S' => '\u015c',
                  'U' => '\u00db',
                  'W' => '\u0174',
                  'Y' => '\u0176',
                  ' ' => '^',
                    _ => matchChar
                },
    '\u0303' => match matchChar { // tilde
                  'a' => '\u00e3',
                  'A' => '\u00c3',
                  'n' => '\u00f1',
                  'u' => '\u0169',
                  'N' => '\u00d1',
                  'U' => '\u0168',
                  'o' => '\u00f5',
                  'O' => '\u00d5',
                  'i' => '\u0129',
                  'I' => '\u0128',
                  ' ' => '~',
                    _ => matchChar
                },
    '\u0304' => match matchChar { // macron
                  'A' => '\u0100',
                  'a' => '\u0101',
                  'E' => '\u0112',
                  'e' => '\u0113',
                  'I' => '\u012a',
                  'i' => '\u012b',
                  'O' => '\u014c',
                  'o' => '\u014d',
                  'U' => '\u016a',
                  'u' => '\u016b',
                  '\u00c6' => '\u01e2', // Latin AE (capital)
                  '\u00e6' => '\u01e3', // Latin AE (small)
                  ' ' => '\u00af',
                    _ => matchChar
                },
    '\u0306' => match matchChar { // breve
                  'A' => '\u0102',
                  'a' => '\u0103',
                  'E' => '\u0114',
                  'e' => '\u0115',
                  'G' => '\u011e',
                  'g' => '\u011f',
                  'I' => '\u012c',
                  'i' => '\u012d',
                  'O' => '\u014e',
                  'o' => '\u014f',
                  'U' => '\u016c',
                  'u' => '\u016d',
                  '\u0416' => '\u04c1', // Cyrillic Letter Zhe (Capital)
                  '\u0436' => '\u04c2', // Cyrillic Letter Zhe (Small)
                  ' ' => '\u02d8',
                    _ => matchChar
                },
    '\u0307' => match matchChar{ // dot above
                  'C' => '\u010a',
                  'c' => '\u010b',
                  'E' => '\u0116',
                  'e' => '\u0117',
                  'G' => '\u0120',
                  'g' => '\u0121',
                  'I' => '\u0130',
                  'Z' => '\u017b',
                  'z' => '\u017c',
                  ' ' => '\u02d9',
                    _ => matchChar
                },
    '\u0308' => match matchChar{ // diaeresis
                  'a' => '\u00e4',
                  'e' => '\u00eb',
                  'i' => '\u00ef',
                  'o' => '\u00f6',
                  'u' => '\u00fc',
                  'y' => '\u00ff',
                  'A' => '\u00c4',
                  'E' => '\u00cb',
                  'I' => '\u00cf',
                  'O' => '\u00d6',
                  'U' => '\u00dc',
                  'Y' => '\u00df',
                  'W' => '\u1e84',
                  'w' => '\u1e85',
                  ' ' => '\u00a8',
                    _ => matchChar
                },
    '\u030a' => match matchChar { // ring above
                  'A' => '\u00c5',
                  'a' => '\u00e5',
                  'U' => '\u016e',
                  'u' => '\u016f',
                  ' ' => '\u02da',
                    _ => matchChar
                },
    '\u030b' => match matchChar { // double acute
                  'O' => '\u0150',
                  'o' => '\u0151',
                  'U' => '\u0170',
                  'u' => '\u0171',
                  ' ' => '\u02dd',
                    _ => matchChar
                },
    '\u030c' => match matchChar { // caron
                  'C' => '\u010c',
                  'c' => '\u010d',
                  'D' => '\u010e',
                  'd' => '\u010f',
                  'E' => '\u011a',
                  'e' => '\u011b',
                  'L' => '\u013d',
                  'l' => '\u013e',
                  'N' => '\u0147',
                  'n' => '\u0148',
                  'R' => '\u0158',
                  'r' => '\u0159',
                  'S' => '\u0160',
                  's' => '\u0161',
                  'T' => '\u0164',
                  't' => '\u0165',
                  'Z' => '\u017d',
                  'z' => '\u017e',
                  '\u02a3' => '\u01c6', // Latin letter dz (small, digraph)
                  'A' => '\u01cd',
                  'a' => '\u01ce',
                  'I' => '\u01cf',
                  'i' => '\u01d0',
                  'O' => '\u01d1',
                  'o' => '\u01d2',
                  'U' => '\u01d3',
                  'u' => '\u01d4',
                  'G' => '\u01e6',
                  'g' => '\u01e7',
                  'K' => '\u01e8',
                  'k' => '\u01e9',
                  '\u01b7' => '\u01ee', // Ezh (capital)
                  '\u0292' => '\u01ef', // Ezh (small)
                  'j' => '\u01f0',
                  ' ' => '\u02c7',
                    _ => matchChar
                },
    '\u031b' => match matchChar { // horn
                  'O' => '\u01a0',
                  'o' => '\u01a1',
                  'U' => '\u01af',
                  'u' => '\u01b0',
                    _ => matchChar
                },
    '\u0326' => match matchChar { // comma below
                  'S' => '\u0218',
                  's' => '\u0219',
                  'T' => '\u021a',
                  't' => '\u021b',
                  ' ' => ',',
                    _ => matchChar
                },
    '\u0327' => match matchChar { // cedilla
                  'C' => '\u00c7',
                  'c' => '\u00e7',
                  'G' => '\u0122',
                  'g' => '\u0123',
                  'K' => '\u0136',
                  'k' => '\u0137',
                  'L' => '\u013b',
                  'l' => '\u013c',
                  'N' => '\u0145',
                  'n' => '\u0146',
                  'R' => '\u0156',
                  'r' => '\u0157',
                  'S' => '\u015e',
                  's' => '\u015f',
                  'T' => '\u0162',
                  't' => '\u0163',
                  ' ' => '\u00b8',
                    _ => matchChar
                },
    '\u0328' => match matchChar { // ogonek
                  'A' => '\u0104',
                  'a' => '\u0105',
                  'E' => '\u0118',
                  'e' => '\u0119',
                  'I' => '\u012e',
                  'i' => '\u012f',
                  'U' => '\u0172',
                  'u' => '\u0173',
                  'O' => '\u01ea',
                  'o' => '\u01eb',
                  ' ' => '\u02db',
                    _ => matchChar
                },
    '\u05bc' => match matchChar { // hebrew point dagesh or mapiq
                  '\u05d1' => '\ufb31',
                  '\u05db' => '\ufb3b',
                  '\u05da' => '\ufb3a',
                  '\u05e4' => '\ufb44',
                  '\u05e3' => '\ufb43',
                  '\u05e9' => '\ufb49',
                         _ => matchChar
                },
    '\u05bf' => match matchChar { // hebrew point rafe
                  '\u05d1' => '\ufb4c',
                  '\u05db' => '\ufb4d',
                  '\u05e4' => '\ufb4e',
                         _ => matchChar
                },
    '\u05c1' => match matchChar { // hebrew point shin dot
                  '\u05e9' => '\ufb2a',
                         _ => matchChar
                },
    '\u05c2' => match matchChar { // hebrew point sin dot
                  '\u05e9' => '\ufb2b',
                         _ => matchChar
                },
    '\u0654' => match matchChar { // arabic hamza above
                  '\u0627' => '\u0623',
                  '\u06c1' => '\u06c2',
                  '\u0648' => '\u0624',
                  '\u064a' => '\u0626',
                  '\u06d2' => '\u06d3',
                         _ => matchChar
                },
           _ => matchChar
  };

  ret as u32
}
