module parse.d.compare_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.shift_expression_unit;

/*

  CmpExpr => ShiftExpr == ShiftExpr
           | ShiftExpr != ShiftExpr
           | ShiftExpr is ShiftExpr
           | ShiftExpr !is ShiftExpr
           | ShiftExpr < ShiftExpr
           | ShiftExpr > ShiftExpr
           | ShiftExpr <= ShiftExpr
           | ShiftExpr >= ShiftExpr
           | ShiftExpr !< ShiftExpr
           | ShiftExpr !> ShiftExpr
           | ShiftExpr !<= ShiftExpr
           | ShiftExpr !>= ShiftExpr
           | ShiftExpr !<> ShiftExpr
           | ShiftExpr !<>= ShiftExpr
           | ShiftExpr <> ShiftExpr
           | ShiftExpr <>= ShiftExpr
           | ShiftExpr in ShiftExpr
           | ShiftExpr

*/

class DCompareExpressionUnit {
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
      case DToken.Type.Bang: // !
        // look for is
        DToken foo = _lexer.pop();
        if (foo.type == DToken.Type.Is) {
          // !is
          this._state = 2;
        }
        else {
          _lexer.push(foo);
          goto default;
        }
        break;

      case DToken.Type.Equals:             // ==
      case DToken.Type.NotEquals:           // !=
      case DToken.Type.LessThan:           // <
      case DToken.Type.NotLessThan:         // !<
      case DToken.Type.GreaterThan:         // >
      case DToken.Type.NotGreaterThan:         // !>
      case DToken.Type.LessThanEqual:         // <=
      case DToken.Type.NotLessThanEqual:       // !<=
      case DToken.Type.GreaterThanEqual:       // >=
      case DToken.Type.NotGreaterThanEqual:     // !>=
      case DToken.Type.LessThanGreaterThan:     // <>
      case DToken.Type.NotLessThanGreaterThan:     // !<>
      case DToken.Type.LessThanGreaterThanEqual:   // <>=
      case DToken.Type.NotLessThanGreaterThanEqual: // !<>=
      case DToken.Type.Is:               // is
      case DToken.Type.In:               // in

        if (this._state == 1) {
          // ==
          this._state = 2;
        }
        break;
      default:
        _lexer.push(token);
        if (this._state == 1) {
          // Done.
          return false;
        }

        auto expr = (new DShiftExpressionUnit(_lexer, &_error)).parse;
        if (this._state == 2) {
          // Done.
          return false;
        }
        this._state = 1;
        break;
    }

    return true;
  }
}
