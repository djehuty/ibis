module parse.d.volatile_statement_unit;

import parse.d.statement_unit;

import parse.d.lexer;
import parse.d.token;

class DVolatileStatementUnit {
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
      case DToken.Type.Semicolon:
        // Done.
        return false;

      default:
        if (_state == 1) {
          // Error: Multiple statements!?
          // TODO:
        }

        _lexer.push(token);

        // Statement Follows.
        auto stml = (new DStatementUnit(_lexer, &_error)).parse;
        _state = 1;

        break;
    }
    return true;
  }
}
