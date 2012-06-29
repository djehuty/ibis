module keyboard.layout.czech_programmers;

import keyboard.translator;
import keyboard.key;

import text.unicode;

final class LayoutCzechProgrammers {
private:
	static dchar _translateToChar[] = [
		Key.Code.SingleQuote: '`',
		Key.Code.One: '1',
		Key.Code.Two: '2',
		Key.Code.Three: '3',
		Key.Code.Four: '4',
		Key.Code.Five: '5',
		Key.Code.Six: '6',
		Key.Code.Seven: '7',
		Key.Code.Eight: '8',
		Key.Code.Nine: '9',
		Key.Code.Zero: '0',
		Key.Code.Minus: '-',
		Key.Code.Equals: '=',
		Key.Code.Q: 'q',
		Key.Code.W: 'w',
		Key.Code.E: 'e',
		Key.Code.R: 'r',
		Key.Code.T: 't',
		Key.Code.Y: 'y',
		Key.Code.U: 'u',
		Key.Code.I: 'i',
		Key.Code.O: 'o',
		Key.Code.P: 'p',
		Key.Code.A: 'a',
		Key.Code.S: 's',
		Key.Code.D: 'd',
		Key.Code.F: 'f',
		Key.Code.G: 'g',
		Key.Code.H: 'h',
		Key.Code.J: 'j',
		Key.Code.K: 'k',
		Key.Code.L: 'l',
		Key.Code.Z: 'z',
		Key.Code.X: 'x',
		Key.Code.C: 'c',
		Key.Code.V: 'v',
		Key.Code.B: 'b',
		Key.Code.N: 'n',
		Key.Code.M: 'm',
		Key.Code.Semicolon: ';',
		Key.Code.Comma: ',',
		Key.Code.Period: '.',
		Key.Code.Foreslash: '/',
		Key.Code.Backslash: '\\',
		Key.Code.LeftBracket: '[',
		Key.Code.RightBracket: ']',
		Key.Code.Apostrophe: '\'',
		Key.Code.Space: ' ',

		Key.Code.KeypadZero: '0',
		Key.Code.KeypadOne: '1',
		Key.Code.KeypadTwo: '2',
		Key.Code.KeypadThree: '3',
		Key.Code.KeypadFour: '4',
		Key.Code.KeypadFive: '5',
		Key.Code.KeypadSix: '6',
		Key.Code.KeypadSeven: '7',
		Key.Code.KeypadEight: '8',
		Key.Code.KeypadNine: '9',
		Key.Code.KeypadMinus: '-',
		Key.Code.KeypadPlus: '+',
		Key.Code.KeypadForeslash: '/',
		Key.Code.KeypadAsterisk: '*',
		Key.Code.KeypadPeriod: '.'
	];

	static dchar _translateShiftToChar[] = [
		Key.Code.SingleQuote: '~',
		Key.Code.One: '!',
		Key.Code.Two: '@',
		Key.Code.Three: '#',
		Key.Code.Four: '$',
		Key.Code.Five: '%',
		Key.Code.Six: '^',
		Key.Code.Seven: '&',
		Key.Code.Eight: '*',
		Key.Code.Nine: '(',
		Key.Code.Zero: ')',
		Key.Code.Minus: '_',
		Key.Code.Equals: '+',
		Key.Code.Q: 'Q',
		Key.Code.W: 'W',
		Key.Code.E: 'E',
		Key.Code.R: 'R',
		Key.Code.T: 'T',
		Key.Code.Y: 'Y',
		Key.Code.U: 'U',
		Key.Code.I: 'I',
		Key.Code.O: 'O',
		Key.Code.P: 'P',
		Key.Code.A: 'A',
		Key.Code.S: 'S',
		Key.Code.D: 'D',
		Key.Code.F: 'F',
		Key.Code.G: 'G',
		Key.Code.H: 'H',
		Key.Code.J: 'J',
		Key.Code.K: 'K',
		Key.Code.L: 'L',
		Key.Code.Z: 'Z',
		Key.Code.X: 'X',
		Key.Code.C: 'C',
		Key.Code.V: 'V',
		Key.Code.B: 'B',
		Key.Code.N: 'N',
		Key.Code.M: 'M',
		Key.Code.Semicolon: ':',
		Key.Code.Comma: '<',
		Key.Code.Foreslash: '?',
		Key.Code.Backslash: '|',
		Key.Code.Period: '>',
		Key.Code.LeftBracket: '{',
		Key.Code.RightBracket: '}',
		Key.Code.Apostrophe: '"',
		Key.Code.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.Code.SingleQuote: ';',
		Key.Code.One: '+',
		Key.Code.Two: '\u011b', // e with caron
		Key.Code.Three: '\u0161', // s with caron
		Key.Code.Four: '\u010d', // c with caron
		Key.Code.Five: '\u0159', // r with caron
		Key.Code.Six: '\u017e', // z with caron
		Key.Code.Seven: '\u00fd', // y with acute
		Key.Code.Eight: '\u00e1', // a with acute
		Key.Code.Nine: '\u00ed', // i with acute
		Key.Code.Zero: '\u00e9', // e with acute
		Key.Code.Minus: '=',
		Key.Code.E: '\u20ac', // Euro Sign
		Key.Code.LeftBracket: '\u00fa', // u with acute
		Key.Code.RightBracket: ')',
		Key.Code.Semicolon: '\u016f', // u with ring above
		Key.Code.Apostrophe: '\u00a7', // Section Sign
		Key.Code.Comma: '?',
		Key.Code.Period: ':',
		Key.Code.Foreslash: '\u002d', // Hyphen-minus
		Key.Code.Space: ' '
	];

	static dchar _translateShiftAltToChar[] = [
		Key.Code.Minus: '%',
		Key.Code.LeftBracket: '/',
		Key.Code.RightBracket: '(',
		Key.Code.Semicolon: '"',
		Key.Code.Apostrophe: '!',
		Key.Code.Comma: '\u00d7', // multiplication sign
		Key.Code.Period: '\u00f7', // division sign
		Key.Code.Foreslash: '\u005f', // low line
		Key.Code.Space: ' '
	];

  void _translate(Key key, out dchar ret, ref dchar dead) {
    ret  = '\0';

		if (!key.shift && !key.alt && !key.control) {
			// Dead characters
			if (key.code < _translateToChar.length) {
				ret = _translateToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code == Key.Code.SingleQuote) {
				dead = '\u0303'; // tilde
			}
			else if (key.code < _translateShiftToChar.length) {
				ret = _translateShiftToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Code.Equals) {
				dead = '\u0301'; // acute
			}
			else if (key.code == Key.Code.Backslash) {
				dead = '\u0308'; // diaeresis
			}
			else if (key.code < _translateAltToChar.length) {
				ret = _translateAltToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Code.Equals) {
				dead = '\u030c'; // caron
			}
			else if (key.code == Key.Code.Backslash) {
				dead = '\u0302'; // circumflex
			}
			else if (key.code == Key.Code.SingleQuote) {
				dead = '\u030a'; // ring above
			}
			else if (key.code < _translateShiftAltToChar.length) {
				ret = _translateShiftAltToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}

		if (ret == 0xffff) {
			ret = '\0';
		}
		if (ret != '\0') {
			dead = '\0';
		}
  }

public:
  this() {
  }

	dchar translate(Key key, dchar dead) {
    dchar ret;
    _translate(key, ret, dead);
    return ret;
	}

  bool isDead(Key key) {
    dchar ret, dead = '\0';
    _translate(key, ret, dead);
    return dead != '\0';
  }

  Translator translator() {
    return new Translator(&translate, &isDead);
  }
}
