module data.mutable_list;

final class MutableList {
private:
  static const size_t INITIAL_CAPACITY = 64;

  size_t _count;
  void*[] _data;

  void _resize() {
    void*[] _tmp = _data;
    _data = new void*[_data.length * 2];
    _data[0.._count] = _tmp[0.._count];
  }

public:
  this() {
    _data = new void*[INITIAL_CAPACITY];
    _count = 0;
  }

  this(ulong size, void* initializer) {
    _data = new void*[size];
    _count = _data.length;

    _data[0..$] = initializer;
  }

  this(void*[] values) {
    _data = values.dup;
    _count = _data.length;
  }

  // Properties //

  ulong length() {
    return cast(ulong)_count;
  }

  // Methods //

  void add(void* value) {
    if (_count >= _data.length) {
      _resize();
    }

    _data[_count] = value;
    _count++;
  }

  void add(void* value, long atIndex) {
    if (_count >= _data.length) {
      _resize();
    }

    for(size_t i = _count; i > atIndex; i--) {
      _data[i] = _data[i-1];
    }

    _data[atIndex] = value;
    _count++;
  }

  void* remove() {
    _count--;
    return _data[_count];
  }

  void* remove(long atIndex) {
    void* ret = _data[atIndex];
    for(size_t i = atIndex; i < _count - 1; i++) {
      _data[i] = _data[i+1];
    }
    return ret;
  }

  void set(long atIndex, void* value) {
    _data[atIndex] = value;
  }

  void* get(ulong atIndex) {
    return _data[atIndex];
  }

  void* head() {
    return get(0);
  }

  void* tail() {
    return get(_count - 1);
  }

  bool apply(bool delegate(ref size_t, ref void*) loopFunction) {
    bool ret = true;

    for(size_t i = 0; i < _data.length; i++) {
      ret = loopFunction(i, _data[i]);
      if (!ret) {
        return false;
      }
    }

    return ret;
  }
}
