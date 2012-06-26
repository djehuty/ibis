module parse.d.declarator_node;

import parse.d.variable_declaration_node;

import parse.d.type_node;

class DeclaratorNode {
private:
  char[] _name;
  DTypeNode _type;

  DVariableDeclarationNode[] _parameters;

public:
  this(char[] name, DTypeNode type, DVariableDeclarationNode[] parameters) {
    _name = name.dup;
    _type = type;
    if (parameters is null) {
      _parameters = null;
    }
    else {
      _parameters = parameters.dup;
    }
  }

  char[] name() {
    return _name.dup;
  }

  DTypeNode type() {
    return _type;
  }

  DVariableDeclarationNode[] parameters() {
    if (_parameters is null) {
      return null;
    }
    return _parameters.dup;
  }
}
