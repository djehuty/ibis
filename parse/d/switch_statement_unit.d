module parse.d.switch_statement_unit;

import parse.d.expression_unit;
import parse.d.block_statement_unit;

import parse.d.lexer;
import parse.d.token;

class DSwitchStatementUnit {
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
      case DToken.Type.LeftParen:
        if (_state != 0) {
        }

        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
      case DToken.Type.RightParen:
        if (_state != 1) {
        }
        _state = 2;
        break;
      case DToken.Type.LeftCurly:
        if (_state == 0) {
        }
        if (_state == 1) {
        }

        auto stmt = (new DBlockStatementUnit(_lexer, &_error)).parse;
        // Done.
        return false;
      default:
        // Error
        // TODO:
        break;
    }
    return true;
  }
}
