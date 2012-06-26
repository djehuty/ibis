module parse.d.type_declaration_node;

import parse.d.function_node;
import parse.d.variable_declaration_node;

class DTypeDeclarationNode {
public:
  enum Type {
    FunctionDeclaration,
    VariableDeclaration
  }

private:
  Type   _type;
  Object _node;

public:
  this(DFunctionNode functionNode) {
    _type = Type.FunctionDeclaration;
    _node = functionNode;
  }

  this(DVariableDeclarationNode variableNode) {
    _type = Type.VariableDeclaration;
    _node = variableNode;
  }

  Type type() {
    return _type;
  }

  Object node() {
    return _node;
  }
}
