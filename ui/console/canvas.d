module ui.console.canvas;

import geometry.rectangle;
import geometry.point;

import drawing.color;

import text.unicode;
import text.string;

import io.console;
import binding.c;

final class ConsoleCanvas {
private:
	// The clipping region stack
	Rectangle[]   _clippingRegions;
	Rectangle[][] _clippingStack;

	// The current colors
	Color _fgcolor;
	Color _bgcolor;

	// The logical top-left coordinate
	Point   _topleft;
	Point[] _topleftStack;

	int _xposition;
	int _yposition;

  uint delegate() _widthFunc;
  uint delegate() _heightFunc;
  void delegate(int x, int y) _positionFunc;
  void delegate(char[] string) _writeFunc;
  void delegate(Color) _forecolorFunc;
  void delegate(Color) _backcolorFunc;

	// This is a crazy function that will print to the screen but
	// only within the clipping region.
	void _putstring(char[] str) {
		int x;
		int y;
		int r;
		int b;

		uint cw, ch;
    cw = _widthFunc();
    ch = _heightFunc();

		if (_yposition < 0 || _yposition >= ch) {
			return;
		}

		if (_xposition >= cast(int)cw) {
			return;
		}

		if (_xposition + Unicode.utflen(str) > cast(int)cw) {
			str = String.substring(str, 0, cast(int)cw - _xposition);
		}

		if (_xposition < 0) {
			if (_xposition < -Unicode.utflen(str)) {
				_xposition += Unicode.utflen(str);
				return;
			}
			int newpos = -_xposition;
			_xposition = 0;
			_positionFunc(0, _yposition);
			_putstring(String.substring(str, newpos));
			return;
		}

		x = _xposition;
		y = _yposition;

		r = x + Unicode.utflen(str);
		b = y + 1;

		_xposition = r;

		// Quick out... no clipping region, just draw the string
		if (_clippingRegions.length == 0) {
			_positionFunc(x, y);
      _writeFunc(str);
			return;
		}

		// This will contain lengths of substrings
		// It will alternate, IN OUT IN OUT IN OUT etc
		// Where OUT means it is not drawn, and IN is

		// We start with everything drawn
		uint[] formatArray = [str.length, 0];

		auto strutflength = Unicode.utflen(str);

		foreach(region; _clippingRegions) {
      double halfWidth  = region.width / 2.0;
      double halfHeight = region.height / 2.0;

			int regionleft = cast(int)(region.x - halfWidth);
			int regionright = cast(int)(region.x + halfWidth);
			int regionbottom = cast(int)(region.y + halfHeight);
			int regiontop = cast(int)(region.y - halfHeight);

			if (x < regionright && r > regionleft && y < regionbottom && b > regiontop) {
				// This string clips this clipping rectangle
				// Grab the substring within the clipping region

				int str_start = 0;

				if (x < regionleft) {
					str_start = regionleft - x;
				}

				int str_end;
				str_end = regionright - x;

				if (str_end > strutflength) {
					str_end = strutflength;
				}

				uint str_length = str_end - str_start;

				if (str_length <= 0) {
					continue;
				}

				if (str_length == strutflength) {
					// it is completely within a clipping region
					// so, quit!
					return;
				}

				// We must now go through the format array
				// Remember, the array is like this: [IN, OUT, IN, OUT, ... ]
				// where IN means it will be drawn, and OUT means it will not.

				// So, we merely need to loop through the array and find an IN
				// section that can be updated with respect to this clipped
				// section, which is represented by str_start to str_end.

				// This string (str_start..str_end) represents a section of the
				// output that will be clipped.

				// The loop here will update the format array.

				// It first tries to find the first part of the array to mutate,
				// and then it cascades the effect of the update.

				uint regionSize;
				int pos = 0;

				size_t i;

				// Search loop
				for(i = 0; i < formatArray.length; i++) {
					if (pos + formatArray[i] > str_start) {
						if (i % 2 == 0) { // IN
							// subtract from this IN section
							uint newValue = str_start - pos;

							// A special case... the IN is being subdivided
							if (str_end < pos + formatArray[i]) {
								uint difference = (pos + formatArray[i]) - str_end;
								formatArray = formatArray[0..i] ~ [newValue] ~ [str_length] ~ [difference] ~ formatArray[i+1..$];
							}
							else {
								// Move stuff we took out of this IN to the OUT region next to it
								if ((i + 1) < formatArray.length) {
									formatArray[i+1] += formatArray[i] - newValue;
								}

								// Truncate the IN region
								formatArray[i] = newValue;
							}

							// Move to the OUT region
							i++;

							regionSize = str_length;
						}
						else { // OUT

							// We will try to expand this region to hold str_length... we
							// also need to hold what is already there to the left of the str_start
							regionSize = str_end - pos;
						}

						// We have finished the loop
						break;
					}
					pos += formatArray[i];
				}

				if (i == formatArray.length) {
					formatArray ~= [regionSize];
				}

				// Grow the OUT section at i
				// until it accommodates str_length
				while(formatArray[i] < regionSize) {
					// Take from the IN region next to it
					uint left = regionSize - formatArray[i];

					if ((i + 1) >= formatArray.length) {
						// There is not IN section after this OUT
						// So, just update the OUT region
						formatArray[i] = regionSize;
					}
					else if (formatArray[i+1] <= left) {
						// OK! This IN section more than makes up for what is left
						// Remove the IN section by adding the next OUT section to this
						if ((i+2) < formatArray.length) {
							formatArray[i] += formatArray[i+1] + formatArray[i+2];
							formatArray = formatArray[0..i+1] ~ formatArray[i+3..$];
						}
						else {
							formatArray[i] += formatArray[i+1];
							formatArray = formatArray[0..i+1];
						}
					}
					else {
						// We need to split up some of the IN section, which can fit
						// the entire region that is left
						formatArray[i+1] -= left;
						formatArray[i] += left;
					}
				}
			}
		}

		bool isOut = true;
		uint pos = 0;

		_positionFunc(x, y);
		for (uint i; i < formatArray.length; i++, isOut = !isOut) {
			if (isOut) {
				_writeFunc(String.substring(str, pos, formatArray[i]));
			}
			else {
				_positionFunc(x + pos + formatArray[i], y);
			}
			pos += formatArray[i];
		}
	}

	// Just a helper function to set the position of the caret
	void _position(int x, int y) {
		_xposition = x;
		_yposition = y;

		uint cw, ch;
    cw = _widthFunc();
    ch = _heightFunc();

		if (y < 0) { y = 0; }
		if (x < 0) { x = 0; }
		if (x >= cw) { x = cw-1; }
		if (y >= ch) { y = ch-1; }

    _positionFunc(x, y);
	}

public:
  this(uint delegate()             widthFunc,
       uint delegate()             heightFunc,
       void delegate(int x, int y) positionFunc,
       void delegate(char[])       writeFunc,
       void delegate(Color)        forecolorFunc,
       void delegate(Color)        backcolorFunc) {
    _widthFunc = widthFunc;
    _heightFunc = heightFunc;
    _positionFunc = positionFunc;
    _writeFunc = writeFunc;
    _forecolorFunc = forecolorFunc;
    _backcolorFunc = backcolorFunc;

    _position(0, 0);

    _fgcolor = Color.Gray;
    _bgcolor = Color.Black;
  }

  uint width() {
    return _widthFunc();
  }

  uint height() {
    return _heightFunc();
  }

  void contextPush(int left, int top) {
    auto point = new Point(cast(int)(left + _topleft.x + 0.5),
                           cast(int)(top + _topleft.y + 0.5));

    _topleftStack ~= point;
    _topleft = point;
  }

  void contextPush(int[] point) {
    contextPush(point[0], point[1]);
  }

  void contextPop() {
    if (_topleftStack.length == 0) {
      return;
    }

    _topleftStack = _topleftStack[0..$-1];
    if (_topleftStack.length > 0) {
      _topleft = _topleftStack[$-1];
    }
    else {
      _topleft = new Point(0, 0);
    }
  }

  void contextClear() {
    _topleftStack = null;
    _topleft = new Point(0, 0);
  }

  void clipSave() {
    _clippingStack ~= _clippingRegions;
  }

  void clipRestore() {
    if (_clippingStack.length > 0) {
      _clippingRegions = _clippingStack[$-1];
      _clippingStack = _clippingStack[0..$-1];
    }
  }

  void clipClear() {
    _clippingRegions = null;
    _clippingStack = null;
  }

  void clipRectangle(Rectangle rectangle) {
    rectangle = new Rectangle(rectangle.x + _topleft.x,
                              rectangle.y + _topleft.y,
                              rectangle.width,
                              rectangle.height);
    _clippingRegions ~= rectangle;
  }

  void position(int x, int y) {
    _position(cast(int)(x + _topleft.x + 0.5),
              cast(int)(y + _topleft.y + 0.5));
  }

  void position(int[] coord) {
    position(coord[0], coord[1]);
  }

  Point position() {
    return new Point(_xposition - _topleft.x, _yposition - _topleft.y);
  }

  void forecolor(Color clr) {
    _forecolorFunc(clr);
    _fgcolor = clr;
  }

  Color forecolor() {
    return _fgcolor;
  }

  void backcolor(Color clr) {
    _backcolorFunc(clr);
    _bgcolor = clr;
  }

  Color backcolor() {
    return _bgcolor;
  }

  void write(char[] string) {
    _putstring(string);
  }
}
