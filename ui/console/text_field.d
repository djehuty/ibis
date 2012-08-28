module ui.console.text_field;

import ui.console.window;
import ui.console.canvas;

import drawing.color;

import binding.c;

import keyboard.key;

import text.format;
import text.unicode;
import text.string;

final class ConsoleTextField {
private:
  ConsoleWindow _window;

  char[] _text;
  size_t _position;
  size_t _max;

  Color _backcolor;
  Color _forecolor;
  Color _color;

  bool _onKeyDown(Key key) {
		_forecolor = Color.Green;
		if (key.code == Key.Code.Backspace) {
			if (_position > 0) {
				if (_position == _max) {
					_text = String.substring(_text, 0, Unicode.utflen(_text) - 1);
				}
				else {
					_text = String.substring(_text, 0, _position - 1) ~ String.substring(_text, _position);
				}

				_position--;
				_window.redraw();
			}
		}
		else if (key.code == Key.Code.Return) {
			//tabForward();
		}

    return false;
  }

  bool _onKeyChar(dchar chr) {
		if (chr != 0x8 && chr != '\t' && chr != '\n' && chr != '\r') {
			if (_position <= _max) {

				_position++;

				if (_position > _max) {
					_position = _max;
					_text = String.substring(_text, 0, Unicode.utflen(_text) - 1) ~ Unicode.toUtf8([chr]);
				}
				else {
					_text = String.substring(_text, 0, _position - 1) ~ Unicode.toUtf8([chr]) ~ String.substring(_text, _position-1);
				}

        _window.redraw();
			}
		}

    return false;
  }

  bool _onDraw(ConsoleCanvas canvas) {
		canvas.position(0,0);

		canvas.forecolor = _color;
		canvas.backcolor = _window.parent.backcolor;

		canvas.write("[");

		canvas.forecolor = _forecolor;
    if (_backcolor.alpha > 0.0) {
      canvas.backcolor = _backcolor;
    }

    canvas.write(String.substring(_text, 0, _max));

		_position = Unicode.utflen(_text);
		if (_position > _max) {
			_position = _max;
		}

		for (size_t i = Unicode.utflen(_text); i < _max; i++) {
			canvas.write(" ");
		}

		canvas.forecolor = _color;
		canvas.backcolor = _window.parent.backcolor;

		canvas.write("]");

    return false;
  }

public:
  this(int x, int y, uint width) {
    this(x, y, width, "");
  }

  this(int x, int y, uint width, char[] text) {
    _max = width - 2;

    _color = Color.Blue;
    _forecolor = Color.Yellow;
    _backcolor = Color.Black;

    _text = text.dup;
    _position = Unicode.utflen(_text);

    _window = new ConsoleWindow(x, y, width, 1, Color.Green,
        &_onKeyDown, null, null, null, null, null, null, null,
        &_onDraw, null, null, null, null, null, &_onKeyChar);

    _window.visible = true;
  }

  char[] text() {
    return _text.dup;
  }

  void text(char[] value) {
    _text = value.dup;
  }

  ConsoleWindow window() {
    return _window;
  }
}
