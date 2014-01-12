#[crate_id="keyboard-layout-spanish#1.0"];
#[feature(globs)];

extern mod keyboard_key = "keyboard-key";

pub mod keyboard {
  pub mod layout {
    pub mod spanish {
      use keyboard_key::keyboard::key::*;

      static translateToChar:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\u00ba', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', '0', '\'', '\u00a1', '\x00', '\x00', '\x00', '\x00', '\x00',
        '/', '*', '-', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', 'q', 'w', 'e', 'r', 't',
        'y', 'u', 'i', 'o', 'p', '\x00', '+', '\u00e7', '\x00', '\x00',
        '\x00', '7', '8', '9', '+', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', 'a', 's', 'd',
        'f', 'g', 'h', 'j', 'k', 'l', '\u00f1', '\x00', '\x00', '4',
        '5', '6', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', 'z',
        'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '-', '<',
        '\x00', '\x00', '1', '2', '3', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', ' ', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '0', '.'
      ];

      static translateToCharShift:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\u00aa', '!', '"', '\u00b7', '$', '%', '&', '/',
        '(', ')', '=', '?', '\u00bf', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', 'Q', 'W', 'E', 'R', 'T',
        'Y', 'U', 'I', 'O', 'P', '\x00', '*', '\u00c7', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', 'A', 'S', 'D',
        'F', 'G', 'H', 'J', 'K', 'L', '\u00d1', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', 'Z',
        'X', 'C', 'V', 'B', 'N', 'M', ';', ':', '_', '>',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', ' ', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00'
      ];

      static translateToCharAlt:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\\', '|', '@', '#', '\x00', '\u20ac', '\u00ac', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\u20ac', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '[', ']', '}', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '{', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', ' ', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00'
      ];

      static translateDead:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\u0300', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\u0301', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00'
      ];

      static translateDeadShift:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\u0302', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\u0308', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00'
      ];

      static translateDeadAlt:[char, ..173] = [
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\u0303', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
        '\x00', '\x00', '\x00'
      ];

      pub fn translate(key: Key, dead: u32) -> u32 {
        if (!(key.shift() ^ key.capsLock) && !key.alt() && !key.control()) {
          if (translateDead[key.code as uint] != '\x00') {
            translateDead[key.code as uint] as u32
          }
          else if (dead != 0) {
            // XXX: use unicode combine
            translateToChar[key.code as uint] as u32
          }
          else {
            translateToChar[key.code as uint] as u32
          }
        }
        else if ((key.shift() || key.capsLock) && !key.alt() && !key.control()) {
          if (translateDeadShift[key.code as uint] != '\x00') {
            translateDeadShift[key.code as uint] as u32
          }
          else if (dead != 0) {
            // XXX: use unicode combine
            translateToCharShift[key.code as uint] as u32
          }
          else {
            translateToCharShift[key.code as uint] as u32
          }
        }
        else if (!key.shift() && key.rightAlt && !key.control()) {
          if (translateDeadAlt[key.code as uint] != '\x00') {
            translateDeadAlt[key.code as uint] as u32
          }
          else if (dead != 0) {
            // XXX: use unicode combine
            translateToCharAlt[key.code as uint] as u32
          }
          else {
            translateToCharAlt[key.code as uint] as u32
          }
        }
        else {
          0
        }
      }
    }
  }
}
