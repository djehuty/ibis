module parse.d.declaration_node;

class DDeclarationNode {
public:

  enum Type {
    ClassDeclaration,
    ConstructorDeclaration,
    DestructorDeclaration,
    EnumDeclaration,
    FunctionDeclaration,
    ImportDeclaration,
    InterfaceDeclaration,
    VariableDeclaration
  }

private:
  Type   _type;
  Object _node;

public:

  this(Type type, Object node) {
    _type = type;
    _node = node;
  }

  Type type() {
    return _type;
  }

  Object node() {
    return _node;
  }
}
