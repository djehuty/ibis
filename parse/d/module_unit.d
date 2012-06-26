module parse.d.module_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.module_node;
import parse.d.declaration_node;

import parse.d.module_declaration_unit;
import parse.d.declaration_unit;

/*

  Module => module ModuleDecl
          | Declaration

*/

final class DModuleUnit {
private:
  char[] _name;
  DDeclarationNode[] _declarations;

  DLexer _lexer;

  void delegate (DToken, long, long, char[], char[], char[][]) _errorFunc;

  bool _errors;

  void _error(DToken token, long line, long column,
              char[] msg, char[] hint, char[][] usages) {
    _errors = true;

    _errorFunc(token, line, column, msg, hint, usages);
  }

public:
  this(DLexer lexer,
       void delegate(DToken, long, long, char[], char[], char[][]) errorFunc) {
    _lexer = lexer;
    _errorFunc = errorFunc;
    _errors = false;
  }

  DModuleNode parse() {
    DToken token;
    for (;;) {
      token = _lexer.pop();
      if (token.type == DToken.Type.EOF) {
        break;
      }

      switch(token.type) {
        case DToken.Type.Module:
          if (_name !is null) {
            _error(token, token.line, token.column,
              "Module declaration should be on one of the first lines of the file.",
              "Did you mean to use the keyword import here instead?",
              ["module foo.bar;"]);
          }
          _name = (new DModuleDeclarationUnit(_lexer, &_error)).parse;
          break;
        default:
          _lexer.push(token);
          auto decl = (new DDeclarationUnit(_lexer, &_error)).parse;
          if (decl) {
            _declarations ~= decl;
          }
          break;
      }

      if (_errors) {
        return null;
      }
    }

    return new DModuleNode(_name, _declarations);
  }
}
