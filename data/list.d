module data.list;

final class List {
private:
  void*[] _data;

public:
  this() {
    _data = new void*[0];
  }

  this(ulong size, void* initializer) {
    typedef void* non_null = void;
    _data = cast(void*[]) new non_null[size];
    _data[0..$] = initializer;
  }

  this(void*[] values...) {
    _data = values.dup;
  }

  void* get(ulong index) {
    return _data[index];
  }

  void* head() {
    return _data[0];
  }

  void* tail() {
    return _data[$-1];
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
