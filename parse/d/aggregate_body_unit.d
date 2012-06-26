module parse.d.aggregate_body_unit;

import parse.d.declaration_unit;

import parse.d.lexer;
import parse.d.token;

class DAggregateBodyUnit {
private:
  DLexer  _lexer;

  int    _state;

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
    _lexer  = lexer;
    _errorFunc = errorFunc;
  }

  char[] parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return "";
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      // We are always looking for the end of the body.
      case DToken.Type.RightCurly:
        // Done.
        return false;

      // A new Dkeyword will set up an allocator.
      case DToken.Type.New:
        // TODO:
        break;

      // Ditto for a delete token for deallocator.
      case DToken.Type.Delete:
        // TODO:
        break;

      // Otherwise, it must be some Declarator
      default:
        _lexer.push(token);
        auto decl = (new DDeclarationUnit(_lexer, &_error)).parse;
        break;
    }
    return true;
  }
}
