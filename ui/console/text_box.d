module ui.console.text_box;

import ui.console.window;
import ui.console.canvas;

import keyboard.key;

import drawing.color;

import text.unicode;
import text.format;
import text.string;

import data.mutable_list;

final class ConsoleTextBox {
private:
  char[] _text;
  bool   _lineNumbers;
  Color  _forecolor;
  Color  _backcolor;
  Color  _forecolorNumbers;
  Color  _backcolorNumbers;

  ConsoleWindow _window;

  // Top left corner
  long _firstVisible;
  long _firstColumn;

  // Caret Position
  long _row;
  long _column;

  // The column the caret is in while scrolling
  long _lineColumn;

  // Width of line numbers column
  int _lineNumbersWidth;

  // line continuation character
  dchar _lineCont;

  // Describes formatting
	static class LineFormat {
		this (Color f, Color b, uint l) {
			fgCol = f;
			bgCol = b;
			len = l;
		}

		LineFormat dup() {
			return new LineFormat(fgCol, bgCol, len);
		}

		int opEquals(LineFormat lf) {
			return cast(int)(this.fgCol == lf.fgCol && this.bgCol == lf.bgCol);
		}

		Color fgCol;
		Color bgCol;
		uint len;
	}

  // Describes a line
  class LineInfo {
    this() {
    }

    this(char[] v, LineFormat[] f) {
      value = v;
      format = f;
      this();
    }

    LineInfo dup() {
      return new LineInfo(this.value, this.format.dup);
    }

    void opCatAssign(LineInfo li) {
			if (this.format !is null && li.format !is null) {
				// Merge format lines
				if (this.format[$-1] == li.format[0]) {
					format[$-1].len += li.format[0].len;
					format ~= li.format[1..$];
				} else {
					format ~= li.format;
				}
			} else if (this.format !is null) {
				// Make a format for the 2nd line
				format ~= [new LineFormat(_forecolor, _backcolor, li.value.length)];
			} else if (li.format !is null) {
				// Make a format for the 1st line
				format = [new LineFormat(_forecolor, _backcolor, this.value.length)] ~ li.format;
			} else {
				// Ignore formats if none exist
			}

			this.value ~= li.value;
    }

		LineInfo opCat(LineInfo li) {
			LineInfo li_new = this.dup();
			li_new ~= li;
			return li_new;
		}

		char[] value;
		LineFormat[] format;
  }

  // Describe how the scrolling works
  enum ScrollType {
    Step,
    Skip
  }

	// How to scroll horizontally and vertically
	ScrollType _scrollH, _scrollV;

  // Buffer
  MutableList _lines;

  // Width of a tab in spaces.
  uint _tabWidth;

  // Current caret position within the format array
  size_t _formatIndex;

	void _positionCaret() {
		bool shouldDraw;
    auto line = cast(LineInfo)_lines.get(_row);

		// Count the tabs to the left of the caret.
		uint leftTabSpaces = 0;
		if (_tabWidth > 0) {
			for (uint i = 0; i < _column; i++) {
				if ("\t" == String.charAt(line.value, i)) {
					leftTabSpaces += _tabWidth - (i + leftTabSpaces) % _tabWidth - 1;
				}
			}
		}

		if (_column < _firstColumn) {
			// scroll horizontally
			if (_scrollH == ScrollType.Skip) {
				// If scrolling left, go to the start of the line and let the next section do the work.
				if (_column + leftTabSpaces < _firstColumn)
					_firstColumn = 0;
			} else { // ScrollType.Step
				_firstColumn = _column + leftTabSpaces;
				if (_firstColumn <= 1)
					_firstColumn = 0;
			}
			shouldDraw = true;
		}

		// _firstColumn > 0 means the characters are shifted 1 to the right thanks to the line continuation symbol
		if (_column + leftTabSpaces - _firstColumn + (_firstColumn > 0 ? 1 : 0) >= _window.width - _lineNumbersWidth - 1) {
			// scroll horizontally
			if (_scrollH == ScrollType.Skip) {
				_firstColumn = _column + leftTabSpaces - (_window.width - _lineNumbersWidth) / 2;
			} else { // ScrollType.Step
				_firstColumn = _column + leftTabSpaces - (_window.width - _lineNumbersWidth) + 3;
			}
			shouldDraw = true;
		}

		if (_row < _firstVisible) {
			// scroll vertically
			if (_scrollV == ScrollType.Skip) {
				// If scrolling up, go to the first row and let the next section do the work.
				_firstVisible = 0;
			} else { // ScrollType.Step
				_firstVisible = _row;
				if (_firstVisible < 0)
					_firstVisible = 0;
			}
			shouldDraw = true;
		}

		if ((_row - _firstVisible) >= _window.height) {
			// scroll vertically
			if (_scrollV == ScrollType.Skip) {
				_firstVisible = _row - _window.height / 2;
			} else { // ScrollType.Step
				_firstVisible = _row - _window.height + 1;
			}
			if (_firstVisible >= _lines.length) {
				_firstVisible = _lines.length - 1;
			}
			shouldDraw = true;
		}

		if (shouldDraw) {
		  _window.redraw();
		}

		_formatIndex = _calculateFormatIndex(line, _column);

		// Is the caret on the screen?
		if ((_lineNumbersWidth + (_column - _firstColumn) >= _window.width) || ((_row - _firstVisible) >= _window.height)) {
			// The caret is outside of the bounds of the widget
		}
		else {
			// Move cursor to where the edit caret is
//			Console.position(_lineNumbersWidth + (_column - _firstColumn) + leftTabSpaces + (_firstColumn > 0 ? 1 : 0), _row - _firstVisible);

			// The caret is within the bounds of the widget
		}
	}

	int _calculateFormatIndex(LineInfo line, int column) {
		int formatIndex = 0;
		if (line.format !is null) {
			uint pos;
			for (uint i = 0; i < line.format.length; i++) {
				pos += line.format[i].len;
				if (pos >= column) {
					formatIndex = i;
					break;
				}
			}
		}
		return formatIndex;
	}

	void _calculateLineNumbersWidth() {
		if (_lineNumbers) {
			// The width of the maximum line (in decimal as a string)
			// summed with two for the ': '
			_lineNumbersWidth = Format.integer(_lines.length - 1, 10).length + 2;
		}
		else {
			_lineNumbers = 0;
		}
	}

	void _drawLine(uint lineNumber, ConsoleCanvas canvas) {
		canvas.position(0, lineNumber - _firstVisible);

		if (_lineNumbers) {
			if (_lineNumbersWidth == 0) {
				_calculateLineNumbersWidth();
			}
			char[] strLineNumber = Format.integer(lineNumber, 10);
			canvas.forecolor = _forecolorNumbers;
			canvas.backcolor = _backcolorNumbers;

			canvas.write(String.times(" ", _lineNumbersWidth - 2 - strLineNumber.length));
			canvas.write(strLineNumber);
			canvas.write(": ");
		}

		uint[] formatTabExtension;
		uint curFormat, untilNextFormat;

    auto line = cast(LineInfo)_lines.get(lineNumber);
		if (line.format !is null) {
			formatTabExtension.length = line.format.length;
			untilNextFormat = line.format[0].len;
		}

		char[] actualLine = line.value;
		char[] visibleLine = "";

		if (_tabWidth > 0) {
			for (uint i = 0; i < Unicode.utflen(actualLine); i++) {
				while (curFormat + 1 < formatTabExtension.length && untilNextFormat == 0) {
					++curFormat;
					untilNextFormat = line.format[curFormat].len;
				}
				if (curFormat < formatTabExtension.length)
					untilNextFormat--;
				char[] c = String.charAt(actualLine, i);
				if ("\t" == c) {
					uint tabSpaces = _tabWidth - visibleLine.length % _tabWidth;
					if (curFormat < formatTabExtension.length)
						formatTabExtension[curFormat] += tabSpaces - 1;
					visibleLine ~= String.times(" ", tabSpaces);
				} else {
					visibleLine ~= c;
				}
			}
		} else {
			visibleLine = actualLine;
		}

		uint pos = 0;
		// Make space for the line continuation symbol
		if (visibleLine.length > _firstColumn && _firstColumn > 0) {
			visibleLine = String.insertAt(visibleLine, " ", _firstColumn);
			pos++;
		}

		if (line.format is null) {
			// No formatting, this line is just a simple regular line
			canvas.forecolor = _forecolor;
			canvas.backcolor = _backcolor;
			if (_firstColumn >= line.value.length) {
			}
			else {
				canvas.write(String.substring(visibleLine, _firstColumn));
			}
		}
		else {
			// Splitting up the line due to formatting
			for (uint i = 0; i < line.format.length; i++) {
				canvas.forecolor = line.format[i].fgCol;
				canvas.backcolor = line.format[i].bgCol;
				uint formatLength = line.format[i].len + formatTabExtension[i];

				if (formatLength + pos < _firstColumn) {
					// draw nothing
				}
				else if (pos >= _firstColumn) {
					canvas.write(visibleLine[pos..pos + formatLength]);
				}
				else {
					canvas.write(visibleLine[_firstColumn..pos + formatLength]);
				}

				pos += formatLength;
			}
		}

		canvas.forecolor = _forecolor;
		canvas.backcolor = _backcolor;
		// Pad with spaces
		uint num = (visibleLine.length - _firstColumn);
		if (_firstColumn >= line.value.length) {
			num = _window.width - _lineNumbersWidth;
		}
		else if (num > _window.width - _lineNumbersWidth) {
			num = 0;
		}
		else {
			num = (_window.width - _lineNumbersWidth) - num;
		}
		
		if (num != 0) {
			canvas.write(String.times(" ", num));
		}

		// Output the necessary line continuation symbols.
		canvas.forecolor = Color.White;
		canvas.backcolor = _backcolor;
		if (visibleLine.length > _firstColumn && _firstColumn > 0) {
			canvas.position(_lineNumbersWidth, lineNumber - _firstVisible);
			canvas.write(Unicode.toUtf8([_lineCont]));
		}

		if (visibleLine.length > _firstColumn && visibleLine.length - _firstColumn > _window.width - _lineNumbersWidth) {
			canvas.position(_window.width - 1, lineNumber - _firstVisible);
			canvas.write(Unicode.toUtf8([_lineCont]));
		}
	}

	void _drawEmptyLine(uint lineNumber, ConsoleCanvas canvas) {
		canvas.position(0, lineNumber - _firstVisible);

		// Pad with spaces
		canvas.write(String.times(" ", _window.width));
	}

	bool _onDraw(ConsoleCanvas canvas) {
		// Draw each line and pad any remaining spaces
		uint i;

		for (i = _firstVisible; i < _lines.length && i < _firstVisible + _window.height; i++) {
			// Draw line
			_drawLine(i, canvas);
		}

		for (; i < _firstVisible + _window.height; i++) {
			_drawEmptyLine(i, canvas);
		}

    return true;
	}

	bool _onKeyDown(Key key) {
    auto line = cast(LineInfo)_lines.get(_row);

		switch (key.code) {
      case Key.Code.Return:
        LineInfo newLine = new LineInfo();
        newLine.value = String.substring(line.value, _column);

        // Splitting format field
        if (line.format !is null) {
          if (_column == 0) {
            // At the beginning of the line; shift the format to the new line
            newLine.format = line.format;
            line.format = null;
          } else if (_column == line.value.length) {
            // At the end of the line; formats remain unchanged
            newLine.format = null;
          } else {
            // In the middle of the line; current format may need cutting
            uint pos = 0;
            uint last;
            for (uint i = 0; i <= _formatIndex; i++) {
              last = pos;
              pos += line.format[i].len;
            }

            if (_column == pos) {
              // Clean break
              newLine.format = line.format[_formatIndex+1..$];
            } else {
              // Unclean break
              newLine.format = [line.format[_formatIndex].dup];
              newLine.format ~= line.format[_formatIndex+1..$];

              // Determine lengths for the format being cut
              newLine.format[0].len = pos - _column;
              line.format[_formatIndex].len = _column - last;
            }

            line.format = line.format[0.._formatIndex+1];
          }

          _formatIndex = 0;
        }

        _lines.add(cast(void*)newLine, _row + 1);
        line.value = String.substring(line.value, 0, _column);

        _column = 0;
        _row++;
        _lineColumn = _column;

        //onLineChanged(_row);

        _calculateLineNumbersWidth();

        _positionCaret();
        _window.redraw();
        break;
			case Key.Code.Backspace:
				if (_column == 0) {
					_row--;
					if (_row < 0) {
						_row = 0;
						break;
					}

          line = cast(LineInfo)_lines.get(_row);
          auto nextLine = cast(LineInfo)_lines.get(_row + 1);
					_column = line.value.length;

					line ~= nextLine.dup();

					LineInfo oldLine;
					oldLine = cast(LineInfo)_lines.remove(_row + 1);
          _calculateLineNumbersWidth();

					_lineColumn = _column;

					//onLineChanged(_row);

					_window.redraw();
					break;
				}
				else if (_column == 1) {
					line.value = String.substring(line.value, 1);
					if (line.format !is null) {
						// The first section has one less length
						if (line.format[0].len <= 1) {
							// The section has been destroyed
							if (line.format.length == 1) {
								line.format = null;
							}
							else {
								line.format = line.format[1..$];
							}
						}
						else {
							// Just subtract one
							line.format[0].len--;
						}
					}
				}
				else if (_column == line.value.length) {
					line.value = String.substring(line.value, 0, line.value.length - 1);
					// The last section has one less length
					if (line.format !is null) {
						if (line.format[$-1].len <= 1) {
							// The last section has been destroyed
							if (line.format.length == 1) {
								// All sections have been destroyed
								line.format = null;
							}
							else {
								line.format = line.format[0..$-1];
							}
						}
						else {
							// Just subtract one
							line.format[$-1].len--;
						}
					}
				}
				else {
					line.value = String.substring(line.value, 0, _column - 1) ~ String.substring(line.value, _column);
					// Reduce the count of the current format index
					if (line.format !is null) {
						if (line.format[_formatIndex].len <= 1) {
							// This format section has been depleted
							line.format = line.format[0.._formatIndex] ~ line.format[_formatIndex+1..$];
						}
						else {
							// Just subtract
							line.format[_formatIndex].len--;
						}
					}
				}

				_column--;
				_lineColumn = _column;

				//onLineChanged(_row);

				_window.redraw();
				break;
			case Key.Code.Delete:
				if (_column == line.value.length) {
					if (_row + 1 >= _lines.length) {
						// Last column of last row. Do nothing.
					} else {
						// Last column with more rows beneath, so suck next row up.
            auto nextLine = cast(LineInfo)_lines.get(_row + 1);
						line ~= nextLine.dup();

						auto oldLine = cast(LineInfo)_lines.remove(_row + 1);

						//onLineChanged(_row);

						_window.redraw();
					}
				} else {
					// Not the last column, so delete the character to the right.
					line.value = String.substring(line.value, 0, _column) ~ String.substring(line.value, _column + 1);

					if (line.format !is null) {
						_formatIndex = _calculateFormatIndex(line, _column + 1);
						if (line.format[_formatIndex].len < 2) {
							// This format section has been depleted
							line.format = line.format[0.._formatIndex] ~ line.format[_formatIndex+1..$];
						}
						else {
							// One fewer character with this format
							line.format[_formatIndex].len--;
						}
						_formatIndex = _calculateFormatIndex(line, _column);
					}

					_window.redraw();
				}
				break;

			case Key.Code.Left:
				_column--;
				if (_column < 0) {
					_row--;
					if (_row < 0) {
						_row = 0;
						_column = 0;
					}
					else {
            line = cast(LineInfo)_lines.get(_row);
						_column = line.value.length;
					}
				}

				_lineColumn = _column;
				_positionCaret();
				break;

			case Key.Code.Right:
				_column++;
				if (_column > line.value.length) {
					_row++;
					if (_row >= _lines.length) {
						_row = _lines.length - 1;
            line = cast(LineInfo)_lines.get(_row);

						_column = line.value.length;
						_lineColumn = _column;
					}
					else {
						_column = 0;
					}
				}

				_lineColumn = _column;
				_positionCaret();
				break;
			case Key.Code.Up:
				_row--;
				_column = _lineColumn;

				if (_row < 0) {
					_row = 0;
					_column = 0;
					_lineColumn = _column;
				}

        line = cast(LineInfo)_lines.get(_row);
				if (_column > line.value.length) {
					_column = line.value.length;
				}

				_positionCaret();
				break;

			case Key.Code.Down:
				_row++;
				_column = _lineColumn;

				if (_row >= _lines.length) {
					_row = _lines.length - 1;
					_column = line.value.length;
				}

        line = cast(LineInfo)_lines.get(_row);
				if (_column > line.value.length) {
					_column = line.value.length;
				}

				_positionCaret();
				break;

			case Key.Code.PageUp:
				_row -= _window.height;
				_firstVisible -= _window.height;

				if (_firstVisible < 0) {
					_firstVisible = 0;
				}

				if (_row < 0) {
					_row = 0;
					_column = 0;
					_lineColumn = _column;
				}

        line = cast(LineInfo)_lines.get(_row);
				if (_column > line.value.length) {
					_column = line.value.length;
				}

				_window.redraw();
				break;

			case Key.Code.PageDown:
				_row += _window.height;
				_firstVisible += _window.height;

				if (_firstVisible >= _lines.length) {
					_firstVisible = _lines.length - 1;
				}

				if (_row >= _lines.length) {
					_row = _lines.length - 1;
					_column = line.value.length;
				}

        line = cast(LineInfo)_lines.get(_row);
				if (_column > line.value.length) {
					_column = line.value.length;
				}

				_window.redraw();
				break;

			case Key.Code.End:
				_column = line.value.length;
				_lineColumn = _column;
				_positionCaret();
				break;

			case Key.Code.Home:
				_column = 0;
				_lineColumn = 0;
				_positionCaret();
				break;

			default:
				break;
		}

    return true;
	}

	bool _onKeyChar(dchar chr) {
    auto line = cast(LineInfo)_lines.get(_row);

		if (chr == 0x8) {
			// Ignore character generation for backspace
			return true;
		}
		else if (chr == 0xa) {
			// Ignore
			return true;
		}
		else if (chr == 0xd) {
			// Pressing enter
      return true;
		}

		// Normal character append

		line.value = String.substring(line.value, 0, _column) ~ Unicode.toUtf8([chr]) ~ String.substring(line.value, _column);

		// Increase the length of the current format index
		if (line.format !is null) {
			// Just add
			line.format[_formatIndex].len++;
		}

		_column++;
		_lineColumn = _column;

		//onLineChanged(_row);
		_positionCaret();
		_window.redraw();

    return true;
	}

public:
  this(int x, int y, uint width, uint height) {
    _forecolor = Color.LightGray;
    _backcolor = Color.DarkestGray;
    _forecolorNumbers = Color.Blue;
    _backcolorNumbers = Color.DarkestGray;

    _lines = new MutableList;
    LineInfo newItem = new LineInfo();
    newItem.value = "";

    _lines.add(cast(void*)newItem);

    _tabWidth = 4;
    _lineCont = '$';
    _scrollH = ScrollType.Skip;
    _scrollV = ScrollType.Skip;

    _row = 0;
    _column = 0;

    _window = new ConsoleWindow(x, y, width, height, Color.Green,
        &_onKeyDown, null, null, null, null, null, null, null,
        &_onDraw, null, null, null, null, null, &_onKeyChar);

    _window.visible = true;
  }

  // Properties //

  char[] text() {
    return _text.dup;
  }

  void text(char[] value) {
    _text = value.dup;
    _window.redraw();
  }

  bool lineNumbers() {
    return _lineNumbers;
  }

  void lineNumbers(bool value) {
    _lineNumbers = value;
    _window.redraw();
  }

  Color forecolorNumbers() {
    return _forecolorNumbers;
  }

  void forecolorNumbers(Color value) {
    _forecolorNumbers = value;
    _window.redraw();
  }

  Color backcolorNumbers() {
    return _backcolorNumbers;
  }

  void backcolorNumbers(Color value) {
    _backcolorNumbers = value;
    _window.redraw();
  }

  Color forecolor() {
    return _forecolor;
  }

  void forecolor(Color value) {
    _forecolor = value;
    _window.redraw();
  }

  Color backcolor() {
    return _backcolor;
  }

  void backcolor(Color value) {
    _backcolor = value;
    _window.redraw();
  }

  ConsoleWindow window() {
    return _window;
  }
}
