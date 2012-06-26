module parse.d.add_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.multiply_expression_unit;

/*

  AddExpr => AddExpr + MulExpr
           | AddExpr - MulExpr
           | AddExpr ~ MulExpr
           | MulExpr

*/

class DAddExpressionUnit {
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
    if (token.type == DToken.Type.Comment) {
      return false;
    }

    switch (token.type) {
      case DToken.Type.Add:
      case DToken.Type.Sub:
      case DToken.Type.Cat:
        if (_state == 1) {
          _state = 0;
          break;
        }

        // Fall through
        goto default;

      default:
        _lexer.push(token);
        if (_state == 1) {
          // Done.
          return false;
        }
        auto expr = (new DMultiplyExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
    }

    return true;
  }
}
