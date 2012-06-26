module parse.d.argument_list_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.assign_expression_unit;

/*

   (
   ArgumentList = Arguments )
                | )

   Arguments = AssignExpression
             | AssignExpression , Arguments

*/

class DArgumentListUnit {
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
      case DToken.Type.RightParen:
        if (_state == 0 || _state == 1) {
          // Done.
          return false;
        }
        break;

      case DToken.Type.Comma:
        if (_state == 1) {
          _state = 2;
        }
        else if (_state == 0) {
          // Error: Comma is before first argument
          return false;
        }
        else if (_state == 2) {
          // Error: Comma follows a comma. Argument perhaps omitted.
          return false;
        }
        break;

      default:
        _lexer.push(token);
        if (_state == 0 || _state == 2) {
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else if (_state == 1) {
          // Error: Comma or right paren expected
          return false;
        }
        break;
    }

    return true;
  }
}
