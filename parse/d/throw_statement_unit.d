module parse.d.throw_statement_unit;

import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

class DThrowStatementUnit {
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
        if (_state == 0) {
          // Error: No expression
          // TODO:
        }

        // Done.
        return false;
      default:
        if (_state == 1) {
          // Error: Multiple expressions
          // TODO:
        }
        _lexer.push(token);
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
    }
    return true;
  }
}
