module keyboard.layout.canadian_multilingual;

import keyboard.translator;
import keyboard.key;

import text.unicode;

final class LayoutCanadianMultilingual {
private:
	static dchar _translateToChar[] = [
		Key.Code.SingleQuote: '/',
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
		Key.Code.Apostrophe: '\u00e8',
		Key.Code.RightBracket: '\u00e7',
		Key.Code.Backslash: '\u00e0',
		Key.Code.Foreslash: '\u00e9',
		Key.Code.International: '\u00f9', // u grave
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
		Key.Code.SingleQuote: '\\',
		Key.Code.One: '!',
		Key.Code.Two: '@',
		Key.Code.Three: '#',
		Key.Code.Four: '$',
		Key.Code.Five: '%',
		Key.Code.Six: '?',
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
		Key.Code.Comma: '\'',
		Key.Code.Period: '"',
		Key.Code.RightBracket: '\u00c7',
		Key.Code.Apostrophe: '\u00c8',
		Key.Code.Backslash: '\u00c0',
		Key.Code.Foreslash: '\u00c9',
		Key.Code.International: '\u00d9', // capital u grave
		Key.Code.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.Code.SingleQuote: '|',
		Key.Code.Seven: '{',
		Key.Code.Eight: '}',
		Key.Code.Nine: '[',
		Key.Code.Zero: ']',
		Key.Code.Equals: '\u00af', // Macron
		Key.Code.Semicolon: '\u00b0', // Degree
		Key.Code.Comma: '<',
		Key.Code.Period: '>',
		Key.Code.Z: '\u00ab', // Double angle quotes left
		Key.Code.X: '\u00bb', // Double angle quotes right
		Key.Code.Space: '\u00a0' // Non-breaking space
	];

	static dchar _translateControlToChar[] = [
		Key.Code.One: '\u00b9', // superscript one
		Key.Code.Two: '\u00b2', // superscript two
		Key.Code.Three: '\u00b3', // superscript three
		Key.Code.Four: '\u00bc', // 1/4
		Key.Code.Five: '\u00bd', // 1/2
		Key.Code.Six: '\u00be', // 3/4
		Key.Code.W: '\u0142', // Small latin L with stroke
		Key.Code.E: '\u0153', // Small latin Ligature Oe
		Key.Code.R: '\u00b6', // Pilcrow Sign
		Key.Code.T: '\u0167', // Small latin T with stroke
		Key.Code.Y: '\u2190', // Leftwards arrow
		Key.Code.U: '\u2193', // Downwards arrow
		Key.Code.I: '\u2192', // Rightwards arrow
		Key.Code.O: '\u00f8', // Small latin letter O with stroke
		Key.Code.P: '\u00fe', // Small latin letter Thorn
		Key.Code.RightBracket: '~',
		Key.Code.A: '\u00e6', // Small latin letter ae
		Key.Code.S: '\u00df', // Small latin letter Sharp S
		Key.Code.D: '\u00f0', // Small latin letter Eth
		Key.Code.G: '\u014b', // Small latin letter Eng
		Key.Code.H: '\u0127', // Small latin letter H with stroke
		Key.Code.J: '\u0133', // Small latin ligature ij
		Key.Code.K: '\u0138', // Small latin letter Kra
		Key.Code.L: '\u0140', // Small latin letter L with middle dot
		Key.Code.C: '\u00a2', // Cent Sign
		Key.Code.V: '\u201c', // Left Double Quote
		Key.Code.B: '\u201d', // Right Double Quote
		Key.Code.N: '\u0149', // Small latin letter N preceded by Apostrophe
		Key.Code.M: '\u00b5', // Micro Sign
		Key.Code.Comma: '\u2015', // Horizontal Bar
	];

	static dchar _translateShiftControlToChar[] = [
		Key.Code.SingleQuote: '\u00ad', // soft hyphen
		Key.Code.One: '\u00a1', // inverted exclamation mark
		Key.Code.Three: '\u00a3', // pound sign
		Key.Code.Four: '\u00a4', // currency sign
		Key.Code.Five: '\u215c', // 3/8
		Key.Code.Six: '\u215d', // 5/8
		Key.Code.Seven: '\u215e', // 7/8
		Key.Code.Eight: '\u2122', // TM
		Key.Code.Nine: '\u00b1', // plus-minus sign
		Key.Code.Minus: '\u00bf', // inverted question mark
		Key.Code.Q: '\u2126', // Ohm Sign
		Key.Code.W: '\u0141', // Capital latin L with stroke
		Key.Code.E: '\u0152', // Capital latin Ligature Oe
		Key.Code.R: '\u00ae', // Registered Sign
		Key.Code.T: '\u0166', // Capital latin T with stroke
		Key.Code.Y: '\u00a5', // Yen
		Key.Code.U: '\u2191', // Upwards arrow
		Key.Code.I: '\u0131', // Small latin letter Dotless i
		Key.Code.O: '\u00d8', // Capital latin letter O with stroke
		Key.Code.P: '\u00de', // Capital latin letter Thorn
		Key.Code.A: '\u00c6', // Capital latin letter ae
		Key.Code.S: '\u00a7', // Section Sign
		Key.Code.D: '\u00d0', // Capital latin letter Eth
		Key.Code.F: '\u00aa', // Feminine Ordinal Indicator
		Key.Code.G: '\u014a', // Capital latin letter Eng
		Key.Code.H: '\u0126', // Capital latin letter H with stroke
		Key.Code.J: '\u0132', // Capital latin ligature ij
		Key.Code.L: '\u013f', // Capital latin letter L with middle dot
		Key.Code.International: '\u00a6', // Broken Bar
		Key.Code.C: '\u00a9', // Copyright Sign
		Key.Code.V: '\u2018', // Left Single Quote
		Key.Code.B: '\u2019', // Right Single Quote
		Key.Code.N: '\u266a', // Eighth Note
		Key.Code.M: '\u00ba', // Masculine Ordinal Indicator
		Key.Code.Comma: '\u00d7', // Multiplication Sign
		Key.Code.Period: '\u00f7', // Division Sign
	];

  void _translate(Key key, out dchar ret, ref dchar dead) {
    ret  = '\0';

		if (!key.shift && !key.alt && !key.control) {
			// Dead characters
			if (key.code == Key.Code.LeftBracket) {
				dead = '\u0302'; // circumflex
			}
			else if (key.code < _translateToChar.length) {
				ret = _translateToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code == Key.Code.LeftBracket) {
				dead = '\u0308'; // diaeresis
			}
			else if (key.code < _translateShiftToChar.length) {
				ret = _translateShiftToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (!key.shift && !key.rightAlt && key.rightControl && !key.leftControl) {
			if (key.code == Key.Code.Equals) {
				// Dead char
			}
			else if (key.code == Key.Code.Period) {
				// Dead char
			}
			else if (key.code == Key.Code.Semicolon) {
				// Dead char
			}
			else if (key.code < _translateControlToChar.length) {
				ret = _translateControlToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (key.shift && !key.rightAlt && key.rightControl && !key.leftControl) {
			if (key.code == Key.Code.Equals) {
				dead = '\u0328'; // Ogonek
			}
			else if (key.code == Key.Code.Foreslash) {
				dead = '\u0307'; // Dot Above
			}
			else if (key.code == Key.Code.LeftBracket) {
				dead = '\u030a'; // Ring Above
			}
			else if (key.code == Key.Code.RightBracket) {
				dead = '\u0304'; // Macron
			}
			else if (key.code == Key.Code.Backslash) {
				dead = '\u0306'; // Breve
			}
			else if (key.code == Key.Code.Semicolon) {
				dead = '\u030b'; // Double Acute
			}
			else if (key.code == Key.Code.Apostrophe) {
				dead = '\u030c'; // Caron
			}
			else if (key.code < _translateShiftControlToChar.length) {
				ret = _translateShiftControlToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.leftAlt && !key.control) {
			if (key.code == Key.Code.LeftBracket) {
				dead = '\u0300'; // grave
			}
			else if (key.code == Key.Code.RightBracket) {
				dead = '\u0303'; // tilde
			}
			else if (key.code < _translateAltToChar.length) {
				ret = _translateAltToChar[key.code];
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
