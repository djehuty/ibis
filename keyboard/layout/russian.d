module keyboard.layout.russian;

import keyboard.translator;
import keyboard.key;

import text.unicode;

final class LayoutRussian {
private:
	static dchar _translateToChar[] = [
		Key.Code.SingleQuote: '\u0451', // small Io
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
		Key.Code.Q: '\u0439', // cyrillic small short I
		Key.Code.W: '\u0446', // cyrillic small Tse
		Key.Code.E: '\u0443', // cyrillic small U
		Key.Code.R: '\u043a', // cyrillic small Ka
		Key.Code.T: '\u0435', // cyrillic small Ie
		Key.Code.Y: '\u043d', // cyrillic small En
		Key.Code.U: '\u0433', // cyrillic small Ghe
		Key.Code.I: '\u0448', // cyrillic small Sha
		Key.Code.O: '\u0449', // cyrillic small Shcha
		Key.Code.P: '\u0437', // cyrillic small Ze
		Key.Code.A: '\u0444', // cyrillic small Ef
		Key.Code.S: '\u044b', // cyrillic small Yeru
		Key.Code.D: '\u0432', // cyrillic small Ve
		Key.Code.F: '\u0430', // cyrillic small A
		Key.Code.G: '\u043f', // cyrillic small Pe
		Key.Code.H: '\u0440', // cyrillic small Er
		Key.Code.J: '\u043e', // cyrillic small O
		Key.Code.K: '\u043b', // cyrillic small El
		Key.Code.L: '\u0434', // cyrillic small De
		Key.Code.Z: '\u044f', // cyrillic small Ya
		Key.Code.X: '\u0447', // cyrillic small Che
		Key.Code.C: '\u0441', // cyrillic small Es
		Key.Code.V: '\u043c', // cyrillic small Em
		Key.Code.B: '\u0438', // cyrillic small I
		Key.Code.N: '\u0442', // cyrillic small Te
		Key.Code.M: '\u044c', // cyrillic small soft sign
		Key.Code.Semicolon: '\u0436', // cyrillic small Zhe
		Key.Code.Apostrophe: '\u044d', // cyrillic small E
		Key.Code.Comma: '\u0431', // cyrillic small Be
		Key.Code.Period: '\u044e', // cyrillic small Yu
		Key.Code.Foreslash: '\u002e', // full stop
		Key.Code.LeftBracket: '\u0445', // cyrillic small Ha
		Key.Code.RightBracket: '\u044a', // cyrillic small hard sign
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
		Key.Code.SingleQuote: '\u0401', // capital Io
		Key.Code.One: '!',
		Key.Code.Two: '"',
		Key.Code.Three: '\u2116', // Numero Sign
		Key.Code.Four: ';',
		Key.Code.Five: '%',
		Key.Code.Six: ':',
		Key.Code.Seven: '?',
		Key.Code.Eight: '*',
		Key.Code.Nine: '(',
		Key.Code.Zero: ')',
		Key.Code.Minus: '_',
		Key.Code.Equals: '+',
		Key.Code.Q: '\u0419', // cyrillic capital short I
		Key.Code.W: '\u0426', // cyrillic capital Tse
		Key.Code.E: '\u0423', // cyrillic captial U
		Key.Code.R: '\u041a', // cyrillic capital Ka
		Key.Code.T: '\u0415', // cyrillic capital Ie
		Key.Code.Y: '\u041d', // cyrillic capital En
		Key.Code.U: '\u0413', // cyrillic capital Ghe
		Key.Code.I: '\u0428', // cyrillic capital Sha
		Key.Code.O: '\u0429', // cyrillic capital Shcha
		Key.Code.P: '\u0417', // cyrillic capital Ze
		Key.Code.A: '\u0424', // cyrillic capital Ef
		Key.Code.S: '\u042b', // cyrillic capital Yeru
		Key.Code.D: '\u0412', // cyrillic capital Ve
		Key.Code.F: '\u0410', // cyrillic capital A
		Key.Code.G: '\u041f', // cyrillic capital Pe
		Key.Code.H: '\u0420', // cyrillic capital Er
		Key.Code.J: '\u041e', // cyrillic capital O
		Key.Code.K: '\u041b', // cyrillic capital El
		Key.Code.L: '\u0414', // cyrillic capital De
		Key.Code.Z: '\u042f', // cyrillic capital Ya
		Key.Code.X: '\u0427', // cyrillic capital Che
		Key.Code.C: '\u0421', // cyrillic capital Es
		Key.Code.V: '\u041c', // cyrillic capital Em
		Key.Code.B: '\u0418', // cyrillic capital I
		Key.Code.N: '\u0422', // cyrillic capital Te
		Key.Code.M: '\u042c', // cyrillic capital soft sign
		Key.Code.Semicolon: '\u0416', // cyrillic capital Zhe
		Key.Code.Apostrophe: '\u042d', // cyrillic capital E
		Key.Code.Comma: '\u0411', // cyrillic capital Be
		Key.Code.Period: '\u042e', // cyrillic capital Yu
		Key.Code.Foreslash: ',', // full stop
		Key.Code.LeftBracket: '\u0425', // cyrillic capital Ha
		Key.Code.RightBracket: '\u042a', // cyrillic capital hard sign
		Key.Code.Backslash: '/',
		Key.Code.Space: ' '
	];

public:
  this() {
  }

	dchar translate(Key key, dchar dead) {
		dchar ret  = '\0';

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
