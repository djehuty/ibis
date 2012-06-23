module data.queue;

final class Queue {
private:
  struct Node {
    Node* next;
    Node* prev;
    void* value;
  }

  Node* _head;
  Node* _tail;

  ulong _count;

public:
  this() {
    _head = null;
    _tail = null;
  }

  this(void*[] values) {
    foreach(value; values) {
      enqueue(value);
    }
  }

  // Properties //

  ulong length() {
    return _count;
  }

  // Methods //

  void* dequeue() {
    if (_count == 0) {
    }

    auto ret = _head.value;
    _head = _head.next;
    if (_head !is null) {
      _head.prev = null;
    }
    else {
      _tail = null;
    }

    _count--;
    return ret;
  }

  void* peek() {
    if (_count == 0) {
    }

    return _head.value;
  }

  void enqueue(void* value) {
    auto node = new Node;
    node.next = null;
    node.prev = _tail;
    node.value = value;

    if (_count == 0) {
      _head = node;
      _tail = node;
    }
    else {
      _tail.next = node;
      _tail = node;
    }

    _count++;
  }
}
