module keyboard.translator;

import keyboard.key;

final class Translator {
private:
  dchar delegate(Key, dchar) _translateFunc;
  bool  delegate(Key)        _isDeadFunc;

public:
  this(dchar delegate(Key, dchar) translateFunc,
       bool  delegate(Key)        isDeadFunc) {
    _translateFunc = translateFunc;
    _isDeadFunc    = isDeadFunc;
  }

  dchar translate(Key key, dchar dead) {
    if (_translateFunc) {
      return _translateFunc(key, dead);
    }

    return '\0';
  }

  bool isDead(Key key) {
    if (_isDeadFunc) {
      return _isDeadFunc(key);
    }

    return false;
  }
}
