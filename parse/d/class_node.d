module parse.d.class_node;

import parse.d.function_node;

class DClassNode {
private:
  DFunctionNode[] _constructors;
  DFunctionNode[] _methods;
  DFunctionNode   _destructor;
  char[]         _name;
  char[]         _comment;

public:
  this(char[] name,
       DFunctionNode[] constructors,
       DFunctionNode destructor,
       DFunctionNode[] methods,
       char[] comment = null) {

    _constructors = constructors.dup;
    _destructor   = destructor;
    _methods      = methods.dup;
    _name         = name.dup;
    _comment      = comment.dup;
  }

  char[] name() {
    return _name.dup;
  }

  char[] comment() {
    return _comment.dup;
  }

  DFunctionNode[] methods() {
    return _methods.dup;
  }

  DFunctionNode[] constructors() {
    return _constructors.dup;
  }

  DFunctionNode destructor() {
    return _destructor;
  }
}
