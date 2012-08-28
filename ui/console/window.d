module ui.console.window;

import ui.console.canvas;
import ui.console.event;

import system.keyboard;

import drawing.color;

import text.string;

import geometry.rectangle;

import keyboard.key;

import binding.c;

import text.unicode;

final class ConsoleWindow {
private:
  int _x;
  int _y;
  int _width;
  int _height;

  dchar _dead;

  bool _visible;
  bool _focused;
  bool _hovered;

  bool _needsRedraw;
  bool _dirty;

  bool _isTopMost;
  bool _isBottomMost;

  Color _bg;

  ConsoleWindow _parent;

  ulong _count = 0;

  // Window list
  ConsoleWindow _head;           // The head of the list
  ConsoleWindow _topMostHead;    // The subsection where the top most end
  ConsoleWindow _bottomMostHead; // The subsection where the bottom most start

  // Sibling list
  ConsoleWindow _next;
  ConsoleWindow _prev;

  ConsoleWindow _focusedWindow;
  ConsoleWindow _dragWindow;

  ConsoleEvent.MouseInfo _mouse;

  bool delegate(Key)           _onKeyDown;
  bool delegate(Key)           _onKeyUp;
  bool delegate()              _onMouseDown;
  bool delegate()              _onMouseUp;
  bool delegate()              _onScrollX;
  bool delegate()              _onScrollY;
  bool delegate()              _onDrag;
  bool delegate()              _onHover;
  bool delegate(ConsoleCanvas) _onDraw;
  bool delegate(ConsoleCanvas) _onDrawChildren;
  bool delegate()              _onNeedsRedraw;
  bool delegate()              _onResize;
  bool delegate()              _onGotFocus;
  bool delegate()              _onLostFocus;
  bool delegate(dchar)         _onKeyChar;

  void _dispatchKeyDown(Key key) {
    onKeyDown(key);

    // Pass this down to the focused window
    if (_focusedWindow !is null) {
      _focusedWindow._dispatchKeyDown(key);
    }
  }

  void _dispatchKeyChar(dchar chr) {
    onKeyChar(chr);

    // Pass this down to the focused window
    if (_focusedWindow !is null) {
      _focusedWindow._dispatchKeyChar(chr);
    }
  }

  void _dispatchPrimaryDown(ref ConsoleEvent.MouseInfo mouse) {
    // Look at passing this message down
    ConsoleWindow window = child();
    if (window is null) {
      return;
    }

    ConsoleWindow start = window;

    for(;;) {
      if (window.left <= mouse.x
          && (window.left + window.width) > mouse.x
          && window.top <= mouse.y
          && (window.top + window.height) > mouse.y
          && (window.visible)) {

        int xdiff = window.left;
        int ydiff = window.top;
        mouse.x -= xdiff;
        mouse.y -= ydiff;

        _dragWindow = window;

        if (_focusedWindow !is window) {
          if (_focusedWindow !is null) {
            _focusedWindow.onLostFocus();
          }
          _focusedWindow = window;
          _focusedWindow.onGotFocus();
        }

        window._dispatchPrimaryDown(mouse);

        mouse.x += xdiff;
        mouse.y += ydiff;
        return;
      }

      window = window.next;
      if (window is start) {
        return;
      }
    }

    // End up handling it in the main window
    onMouseDown();
  }

  void _dispatchPrimaryUp(ref ConsoleEvent.MouseInfo mouse) {
    // Look at passing this message down
    if (_dragWindow !is null) {

      int xdiff = _dragWindow.left;
      int ydiff = _dragWindow.top;
      mouse.x -= xdiff;
      mouse.y -= ydiff;

      _dragWindow._dispatchPrimaryUp(mouse);

      mouse.x += xdiff;
      mouse.y += ydiff;

      _dragWindow = null;
      return;
    }

    ConsoleWindow window = child();
    if (window is null) {
      return;
    }

    ConsoleWindow start = window;

    for(;;) {
      if (window.left <= mouse.x
          && (window.left + window.width) > mouse.x
          && window.top <= mouse.y
          && (window.top + window.height) > mouse.y
          && (window.visible)) {

        int xdiff = window.left;
        int ydiff = window.top;
        mouse.x -= xdiff;
        mouse.y -= ydiff;

        window._dispatchPrimaryUp(mouse);

        mouse.x += xdiff;
        mouse.y += ydiff;
        return;
      }

      window = window.next;
      if (window is start) {
        return;
      }
    }

    // End up handling it in the main window
    onMouseUp();
  }

  void _dispatchScrollX(ref ConsoleEvent.MouseInfo mouse, int delta) {
    // Look at passing this message down
    ConsoleWindow window = child();
    if (window is null) {
      return;
    }

    ConsoleWindow start = window;

    for(;;) {
      if (window.left <= mouse.x
          && (window.left + window.width) > mouse.x
          && window.top <= mouse.y
          && (window.top + window.height) > mouse.y
          && (window.visible)) {

        int xdiff = window.left;
        int ydiff = window.top;
        mouse.x -= xdiff;
        mouse.y -= ydiff;

        window._dispatchScrollX(mouse, delta);

        mouse.x += xdiff;
        mouse.y += ydiff;
        return;
      }

      window = window.next;
      if (window is start) {
        return;
      }
    }

    // End up handling it in the main window
    onScrollX();
  }

  void _dispatchScrollY(ref ConsoleEvent.MouseInfo mouse, int delta) {
    // Look at passing this message down
    ConsoleWindow window = child();
    if (window is null) {
      return;
    }

    ConsoleWindow start = window;

    for(;;) {
      if (window.left <= mouse.x
          && (window.left + window.width) > mouse.x
          && window.top <= mouse.y
          && (window.top + window.height) > mouse.y
          && (window.visible)) {

        int xdiff = window.left;
        int ydiff = window.top;
        mouse.x -= xdiff;
        mouse.y -= ydiff;

        window._dispatchScrollY(mouse, delta);

        mouse.x += xdiff;
        mouse.y += ydiff;
        return;
      }

      window = window.next;
      if (window is start) {
        return;
      }
    }

    // End up handling it in the main window
    onScrollY();
  }

  final void _dispatchDrag(ref ConsoleEvent.MouseInfo mouse) {
    // Look at passing this message down
    if (_dragWindow !is null) {
      int xdiff = _dragWindow.left;
      int ydiff = _dragWindow.top;

      mouse.x -= xdiff;
      mouse.y -= ydiff;

      _dragWindow._dispatchDrag(mouse);

      mouse.x += xdiff;
      mouse.y += ydiff;
      return;
    }

    // End up handling it in the main window
    onDrag();
  }

  void _dispatchHover(ref ConsoleEvent.MouseInfo mouse) {
    // Look at passing this message down
    ConsoleWindow window = child();
    if (window is null) {
      return;
    }

    ConsoleWindow start = window;

    for(;;) {
      if (window.left <= mouse.x
          && (window.left + window.width) > mouse.x
          && window.top <= mouse.y
          && (window.top + window.height) > mouse.y
          && (window.visible)) {

        int xdiff = window.left;
        int ydiff = window.top;
        mouse.x -= xdiff;
        mouse.y -= ydiff;

        window._dispatchHover(mouse);

        mouse.x += xdiff;
        mouse.y += ydiff;
        return;
      }

      window = window.next;
      if (window is start) {
        return;
      }
    }

    // End up handling it in the main window
    onHover();
  }

  bool _redraw() {
    if (!_visible) {
      return false;
    }

    _needsRedraw = true;
    if (_onNeedsRedraw) {
      _onNeedsRedraw();
    }

    if (_parent !is null) {
      return _parent._redraw();
    }

    return true;
  }

public:
  this(int x, int y, uint width, uint height, Color backcolor) {
    this(x, y, width, height, backcolor,
         null, null, null, null, null, null, null, null, null, null,
         null, null, null, null, null);
  }

  this(int x, int y, uint width, uint height, Color backcolor,
       bool delegate(Key)           onKeyDown,
       bool delegate(Key)           onKeyUp,
       bool delegate()              onMouseDown,
       bool delegate()              onMouseUp,
       bool delegate()              onScrollX,
       bool delegate()              onScrollY,
       bool delegate()              onDrag,
       bool delegate()              onHover,
       bool delegate(ConsoleCanvas) onDraw,
       bool delegate(ConsoleCanvas) onDrawChildren,
       bool delegate()              onNeedsRedraw,
       bool delegate()              onResize,
       bool delegate()              onGotFocus,
       bool delegate()              onLostFocus,
       bool delegate(dchar)         onKeyChar) {

    _dead   = '\0';

    _x      = x;
    _y      = y;
    _width  = width;
    _height = height;
    _bg     = backcolor;

    _onKeyDown      = onKeyDown;
    _onKeyUp        = onKeyUp;
    _onMouseDown    = onMouseDown;
    _onMouseUp      = onMouseUp;
    _onScrollX      = onScrollX;
    _onScrollY      = onScrollY;
    _onDrag         = onDrag;
    _onHover        = onHover;
    _onDraw         = onDraw;
    _onDrawChildren = onDrawChildren;
    _onNeedsRedraw  = onNeedsRedraw;
    _onResize       = onResize;
    _onGotFocus     = onGotFocus;
    _onLostFocus    = onLostFocus;
    _onKeyChar      = onKeyChar;
  }

  // Properties //

  Color backcolor() {
    return _bg;
  }

  void backcolor(Color value) {
    _bg = value;
  }

  bool visible() {
    return _visible;
  }

  void visible(bool value) {
    _visible = value;
  }

  bool focused() {
    return _focused;
  }
  
  void focused(bool value) {
    _focused = value;
  }

  ConsoleWindow parent() {
    return _parent;
  }

  ConsoleWindow child() {
    ConsoleWindow ret = _topMostHead;

    if (_topMostHead is null) {
      ret = _head;
    }

    if (_head is null) {
      ret = _bottomMostHead;
    }

    return ret;
  }

  ConsoleWindow next() {
    ConsoleWindow ret = _next;

    if (_isTopMost) {
      if (ret is parent._topMostHead) {
        ret = parent._head;
        if (ret is null) {
          ret = parent._bottomMostHead;
        }
        if (ret is null) {
          return parent._topMostHead;
        }
      }
    }
    else if (_isBottomMost) {
      if (ret is parent._bottomMostHead) {
        ret = parent._topMostHead;
        if (ret is null) {
          ret = parent._head;
        }
        if (ret is null) {
          return parent._bottomMostHead;
        }
      }
    }
    else {
      if (ret is parent._head) {
        ret = parent._bottomMostHead;
        if (ret is null) {
          ret = parent._topMostHead;
        }
        if (ret is null) {
          return parent._head;
        }
      }
    }

    return ret;
  }

  ConsoleWindow prev() {
    // TODO: Make this the true opposite of next()
    ConsoleWindow ret = _prev;

    if (_isTopMost) {
      if (this is parent._topMostHead) {
        ret = parent._bottomMostHead;
      }
    }
    else if (_isBottomMost) {
      if (this is parent._bottomMostHead) {
        ret = parent._head;
      }
    }
    else {
      if (this is parent._head) {
        ret = parent._topMostHead;
      }
    }

    return ret;
  }

  int left() {
    return _x;
  }

  int top() {
    return _y;
  }

  uint width() {
    return _width;
  }

  void width(uint value) {
    _width = value;
  }

  uint height() {
    return _height;
  }

  void height(uint value) {
    _height = value;
  }

  int clientWidth() {
    return _width;
  }

  void clientWidth(int value) {
    _width = value;
  }

  int clientHeight() {
    return _height;
  }

  void clientHeight(int value) {
    _height = value;
  }

  // Methods //

  void add(ConsoleWindow window) {
    if (window !is null && window._parent is null && window._next is null) {
      if (_head is null) {
        window._next = window;
        window._prev = window;
      }
      else {
        window._prev = _head._prev;
        window._next = _head;

        _head._prev._next = window;
        _head._prev = window;
      }

      // Set as new head
      _head = window;

      window._parent = this;
      window._dirty = true;

      // Focus on this window (if it is visible)
      if (window.visible) {
        _focusedWindow = window;
      }

      _count++;

      window.redraw();
    }
  }

  // ConsoleEvents //

  bool onKeyDown(Key key) {
    if (_onKeyDown) {
      return _onKeyDown(key);
    }
    return false;
  }

  bool onKeyUp(Key key) {
    if (_onKeyUp) {
      return _onKeyUp(key);
    }
    return false;
  }

  bool onMouseDown() {
    if (_onMouseDown) {
      return _onMouseDown();
    }
    return false;
  }

  bool onMouseUp() {
    if (_onMouseUp) {
      return _onMouseUp();
    }
    return false;
  }

  bool onScrollX() {
    if (_onScrollX) {
      return _onScrollX();
    }
    return false;
  }

  bool onScrollY() {
    if (_onScrollY) {
      return _onScrollY();
    }
    return false;
  }

  bool onDrag() {
    if (_onDrag) {
      return _onDrag();
    }
    return false;
  }

  bool onHover() {
    if (_onHover) {
      return _onHover();
    }
    return false;
  }

  bool onDraw(ConsoleCanvas canvas) {
    if (_onDraw) {
      return _onDraw(canvas);
    }
    else {
      // Default behavior

      // Paint the background of the window
      if (_bg.alpha == 0.0) {
        return false;
      }

      canvas.backcolor = _bg;

      int amt = _width;
      if (amt > canvas.width) {
        amt = canvas.width;
      }
      if (amt < 0) {
        return false;
      }

      const char[] bgchr = " ";

      char[] line = String.times(bgchr, amt);
      for(uint i = 0; i < this.height; i++) {
        canvas.position(0, i);
        canvas.write(line);
      }
    }
    return false;
  }

  bool onDrawChildren(ConsoleCanvas canvas) {
    if (_onDrawChildren) {
      return _onDrawChildren(canvas);
    }
    else {
      // Subwindows
      ConsoleWindow window = child();
      if (window is null) {
        return true;
      }

      ConsoleWindow start = window;

      for(;;) {
        if (window.visible) {
          Rectangle rt;

          // If this window is dirty, then we must also redraw all child windows
          if (this._dirty) {
            window._needsRedraw = true;
            window._dirty = true;
          }

          double rt_width, rt_height, rt_x, rt_y;

          if (window._needsRedraw) {
            window._needsRedraw = false;

            // Draw
            canvas.clipSave();

            // Clip the regions around the subwindow temporarily
            rt_width  = window.left;
            rt_height = _height;
            rt_x = 0;
            rt_y = 0;

            rt_x += (rt_width / 2.0);
            rt_y += (rt_height / 2.0);

            rt = new Rectangle(rt_x, rt_y, rt_width, rt_height);
            canvas.clipRectangle(rt);

            rt_width = window.width;
            rt_height = window.top;
            rt_x = window.left;
            rt_y = 0;

            rt_x += (rt_width / 2.0);
            rt_y += (rt_height / 2.0);

            rt = new Rectangle(rt_x, rt_y, rt_width, rt_height);
            canvas.clipRectangle(rt);

            rt_width = window.width;
            rt_height = _height - window.height - window.top;
            rt_x = window.left;
            rt_y = window.top + window.height;

            rt_x += (rt_width / 2.0);
            rt_y += (rt_height / 2.0);

            rt = new Rectangle(rt_x, rt_y, rt_width, rt_height);
            canvas.clipRectangle(rt);

            rt_width = _width - window.width - window.left;
            rt_height = _height;
            rt_x = window.left + window.width;
            rt_y = 0;

            rt_x += (rt_width / 2.0);
            rt_y += (rt_height / 2.0);

            rt = new Rectangle(rt_x, rt_y, rt_width, rt_height);
            canvas.clipRectangle(rt);

            // Tell the canvas where the top-left corner is
            canvas.contextPush(window.left, window.top);

            window.onDrawChildren(canvas);

            if (window._dirty) {
              canvas.position(0,0);
              window.onDraw(canvas);
              window._dirty = false;
            }

            // Reset context
            canvas.contextPop();

            canvas.clipRestore();
          }

          // Clip this window
          rt_width  = window.width;
          rt_height = window.height;
          rt_x = window.left;
          rt_y = window.top;

          rt_x += (rt_width / 2.0);
          rt_y += (rt_height / 2.0);

          rt = new Rectangle(rt_x, rt_y, rt_width, rt_height);
          canvas.clipRectangle(rt);
        }

        window = window.next;
        if (window is start) {
          return true;
        }
      }
    }

    return false;
  }
 
  bool onResize() {
    if (_onResize) {
      return _onResize();
    }
    return false;
  }

  bool onGotFocus() {
    if (_onGotFocus) {
      return _onGotFocus();
    }
    return false;
  }

  bool onLostFocus() {
    if (_onLostFocus) {
      return _onLostFocus();
    }
    return false;
  }

  bool onKeyChar(dchar chr) {
    if (_onKeyChar) {
      return _onKeyChar(chr);
    }
    return false;
  }

  bool onEvent(ConsoleEvent event) {
    switch(event.type) {
      case ConsoleEvent.Type.KeyDown:
        auto key = event.key;

        // Translate key
        auto keyboard = new Keyboard();

        _dispatchKeyDown(key);

        if (keyboard.translator.isDead(key)) {
          _dead = keyboard.translator.translate(key, '\0');
        }
        else {
          dchar chr = keyboard.translator.translate(key, _dead);
          _dead = '\0';

          if (chr != '\0') {
            _dispatchKeyChar(chr);
          }
        }
        break;

      case ConsoleEvent.Type.MouseDown:
        _mouse.x = event.mouseInfo.x;
        _mouse.y = event.mouseInfo.y;
        _mouse.clicks[] = event.mouseInfo.clicks[];
        _dispatchPrimaryDown(_mouse);
        break;

      case ConsoleEvent.Type.MouseUp:
        _mouse.x = event.mouseInfo.x;
        _mouse.y = event.mouseInfo.y;
        _dispatchPrimaryUp(_mouse);
        _mouse.clicks[event.aux] = 0;
        break;

      case ConsoleEvent.Type.MouseWheelX:
        _mouse.x = event.mouseInfo.x;
        _mouse.y = event.mouseInfo.y;
        _dispatchScrollX(_mouse, event.aux);
        break;

      case ConsoleEvent.Type.MouseWheelY:
        _mouse.x = event.mouseInfo.x;
        _mouse.y = event.mouseInfo.y;
        _dispatchScrollY(_mouse, event.aux);
        break;

      case ConsoleEvent.Type.MouseMove:
        _mouse.x = event.mouseInfo.x;
        _mouse.y = event.mouseInfo.y;
        if (_mouse.clicks[0] > 0 || _mouse.clicks[1] > 0 || _mouse.clicks[2] > 0) {
          _dispatchDrag(_mouse);
        }
        else {
          _dispatchHover(_mouse);
        }
        break;

      case ConsoleEvent.Type.Size:
        break;

      default:
        break;
    }
    return true;
  }

  void redraw() {
    if (!_visible) {
      return;
    }

    _dirty = true;
    _redraw();
  }
}
