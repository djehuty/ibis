module parse.d.module_node;

import parse.d.declaration_node;
import parse.d.import_declaration_node;

class DModuleNode {
private:
  char[] _name;
  DDeclarationNode[] _declarations;

public:
  this(char[] name, DDeclarationNode[] declarations) {
    _name = name.dup;
    _declarations = declarations;
  }

  char[] name() {
    return _name.dup;
  }

  DDeclarationNode[] declarations() {
    return _declarations;
  }

  DImportDeclarationNode[] imports() {
    DImportDeclarationNode[] ret = [];
    foreach(decl; _declarations) {
      if (decl.type == DDeclarationNode.Type.ImportDeclaration) {
        ret ~= cast(DImportDeclarationNode)decl.node;
      }
    }
    return ret;
  }
}
