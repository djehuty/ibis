module keyboard.layout.spanish;

import keyboard.translator;
import keyboard.key;

import text.unicode;

final class LayoutSpanish {
private:
	static dchar _translateToChar[] = [
		Key.Code.SingleQuote: '\u00ba', // masculing ordinal indicator
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
		Key.Code.Minus: '\'',
		Key.Code.Equals: '\u00a1', // inverted !
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
		Key.Code.Semicolon: '\u00f1', // n with tilde
		Key.Code.Comma: ',',
		Key.Code.Period: '.',
		Key.Code.Foreslash: '-',
		Key.Code.RightBracket: '+',
		Key.Code.Backslash: '\u00e7', // c with cedilla
		Key.Code.International: '<',
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
		Key.Code.SingleQuote: '\u00aa', // feminine ordinal indicator
		Key.Code.One: '!',
		Key.Code.Two: '"',
		Key.Code.Three: '\u00b7', // middle dot
		Key.Code.Four: '$',
		Key.Code.Five: '%',
		Key.Code.Six: '&',
		Key.Code.Seven: '/',
		Key.Code.Eight: '(',
		Key.Code.Nine: ')',
		Key.Code.Zero: '=',
		Key.Code.Minus: '?',
		Key.Code.Equals: '\u00bf', // inverted ?
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
		Key.Code.Semicolon: '\u00d1', // N with tilde
		Key.Code.Comma: ';',
		Key.Code.Period: ':',
		Key.Code.Foreslash: '_',
		Key.Code.Backslash: '\u00c7', // C with cedilla
		Key.Code.RightBracket: '*',
		Key.Code.International: '>',
		Key.Code.Space: ' '
	];

	static dchar _translateAltToChar[] = [
		Key.Code.SingleQuote: '\\',
		Key.Code.One: '|',
		Key.Code.Two: '@',
		Key.Code.Three: '#',
		Key.Code.Five: '\u20ac', // euro sign
		Key.Code.Six: '\u00ac', // not sign
		Key.Code.E: '\u20ac', // euro sign
		Key.Code.LeftBracket: '[',
		Key.Code.RightBracket: ']',
		Key.Code.Backslash: '}',
		Key.Code.Apostrophe: '{',
		Key.Code.Space: ' '
	];

  void _translate(Key key, out dchar ret, ref dchar dead) {
		ret  = '\0';

		if (!key.shift && !key.alt && !key.control) {
			if (key.capsLock && (key.code >= Key.Code.A && key.code <= Key.Code.Z
			  || key.code == Key.Code.Backslash || key.code == Key.Code.Semicolon)) {
				ret = _translateShiftToChar[key.code];
			}
			else if (key.code == Key.Code.LeftBracket) {
				dead = '\u0300'; // grave
			}
			else if (key.code == Key.Code.Apostrophe) {
				dead = '\u0301'; // acute
			}
			else if (key.code < _translateToChar.length) {
				ret = _translateToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.capsLock && (key.code >= Key.Code.A && key.code <= Key.Code.Z
			  || key.code == Key.Code.Backslash || key.code == Key.Code.Semicolon)) {
				ret = _translateToChar[key.code];
			}
			else if (key.code == Key.Code.LeftBracket) {
				dead = '\u0302'; // circumflex
			}
			else if (key.code == Key.Code.Apostrophe) {
				dead = '\u0308'; // diaeresis
			}
			else if (key.code < _translateShiftToChar.length) {
				ret = _translateShiftToChar[key.code];

				if (dead != '\0') {
					ret = Unicode.combine(ret, dead)[0];
				}
			}
		}
		else if (!key.shift && key.rightAlt && !key.control) {
			if (key.code == Key.Code.Four) {
				dead = '\u0303'; // tilde
			}
			else if (key.code < _translateAltToChar.length) {
				ret = _translateAltToChar[key.code];

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
