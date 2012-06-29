module keyboard.layout.dvorak;

import keyboard.translator;
import keyboard.key;

final class LayoutDvorak {
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
		Key.Code.Minus: '[',
		Key.Code.Equals: ']',
		Key.Code.Q: '\'',
		Key.Code.W: ',',
		Key.Code.E: '.',
		Key.Code.R: 'p',
		Key.Code.T: 'y',
		Key.Code.Y: 'f',
		Key.Code.U: 'g',
		Key.Code.I: 'c',
		Key.Code.O: 'r',
		Key.Code.P: 'l',
		Key.Code.A: 'a',
		Key.Code.S: 'o',
		Key.Code.D: 'e',
		Key.Code.F: 'u',
		Key.Code.G: 'i',
		Key.Code.H: 'd',
		Key.Code.J: 'h',
		Key.Code.K: 't',
		Key.Code.L: 'n',
		Key.Code.Z: ';',
		Key.Code.X: 'q',
		Key.Code.C: 'j',
		Key.Code.V: 'k',
		Key.Code.B: 'x',
		Key.Code.N: 'b',
		Key.Code.M: 'm',
		Key.Code.Semicolon: 's',
		Key.Code.Apostrophe: '-',
		Key.Code.Comma: 'w',
		Key.Code.Period: 'v',
		Key.Code.Foreslash: 'z',
		Key.Code.LeftBracket: '/',
		Key.Code.RightBracket: '=',
		Key.Code.Backslash: '\\',
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
		Key.Code.Minus: '{',
		Key.Code.Equals: '}',
		Key.Code.Q: '"',
		Key.Code.W: '<',
		Key.Code.E: '>',
		Key.Code.R: 'P',
		Key.Code.T: 'Y',
		Key.Code.Y: 'F',
		Key.Code.U: 'G',
		Key.Code.I: 'C',
		Key.Code.O: 'R',
		Key.Code.P: 'L',
		Key.Code.A: 'A',
		Key.Code.S: 'O',
		Key.Code.D: 'E',
		Key.Code.F: 'U',
		Key.Code.G: 'I',
		Key.Code.H: 'D',
		Key.Code.J: 'H',
		Key.Code.K: 'T',
		Key.Code.L: 'N',
		Key.Code.Z: ':',
		Key.Code.X: 'Q',
		Key.Code.C: 'J',
		Key.Code.V: 'K',
		Key.Code.B: 'X',
		Key.Code.N: 'B',
		Key.Code.M: 'M',
		Key.Code.Semicolon: 'S',
		Key.Code.Apostrophe: '_',
		Key.Code.Comma: 'W',
		Key.Code.Period: 'V',
		Key.Code.Foreslash: 'Z',
		Key.Code.LeftBracket: '?',
		Key.Code.RightBracket: '+',
		Key.Code.Backslash: '|',
		Key.Code.Space: ' '
	];

public:
  this() {
  }

	dchar translate(Key key, dchar dead) {
    dchar ret = '\0';

		if (!key.shift && !key.alt && !key.control) {
			if (key.code < _translateToChar.length) {
				ret = _translateToChar[key.code];
			}
		}
		else if (key.shift && !key.alt && !key.control) {
			if (key.code < _translateShiftToChar.length) {
				ret = _translateShiftToChar[key.code];
			}
		}
		if (ret == 0xffff) {
			ret = '\0';
		}

		return ret;
	}

  bool isDead(Key key) {
    return false;
  }

  Translator translator() {
    return new Translator(&translate, &isDead);
  }
}
