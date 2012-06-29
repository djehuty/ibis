module keyboard.key;

final class Key {
public:
  /* These codes represent a physical key.
   */
  enum Code {
    Invalid,

    Backspace,
    Tab,
    Pause,
    Escape,

    PageUp,
    PageDown,

    End,
    Home,

    Left,
    Right,
    Up,
    Down,

    Insert,
    Delete,

    NumLock,
    ScrollLock,
    CapsLock,

    LeftShift,
    RightShift,

    LeftControl,
    RightControl,

    LeftAlt,
    RightAlt,

    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
    F13,
    F14,
    F15,
    F16,

    Return,
    Space,

    Zero,
    One,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,

    PrintScreen,
    SysRq,

    SingleQuote,
    Apostrophe,
    Comma,
    Period,
    Foreslash,
    Backslash,

    LeftBracket,
    RightBracket,

    Semicolon,
    Minus,
    Equals,

    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,

    KeypadZero,
    KeypadOne,
    KeypadTwo,
    KeypadThree,
    KeypadFour,
    KeypadFive,
    KeypadSix,
    KeypadSeven,
    KeypadEight,
    KeypadNine,

    KeypadPlus,
    KeypadMinus,
    KeypadAsterisk,
    KeypadForeslash,
    KeypadReturn,
    KeypadPeriod,

    International,
  }

private:
  Code _code;
  bool _leftAlt;
  bool _rightAlt;
  bool _leftControl;
  bool _rightControl;
  bool _shift;
  bool _capsLock;

public:

  this(Code keycode, bool leftAlt,     bool rightAlt,
                     bool leftControl, bool rightControl,
                     bool shift,       bool capsLock) {
    _code         = keycode;
    _leftAlt      = leftAlt;
    _rightAlt     = rightAlt;
    _leftControl  = leftControl;
    _rightControl = rightControl;
    _shift        = shift;
    _capsLock     = capsLock;
  }

  // Properties //

  Code code() {
    return _code;
  }

  bool alt() {
    return _leftAlt || _rightAlt;
  }

  bool leftAlt() {
    return _leftAlt;
  }

  bool rightAlt() {
    return _rightAlt;
  }

  bool control() {
    return _leftControl || _rightControl;
  }

  bool leftControl() {
    return _leftControl;
  }

  bool rightControl() {
    return _rightControl;
  }

  bool shift() {
    return _shift;
  }

  bool capsLock() {
    return _capsLock;
  }
}
