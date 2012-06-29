module keyboard.layout.colemak;

import keyboard.translator;
import keyboard.key;

// TODO: Finish
final class LayoutColemak {
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
		Key.Code.E: 'f',
		Key.Code.R: 'p',
		Key.Code.T: 'g',
		Key.Code.Y: 'j',
		Key.Code.U: 'l',
		Key.Code.I: 'u',
		Key.Code.O: 'y',
		Key.Code.P: ';',
		Key.Code.A: 'a',
		Key.Code.S: 'r',
		Key.Code.D: 's',
		Key.Code.F: 't',
		Key.Code.G: 'd',
		Key.Code.H: 'h',
		Key.Code.J: 'n',
		Key.Code.K: 'e',
		Key.Code.L: 'i',
		Key.Code.Z: 'z',
		Key.Code.X: 'x',
		Key.Code.C: 'c',
		Key.Code.V: 'v',
		Key.Code.B: 'b',
		Key.Code.N: 'k',
		Key.Code.M: 'm',
		Key.Code.Semicolon: 'o',
		Key.Code.Apostrophe: '\'',
		Key.Code.Comma: ',',
		Key.Code.Period: '.',
		Key.Code.Foreslash: '/',
		Key.Code.LeftBracket: '[',
		Key.Code.RightBracket: ']',
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
		Key.Code.Minus: '_',
		Key.Code.Equals: '+',
		Key.Code.Q: 'Q',
		Key.Code.W: 'W',
		Key.Code.E: 'F',
		Key.Code.R: 'P',
		Key.Code.T: 'G',
		Key.Code.Y: 'J',
		Key.Code.U: 'L',
		Key.Code.I: 'U',
		Key.Code.O: 'Y',
		Key.Code.P: ':',
		Key.Code.A: 'A',
		Key.Code.S: 'R',
		Key.Code.D: 'S',
		Key.Code.F: 'T',
		Key.Code.G: 'D',
		Key.Code.H: 'H',
		Key.Code.J: 'N',
		Key.Code.K: 'E',
		Key.Code.L: 'I',
		Key.Code.Z: 'Z',
		Key.Code.X: 'X',
		Key.Code.C: 'C',
		Key.Code.V: 'V',
		Key.Code.B: 'B',
		Key.Code.N: 'K',
		Key.Code.M: 'M',
		Key.Code.Semicolon: 'O',
		Key.Code.Apostrophe: '"',
		Key.Code.Comma: '<',
		Key.Code.Period: '>',
		Key.Code.Foreslash: '?',
		Key.Code.LeftBracket: '{',
		Key.Code.RightBracket: '}',
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
