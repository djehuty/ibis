module ui.console.label;

import ui.console.window;
import ui.console.canvas;

import text.string;
import text.unicode;

import drawing.color;

final class ConsoleLabel {
private:
  char[] _text;
  ConsoleWindow _window;

  Color _backcolor;
  Color _forecolor;

  bool _onDraw(ConsoleCanvas canvas) {
		canvas.position(0,0);

		canvas.forecolor = _forecolor;
    if (_backcolor.alpha > 0.0) {
      canvas.backcolor = _backcolor;
    }

    canvas.write(String.substring(_text, 0, _window.width));

		for (size_t i = Unicode.utflen(_text); i < _window.width; i++) {
			canvas.write(" ");
		}

    return false;
  }

public:
  this(int x, int y, uint width) {
    this(x, y, width, "");
  }

  this(int x, int y, uint width, char[] text) {
    _text = text.dup;

    _forecolor = Color.Yellow;
    _backcolor = Color.Clear;

    _window = new ConsoleWindow(x, y, width, 1, Color.Green,
        null, null, null, null, null, null, null, null,
        &_onDraw, null, null, null, null, null, null);

    _window.visible = true;
  }

  char[] text() {
    return _text.dup;
  }

  Color backcolor() {
    return _backcolor;
  }

  void backcolor(Color value) {
    _backcolor = value;
    _window.redraw();
  }

  Color forecolor() {
    return _forecolor;
  }

  void forecolor(Color value) {
    _forecolor = value;
    _window.redraw();
  }

  ConsoleWindow window() {
    return _window;
  }
}
