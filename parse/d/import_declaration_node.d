module parse.d.import_declaration_node;

class DImportDeclarationNode {
private:
  char[] _moduleName;

public:
  this(char[] moduleName) {
    _moduleName = moduleName.dup;
  }

  char[] moduleName() {
    return _moduleName.dup;
  }
}
