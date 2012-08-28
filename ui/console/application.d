module ui.console.application;

import keyboard.key;

import ui.console.window;
import ui.console.canvas;

import ui.console.event;

import text.unicode;
import text.string;

import drawing.color;

import text.format;

import geometry.rectangle;

version(Windows) {
}
else version (linux) {
  // Curses
  import binding.c;
  import Curses = binding.ncurses.ncurses;

  extern(C) char* getenv(char*);
  extern(C) int setlocale(int, char*);

  extern(C) int ioctl(int, int, ...);
  extern(C) void function(int) sigset(int, void function(int));

  static const int LC_ALL = 6;
  static const int LC_CTYPE = 0;

  static const int _IONBF = 0x2;

  static const int ISTRIP = 0000040;
  static const int INLCR  = 0000100;
  static const int IGNCR  = 0000200;
  static const int IXON   = 0002000;
  static const int IXOFF  = 0010000;

  static const int ECHO   = 0000010;
  static const int ICANON = 0000002;

  static const int SIGWINCH = 28;

  struct winsize {
    ushort ws_row;
    ushort ws_col;
    ushort ws_xpixel;
    ushort ws_ypixel;
  }

  struct termios {
    uint  c_iflag;
    uint  c_oflag;
    uint  c_cflag;
    uint  c_lflag;
    ubyte c_line;
    ubyte c_cc[32];
    uint  c_ispeed;
    uint  c_ospeed;
  }

  static termios _term_info_saved;
  static termios _term_info_working;

  static winsize _winsize_saved;
  static winsize _winsize_working;

  static const int TIOCGWINSZ = 0x5413;
  static const int TIOCSWINSZ = 0x5414;

  static const int TCGETS = 0x5401;
  static const int TCSETS = 0x5402;

  static int _x;
  static int _y;

  extern(C) static void _size_sig_handler(int signal) {
    ioctl(0, TIOCGWINSZ, &_winsize_working);

    _position(0, 0);
  }

  static void _savetty() {
    //set this so it prints even if it doesn't get a
    //new line...because that is annoying most of the
    //time in my opinion...otherwise, it will wait until
    //a new line is printed before printing the rest of
    //the line
    setvbuf (stdout, null, _IONBF, 0);
  }

  static void _initscr() {
    //set initial colors
    //will also clear the background to the
    //background color specified when 
    //clearScreen is called
    _setcolor(Color.Gray, Color.Black);

    //get terminal information
    ioctl(0, TCGETS, &_term_info_saved);

    //get the current terminal vars
    ioctl(0, TCGETS, &_term_info_working);

    //tell the terminal to echo anything
    //streamed from stdin
    _term_info_working.c_iflag &= (~(ISTRIP | INLCR | IGNCR | IXON | IXOFF));
    _term_info_working.c_lflag &= ~(ECHO | ICANON); //ISIG -- stops ctrl_c, ect
    ioctl(0, TCSETS, &_term_info_working);

    //direct the resize signal to the internal function
    sigset(SIGWINCH, &_size_sig_handler);

    //clear the screen, set cursor to top-left
    printf("\x1b[2J");
    printf("\x1b[0;0H");

    // Hide caret
    printf("\x1b[?25l");
  }

  static void _init() {
    _savetty();

    _initscr();

    //setlocale(LC_ALL, "UTF-8");
    //setlocale(LC_CTYPE, "UTF-8");

    setvbuf(stdout, null, _IONBF, 0);

    // Enable mouse movement (in case ncurses chokes and doesn't do it)
    printf("\x1B[?1002h");
    printf("\x1B[?1003h");
  }

  static void _uninit() {
    //return the terminal to its previous state
    ioctl(0, TCSETS, &_term_info_saved);
//    ioctl(0, TIOCSWINSZ, &_winsize_saved);

    //will reset the colors, goto top-left, and clear
    printf("\n\x1b[0m\x1b[0;0H\x1b[2J");
    
    printf("\x1b[?25h");
  }

  static uint _getWidth() {
    ioctl(0, TIOCGWINSZ, &_winsize_working);
    return _winsize_working.ws_col;
  }

  static uint _getHeight() {
    ioctl(0, TIOCGWINSZ, &_winsize_working);
    return _winsize_working.ws_row + 1;
  }

  static void _write(char[] str) {
    //lock();
    uint width  = _getWidth();
    uint height = _getHeight();

    char[] utf8 = str ~ "\0";

    for (uint i; i < utf8.length; i++) {
      if (utf8[i] == '\r' || utf8[i] == '\n' || utf8[i] == '\0') {
        if (Unicode.utflen(utf8[0..i]) + _x >= width) {
          utf8 = String.substring(utf8, 0, width - _x) ~ "\0";
          _x += width - _x;
        }
        else {
          utf8[i] = '\0';
          _x += Unicode.utflen(utf8[0..i]);
        }

        printf("%s\0".ptr, utf8.ptr);
        //unlock();
        return;
      }
    }
  }

  static void _position(int x, int y) {
    uint width  = _getWidth();
    uint height = _getHeight();

    if (x >= width) {
      x = width - 1;
    }

    if (y >= height) {
      y = height - 1;
    }

    if (x < 0) {
      x = 0;
    }

    if (y < 0) {
      y = 0;
    }

    _x = x;
    _y = y;

    //lock();
    printf("\x1b[%d;%dH", _y + 1, _x + 1);
    //unlock();
  }

  int _toNearestConsoleColor(Color clr) {
    int ret = 0;
    double mindistance = 100;

    // 16 colors or 256?

    static int[] colors = [
      0x000000, 0xAA0000, 0x00AA00, 0xAA5500, 0x0000AA, 0xAA00AA, 0x00AAAA,
      0xAAAAAA, 0x555555, 0xFF5555, 0x55FF55, 0xFFFF55, 0x5555FF, 0xFF55FF,
      0x55FFFF, 0xFFFFFF, 0x000000, 0x00005f, 0x000087, 0x0000af, 0x0000d7,
      0x0000ff, 0x005f00, 0x005f5f, 0x005f87, 0x005faf, 0x005fd7, 0x005fff,
      0x008700, 0x00875f, 0x008787, 0x0087af, 0x0087d7, 0x0087ff, 0x00af00,
      0x00af5f, 0x00af87, 0x00afaf, 0x00afd7, 0x00afff, 0x00d700, 0x00d75f,
      0x00d787, 0x00d7af, 0x00d7d7, 0x00d7ff, 0x00ff00, 0x00ff5f, 0x00ff87,
      0x00ffaf, 0x00ffd7, 0x00ffff, 0x5f0000, 0x5f005f, 0x5f0087, 0x5f00af,
      0x5f00d7, 0x5f00ff, 0x5f5f00, 0x5f5f5f, 0x5f5f87, 0x5f5faf, 0x5f5fd7,
      0x5f5fff, 0x5f8700, 0x5f875f, 0x5f8787, 0x5f87af, 0x5f87d7, 0x5f87ff,
      0x5faf00, 0x5faf5f, 0x5faf87, 0x5fafaf, 0x5fafd7, 0x5fafff, 0x5fd700,
      0x5fd75f, 0x5fd787, 0x5fd7af, 0x5fd7d7, 0x5fd7ff, 0x5fff00, 0x5fff5f,
      0x5fff87, 0x5fffaf, 0x5fffd7, 0x5fffff, 0x870000, 0x87005f, 0x870087,
      0x8700af, 0x8700d7, 0x8700ff, 0x875f00, 0x875f5f, 0x875f87, 0x875faf,
      0x875fd7, 0x875fff, 0x878700, 0x87875f, 0x878787, 0x8787af, 0x8787d7,
      0x8787ff, 0x87af00, 0x87af5f, 0x87af87, 0x87afaf, 0x87afd7, 0x87afff,
      0x87d700, 0x87d75f, 0x87d787, 0x87d7af, 0x87d7d7, 0x87d7ff, 0x87ff00,
      0x87ff5f, 0x87ff87, 0x87ffaf, 0x87ffd7, 0x87ffff, 0xaf0000, 0xaf005f,
      0xaf0087, 0xaf00af, 0xaf00d7, 0xaf00ff, 0xaf5f00, 0xaf5f5f, 0xaf5f87,
      0xaf5faf, 0xaf5fd7, 0xaf5fff, 0xaf8700, 0xaf875f, 0xaf8787, 0xaf87af,
      0xaf87d7, 0xaf87ff, 0xafaf00, 0xafaf5f, 0xafaf87, 0xafafaf, 0xafafd7,
      0xafafff, 0xafd700, 0xafd75f, 0xafd787, 0xafd7af, 0xafd7d7, 0xafd7ff,
      0xafff00, 0xafff5f, 0xafff87, 0xafffaf, 0xafffd7, 0xafffff, 0xd70000,
      0xd7005f, 0xd70087, 0xd700af, 0xd700d7, 0xd700ff, 0xd75f00, 0xd75f5f,
      0xd75f87, 0xd75faf, 0xd75fd7, 0xd75fff, 0xd78700, 0xd7875f, 0xd78787,
      0xd787af, 0xd787d7, 0xd787ff, 0xd7af00, 0xd7af5f, 0xd7af87, 0xd7afaf,
      0xd7afd7, 0xd7afff, 0xd7d700, 0xd7d75f, 0xd7d787, 0xd7d7af, 0xd7d7d7,
      0xd7d7ff, 0xd7ff00, 0xd7ff5f, 0xd7ff87, 0xd7ffaf, 0xd7ffd7, 0xd7ffff,
      0xff0000, 0xff005f, 0xff0087, 0xff00af, 0xff00d7, 0xff00ff, 0xff5f00,
      0xff5f5f, 0xff5f87, 0xff5faf, 0xff5fd7, 0xff5fff, 0xff8700, 0xff875f,
      0xff8787, 0xff87af, 0xff87d7, 0xff87ff, 0xffaf00, 0xffaf5f, 0xffaf87,
      0xffafaf, 0xffafd7, 0xffafff, 0xffd700, 0xffd75f, 0xffd787, 0xffd7af,
      0xffd7d7, 0xffd7ff, 0xffff00, 0xffff5f, 0xffff87, 0xffffaf, 0xffffd7,
      0xffffff, 0x080808, 0x121212, 0x1c1c1c, 0x262626, 0x303030, 0x3a3a3a,
      0x444444, 0x4e4e4e, 0x585858, 0x626262, 0x6c6c6c, 0x767676, 0x808080,
      0x8a8a8a, 0x949494, 0x9e9e9e, 0xa8a8a8, 0xb2b2b2, 0xbcbcbc, 0xc6c6c6,
      0xd0d0d0, 0xdadada, 0xe4e4e4, 0xeeeeee
    ];

    foreach(size_t idx, comparedColor; colors) {
      double red   = cast(double)((comparedColor >> 16) & 0xff) / cast(double)0xff;
      double green = cast(double)((comparedColor >>  8) & 0xff) / cast(double)0xff;
      double blue  = cast(double)((comparedColor >>  0) & 0xff) / cast(double)0xff;

      // Compare euclidian distance
      double distance = 0.0;
      double intermediate;

      intermediate  = red - clr.red;
      intermediate *= intermediate;

      distance += intermediate;

      intermediate  = green - clr.green;
      intermediate *= intermediate;

      distance += intermediate;

      intermediate  = blue - clr.blue;
      intermediate *= intermediate;

      distance += intermediate;

      // Omitting square root, it is unnecessary for comparison
      if (mindistance > distance) {
        mindistance = distance;
        ret = idx;
      }
    }

    return ret;
  }

  static void _setcolor(Color fg, Color bg) {
    int fgidx = _toNearestConsoleColor(fg);
    int bgidx = _toNearestConsoleColor(bg);

    //lock();
    printf("\x1B[38;5;%dm\0".ptr, fgidx);
    printf("\x1B[48;5;%dm\0".ptr, bgidx);
    //unlock();
  }

  static int _getChar() {
    int ret;
    while(true) {
      //lock();
      ret = getc(stdin);
      //unlock();
      if (ret != Curses.ERR) {
        break;
      }
    }

    return ret;
  }

  static uint _keyTranslation[Curses.KEY_MAX] = [
    ' ': Key.Code.Space,
    '\n': Key.Code.Return,
    '\r': Key.Code.Return,
    '\t': Key.Code.Tab,
    '\b': Key.Code.Backspace,
    127: Key.Code.Backspace,
    'a': Key.Code.A,
    'b': Key.Code.B,
    'c': Key.Code.C,
    'd': Key.Code.D,
    'e': Key.Code.E,
    'f': Key.Code.F,
    'g': Key.Code.G,
    'h': Key.Code.H,
    'i': Key.Code.I,
    'j': Key.Code.J,
    'k': Key.Code.K,
    'l': Key.Code.L,
    'm': Key.Code.M,
    'n': Key.Code.N,
    'o': Key.Code.O,
    'p': Key.Code.P,
    'q': Key.Code.Q,
    'r': Key.Code.R,
    's': Key.Code.S,
    't': Key.Code.T,
    'u': Key.Code.U,
    'v': Key.Code.V,
    'w': Key.Code.W,
    'x': Key.Code.X,
    'y': Key.Code.Y,
    'z': Key.Code.Z,
    'A': Key.Code.A,
    'B': Key.Code.B,
    'C': Key.Code.C,
    'D': Key.Code.D,
    'E': Key.Code.E,
    'F': Key.Code.F,
    'G': Key.Code.G,
    'H': Key.Code.H,
    'I': Key.Code.I,
    'J': Key.Code.J,
    'K': Key.Code.K,
    'L': Key.Code.L,
    'M': Key.Code.M,
    'N': Key.Code.N,
    'O': Key.Code.O,
    'P': Key.Code.P,
    'Q': Key.Code.Q,
    'R': Key.Code.R,
    'S': Key.Code.S,
    'T': Key.Code.T,
    'U': Key.Code.U,
    'V': Key.Code.V,
    'W': Key.Code.W,
    'X': Key.Code.X,
    'Y': Key.Code.Y,
    'Z': Key.Code.Z,
    '0': Key.Code.Zero,
    '1': Key.Code.One,
    '2': Key.Code.Two,
    '3': Key.Code.Three,
    '4': Key.Code.Four,
    '5': Key.Code.Five,
    '6': Key.Code.Six,
    '7': Key.Code.Seven,
    '8': Key.Code.Eight,
    '9': Key.Code.Nine,
    '`': Key.Code.SingleQuote,
    '~': Key.Code.SingleQuote,
    '!': Key.Code.One,
    '@': Key.Code.Two,
    '#': Key.Code.Three,
    '$': Key.Code.Four,
    '%': Key.Code.Five,
    '^': Key.Code.Six,
    '&': Key.Code.Seven,
    '*': Key.Code.Eight,
    '(': Key.Code.Nine,
    ')': Key.Code.Zero,
    '-': Key.Code.Minus,
    '_': Key.Code.Minus,
    '=': Key.Code.Equals,
    '+': Key.Code.Equals,
    '[': Key.Code.LeftBracket,
    '{': Key.Code.LeftBracket,
    ']': Key.Code.RightBracket,
    '}': Key.Code.RightBracket,
    ';': Key.Code.Semicolon,
    ':': Key.Code.Semicolon,
    '\'': Key.Code.Apostrophe,
    '"': Key.Code.Apostrophe,
    ',': Key.Code.Comma,
    '<': Key.Code.Comma,
    '>': Key.Code.Period,
    '.': Key.Code.Period,
    '/': Key.Code.Foreslash,
    '?': Key.Code.Foreslash,
    '\\': Key.Code.Backslash,
    '|': Key.Code.Backslash,
    Curses.KEY_DOWN: Key.Code.Down,
    Curses.KEY_UP: Key.Code.Up,
    Curses.KEY_LEFT: Key.Code.Left,
    Curses.KEY_RIGHT: Key.Code.Right,
    Curses.KEY_HOME: Key.Code.Home,
    Curses.KEY_BACKSPACE: Key.Code.Backspace,
    Curses.KEY_DC: Key.Code.Delete,
    Curses.KEY_F1: Key.Code.F1,
    Curses.KEY_F2: Key.Code.F2,
    Curses.KEY_F3: Key.Code.F3,
    Curses.KEY_F4: Key.Code.F4,
    Curses.KEY_F5: Key.Code.F5,
    Curses.KEY_F6: Key.Code.F6,
    Curses.KEY_F7: Key.Code.F7,
    Curses.KEY_F8: Key.Code.F8,
    Curses.KEY_F9: Key.Code.F9,
    Curses.KEY_F10: Key.Code.F10,
    Curses.KEY_F11: Key.Code.F11,
    Curses.KEY_F12: Key.Code.F12,
    Curses.KEY_F13: Key.Code.F13,
    Curses.KEY_F14: Key.Code.F14,
    Curses.KEY_F15: Key.Code.F15,
    Curses.KEY_F16: Key.Code.F16,
    Curses.KEY_NPAGE: Key.Code.PageDown,
    Curses.KEY_PPAGE: Key.Code.PageUp,
    Curses.KEY_ENTER: Key.Code.Return,
    Curses.KEY_END: Key.Code.End
  ];

  static void _consoleTranslateKey(ref ConsoleEvent.KeyInfo ky) {
    switch(ky.code) {
      case '~':
      case '!':
      case '@':
      case '#':
      case '$':
      case '%':
      case '^':
      case '&':
      case '*':
      case '(':
      case ')':
      case '_':
      case '+':
      case '{':
      case '}':
      case ':':
      case '"':
      case '<':
      case '>':
      case '|':
      case '?':
        ky.shift = true;
        break;
      default:
        if (ky.code >= 'A' && ky.code <= 'Z') {
          ky.shift = true;
        }
        else if (ky.code >= '0' && ky.code <= '9') {
          ky.shift = false;
        }
        break;
    }
    ky.code = _keyTranslation[ky.code];
  }

  static void _getModifiers(ref ConsoleEvent.KeyInfo key) {
    if (key.code == '2' || key.code == '4' || key.code == '6' || key.code == '8') {
      key.shift = true;
    }

    if (key.code == '3' || key.code == '4' || key.code == '7' || key.code == '8') {
      key.leftAlt = true;
      key.rightAlt = true;
      key.alt = true;
    }

    if (key.code == '5' || key.code == '6' || key.code == '7' || key.code == '8') {
      key.leftControl = true;
      key.rightControl = true;
      key.control = true;
    }

    if (key.shift || key.alt || key.control) {
      key.code = _getChar();
    }
  }

  //will return the next character pressed
  static ConsoleEvent.KeyInfo _getKey() {
    ConsoleEvent.KeyInfo ret;

    ubyte[18] tmp;
    uint count;

    ret.code = _getChar();

    if (ret.code != 0x1B) {
      // Not an escape sequence

      if (ret.code == Curses.KEY_MOUSE || ret.code == Curses.KEY_RESIZE || ret.code == Curses.KEY_EVENT || ret.code >= Curses.KEY_MAX) {
        return ret;
      }

      if (ret.code == 127 || ret.code == 8 || ret.code == 9 || ret.code == 13 || ret.code == 10) {
      }
      else if (ret.code < 26) {
        // For ctrl+char
        ret.leftControl = true;
        ret.rightControl = true;
        ret.control = true;
        ret.code = Key.Code.A + ret.code - 1;
        return ret;
      }
      else if (ret.code >= 281 && ret.code <= 292) {
        // For F5-F16:
        ret.code -= 12;
        ret.shift = true;
      }
      else if (ret.code >= 293 && ret.code <= 304) {
        ret.code -= 24;
        ret.leftControl = true;
        ret.rightControl = true;
      }
      else if (ret.code >= 305 && ret.code <= 316) {
        ret.code -= 36;
        ret.leftControl = true;
        ret.rightControl = true;
        ret.shift = true;
      }
      else if (ret.code >= 317 && ret.code <= 328) {
        ret.code -= 48;
        ret.leftAlt = true;
        ret.rightAlt = true;
      }

      _consoleTranslateKey(ret);

      return ret;
    }

    // Escape sequence...
    ret.code = _getChar();

    // Get extended commands
    if (ret.code == 0x1B) {
      // ESCAPE ESCAPE -> Escape
      ret.code = Key.Code.Escape;
    }
    else if (ret.code == '[') {
      ret.code = _getChar();
      if (ret.code == '1') {
        ret.code = _getChar();
        if (ret.code == '~') {
          ret.code = Key.Code.Home;
        }
        else if (ret.code == '#') {
          ret.code = _getChar();
          if (ret.code == '~') {
            ret.code = Key.Code.F5;
          }
          else if (ret.code == ';') {
            ret.code = _getChar();
            if (ret.code == '2') {
              ret.shift = true;
              ret.code = Key.Code.F5;
            }
          }
        }
        else if (ret.code == '7') {
          ret.code = _getChar();
          if (ret.code == '~') {
            ret.code = Key.Code.F6;
          }
          else if (ret.code == ';') {
            ret.code = _getChar();
            if (ret.code == '2') {
              ret.shift = true;
              ret.code = Key.Code.F6;
            }
          }
        }
        else if (ret.code == ';') {
          // Arrow Keys
          ret.code = _getChar();
          _getModifiers(ret);

          if (ret.code == 'A') {
            ret.code = Key.Code.Up;
          }
          else if (ret.code == 'B') {
            ret.code = Key.Code.Down;
          }
          else if (ret.code == 'C') {
            ret.code = Key.Code.Right;
          }
          else if (ret.code == 'D') {
            ret.code = Key.Code.Left;
          }
        }
        else {
          ret.code = _getChar();
        }
      }
      else if (ret.code == '2') {
        ret.code = _getChar();
        if (ret.code == '~') {
        }
        else if (ret.code == ';') {
          // Alt + Insert
          ret.code = _getChar();
          _getModifiers(ret);
          if (ret.code == '~') {
            ret.code = Key.Code.Insert;
          }
        }
      }
      else if (ret.code == '3') {
        ret.code = _getChar();
      }
      else if (ret.code == '4') {
        ret.code = _getChar();
      }
      else if (ret.code == '5') {
        ret.code = _getChar();
      }
      else if (ret.code == '6') {
        ret.code = _getChar();
      }
      else if (ret.code == 'A') {
        ret.code = Key.Code.Up;
      }
      else if (ret.code == 'B') {
        ret.code = Key.Code.Down;
      }
      else if (ret.code == 'C') {
        ret.code = Key.Code.Right;
      }
      else if (ret.code == 'D') {
        ret.code = Key.Code.Left;
      }
      else {
      }
    }
    else if (ret.code == 'O') {
      ret.code = _getChar();

      // F1, F2, F3, F4
      if (ret.code == '1') {
        ret.code = _getChar();
        if (ret.code == ';') {
          ret.code = _getChar();
          _getModifiers(ret);

          if (ret.code == 'P') {
            ret.code = Key.Code.F1;
          }
          else if (ret.code == 'Q') {
            ret.code = Key.Code.F2;
          }
          else if (ret.code == 'R') {
            ret.code = Key.Code.F3;
          }
          else if (ret.code == 'S') {
            ret.code = Key.Code.F4;
          }
        }
      }
      else if (ret.code == 'H') {
        ret.code = Key.Code.Home;
      }
      else if (ret.code == 'F') {
        ret.code = Key.Code.End;
      }
      else if (ret.code == 0x80) {
        ret.code = Key.Code.F1;
      }
      else if (ret.code == 0x81) {
        ret.code = Key.Code.F2;
      }
      else if (ret.code == 0x82) {
        ret.code = Key.Code.F3;
      }
      else if (ret.code == 0x83) {
        ret.code = Key.Code.F4;
      }
    }
    else {
      // Alt + Char
      ret.rightAlt = true;
      ret.leftAlt = true;
      ret.alt = true;
      _consoleTranslateKey(ret);
    }

    return ret;
  }

  static ConsoleEvent _nextEvent_it() {
    static int lastPressed;
    static bool dragOver = true;
    static ConsoleEvent.MouseInfo oldMouse;

    // IO block
    ulong ky;
    uint tky;

    ConsoleEvent.KeyInfo   key;
    ConsoleEvent.MouseInfo mouse;
    ConsoleEvent.Type      type;

    key = _getKey();

    if (key.code == Curses.KEY_RESIZE) {
      type = ConsoleEvent.Type.Size;
      return new ConsoleEvent(type);
    }
    else if (key.code == Curses.KEY_MOUSE) {
      Curses.MEVENT event;
      //if (Curses.getmouse(&event) == Curses.ERR) {
        // try again
      //  return null;
      //}

      mouse.x = event.x;
      mouse.y = event.y;

      auto clickedMasks = [
        Curses.BUTTON1_CLICKED | Curses.BUTTON1_DOUBLE_CLICKED
                               | Curses.BUTTON1_TRIPLE_CLICKED,
        Curses.BUTTON2_CLICKED | Curses.BUTTON2_DOUBLE_CLICKED
                               | Curses.BUTTON2_TRIPLE_CLICKED,
        Curses.BUTTON3_CLICKED | Curses.BUTTON3_DOUBLE_CLICKED
                               | Curses.BUTTON3_TRIPLE_CLICKED
      ];

      auto releasedMasks = [
        Curses.BUTTON1_RELEASED,
        Curses.BUTTON2_RELEASED,
        Curses.BUTTON3_RELEASED
      ];

      auto pressedMasks = [
        Curses.BUTTON1_PRESSED,
        Curses.BUTTON2_PRESSED,
        Curses.BUTTON3_PRESSED
      ];

      if (event.bstate & (Curses.BUTTON4_RELEASED | Curses.BUTTON4_CLICKED |
                    Curses.BUTTON4_DOUBLE_CLICKED | Curses.BUTTON4_TRIPLE_CLICKED)) {
        // Mouse drag complete
        type = ConsoleEvent.Type.MouseUp;
        dragOver = true;
        return new ConsoleEvent(type, mouse);
      }

      if (event.bstate & Curses.BUTTON4_PRESSED) {
        // Mouse drag
        if (dragOver) {
          type = ConsoleEvent.Type.MouseDown;
          dragOver = false;
          return new ConsoleEvent(type, mouse);
        }
      }

      foreach (size_t idx, mask; releasedMasks) {
        if ((event.bstate & mask) || (event.bstate & clickedMasks[idx])) {
          type = ConsoleEvent.Type.MouseUp;
          dragOver = false;
          return new ConsoleEvent(type, mouse);
        }
      }

      foreach (size_t idx, mask; pressedMasks) {
        if (event.bstate & mask) {
          type = ConsoleEvent.Type.MouseDown;
          dragOver = true;
          lastPressed = idx;
          return new ConsoleEvent(type, mouse);
        }
      }

      if (mouse.x != oldMouse.x || mouse.y != oldMouse.y) {
        oldMouse.x = mouse.x;
        oldMouse.y = mouse.y;

        type = ConsoleEvent.Type.MouseMove;
        return new ConsoleEvent(type, mouse);
      }

      return null;
    }

    type = ConsoleEvent.Type.KeyDown;
    auto keyObject = new Key(cast(Key.Code)key.code, key.leftAlt,     key.rightAlt,
                                       key.leftControl, key.rightControl,
                                       key.shift,       key.capsLock);
    return new ConsoleEvent(type, keyObject);
  }

  static ConsoleEvent _nextEvent() {
    ConsoleEvent event;
    for(;;) {
      event = _nextEvent_it();
      if (event !is null) {
        break;
      }
    }
    return event;
  }

  void _exit(uint code) {
    _uninit();
    exit(code);
  }
}
else {
  static assert(false, "I do not know how to compile the ConsoleApplication class.");
}

final class ConsoleApplication {
private:
  ConsoleWindow _window;
  ConsoleCanvas _canvas;

  int _width;
  int _height;

  bool _allowRedraw;
  bool _needRedraw;
  bool _running;

  Color _fgcolor;
  Color _bgcolor;

  void _eventLoop() {
    _running = true;
    _allowRedraw = true;

    _redraw();

    for(;;) {
      auto event = _nextEvent();

      _allowRedraw = false;
      _window.onEvent(event);
      _allowRedraw = true;

      if (_needRedraw) {
        _needRedraw = false;
        _redraw();
      }
      if (event.type == ConsoleEvent.Type.Close) {
        break;
      }
    }
  }

  bool _redraw() {
    if (!_allowRedraw) {
      _needRedraw = true;
      return false;
    }

    _canvas.contextClear();
    _canvas.clipClear();

    _window.onDrawChildren(_canvas);
    _window.onDraw(_canvas);

    _canvas.contextClear();
    _canvas.clipClear();

    _canvas.position(0, 0);

    // swap buffers?
    return true;
  }

  uint _getWidth() {
    return ._getWidth();
  }

  uint _getHeight() {
    return ._getHeight();
  }

  void _position(int x, int y) {
    ._position(x, y);
  }

  void _write(char[] str) {
    ._write(str);
  }

  void _forecolor(Color clr) {
    _fgcolor = clr;
    _setcolor(_fgcolor, _bgcolor);
  }

  void _backcolor(Color clr) {
    _bgcolor = clr;
    _setcolor(_fgcolor, _bgcolor);
  }

  bool _onKeyDown(Key key) {
    if (key.code == Key.Code.Q) {
      exit(0);
    }
    return false;
  }

public:
  this(Color backcolor) {
    _init();

    _fgcolor = Color.Gray;
    _bgcolor = Color.Black;

    _width  = _getWidth();
    _height = _getHeight();

    _canvas = new ConsoleCanvas(&_getWidth,
        &_getHeight,
        &_position,
        &_write,
        &_forecolor,
        &_backcolor);

    _window = new ConsoleWindow(0, 0, _width, _height, backcolor,
        &_onKeyDown, null, null, null, null, null, null, null, null, null,
        &_redraw, null, null, null, null);

    _window.visible = true;
  }

  int run() {
    _eventLoop();

    _uninit();

    return 0;
  }

  void exit(uint code) {
    _exit(code);
  }

  ConsoleWindow window() {
    return _window;
  }
}
