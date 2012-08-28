module ui.console.event;

import keyboard.key;

final class ConsoleEvent {
public:
  enum Type {
    KeyDown,
    KeyUp,
    MouseDown,
    MouseUp,
    MouseMove,
    MouseWheelX,
    MouseWheelY,
    Size,
    Close
  }

  struct KeyInfo {
    uint code;
    uint scan;

    bool leftAlt;
    bool rightAlt;
    bool alt;

    bool leftControl;
    bool rightControl;
    bool control;

    bool shift;
    bool capsLock;

    dchar printable;
    dchar deadChar;
  }

  struct MouseInfo {
    double x;
    double y;

    int[5] clicks;
  }

private:
  Type      _type;
  Key       _keyInfo;
  MouseInfo _mouseInfo;

  int _aux;

public:
  this(Type type) {
    _type = type;
  }

  this(Type type, Key data) {
    _type    = type;
    _keyInfo = data;
  }

  this(Type type, MouseInfo data) {
    _type    = type;
    _mouseInfo = data;
  }

  // Properties //

  Key key() {
    return _keyInfo;
  }

  MouseInfo mouseInfo() {
    return _mouseInfo;
  }

  Type type() {
    return _type;
  }

  int aux() {
    return _aux;
  }
}
