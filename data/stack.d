module data.stack;

/* This stack is non threadsafe and therefore not lockfree, etc.
 * It never sizes down.
 * Initially starts at 64 and doubles in size to fit more items.
 */

final class Stack {
private:
  static const size_t INITIAL_CAPACITY = 64;
  void*[] _data;
  size_t  _count;

  void _resize() {
    auto temp = _data;
    _data = new void*[_data.length * 2];
    _data[0.._count] = temp[0.._count];
  }

public:
  this() {
    _data = new void*[INITIAL_CAPACITY];
    _count = 0;
  }

  this(void*[] values) {
    _count = values.length;
    if (_count == 0) {
      _data = new void*[INITIAL_CAPACITY];
    }
    else {
      _data = values.dup;
    }
  }

  // Properties //

  ulong length() {
    return _count;
  }

  // Methods //

  void push(void* value) {
    if (_count == _data.length) {
      _resize();
    }
    _data[_count] = value;
    _count++;
  }

  void* pop() {
    _count--;
    return _data[_count];
  }

  void* peek() {
    return _data[_count-1];
  }
}
