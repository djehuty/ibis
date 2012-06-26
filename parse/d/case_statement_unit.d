module parse.d.case_statement_unit;

import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

class DCaseStatementUnit {
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
      case DToken.Type.Colon:
        if (this._state == 0) {
          // Error:
          // we have 'case: '
          // TODO:
        }

        // Done.
        return false;
      default:
        _lexer.push(token);
        if (this._state == 1) {
          // Error: Multiple expressions
          // TODO:
        }
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        this._state = 1;
        break;
    }
    return true;
  }
}
