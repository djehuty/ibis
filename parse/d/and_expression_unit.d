module parse.d.and_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.compare_expression_unit;

/*

  AndExpr => AndExpr & CmpExpr
           | CmpExpr

*/

class DAndExpressionUnit {
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
      return true;
    }

    switch (token.type) {
      case DToken.Type.And:
        if (this._state == 1) {
          this._state = 0;
          break;
        }

        // Fall through
        goto default;

      default:
        _lexer.push(token);
        if (this._state == 1) {
          // Done.
          return false;
        }
        auto tree = (new DCompareExpressionUnit(_lexer, &_error)).parse;

        _state = 1;
        break;
    }

    return true;
  }
}
