module parse.d.variable_declaration_node;

import parse.d.type_node;
import parse.d.expression_node;

class DVariableDeclarationNode {
private:
  char[]         _name;
  DTypeNode       _type;
  DExpressionNode _initialValue;

public:
  this(char[] name, DTypeNode type, DExpressionNode initialValue) {
    _initialValue = initialValue;
    _name         = name;
    _type         = type;
  }

  char[] name() {
    return _name;
  }

  DTypeNode type() {
    return _type;
  }

  DExpressionNode initialValue() {
    return _initialValue;
  }
}
