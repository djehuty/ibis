module parse.d.assign_expression_unit;

import parse.d.conditional_expression_unit;

import parse.d.lexer;
import parse.d.token;

class DAssignExpressionUnit {
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
      case DToken.Type.Assign:
      case DToken.Type.AddAssign:
      case DToken.Type.SubAssign:
      case DToken.Type.CatAssign:
      case DToken.Type.MulAssign:
      case DToken.Type.DivAssign:
      case DToken.Type.ModAssign:
      case DToken.Type.OrAssign:
      case DToken.Type.AndAssign:
      case DToken.Type.XorAssign:
      case DToken.Type.ShiftLeftAssign:
      case DToken.Type.ShiftRightAssign:
      case DToken.Type.ShiftRightSignedAssign:
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
        auto expr = (new DConditionalExpressionUnit(_lexer, &_error)).parse;

        _state = 1;
        break;
    }

    return true;
  }
}
