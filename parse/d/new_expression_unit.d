module parse.d.new_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.assign_expression_unit;
import parse.d.type_unit;

/*

  new
  NewExpression = ( ArgumentList? )? Type [ AssignExpression ]
                | ( ArgumentList? )? Type ( ArgumentList )
                | ( ArgumentList? )? Type
                | NewAnonymousClassExpression

  ArgumentList = AssignExpression
               | AssignExpression , ArgumentList

*/

class DNewExpressionUnit {
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
      case DToken.Type.LeftBracket:
        if (_state == 5) {
          // Good.
          _state = 9;
        }
        break;

      case DToken.Type.RightBracket:
        if (_state == 10) {
          // Done.
          return false;
        }
        break;

      case DToken.Type.LeftParen:
        if (_state == 0) {
          _state = 1;
        }
        else if (_state == 1 || _state == 3) {
          // Fall through
          goto default;
        }
        else if (_state == 2) {
          // Error: Expected comma or right paren. Got a second expression (potentially.)
        }
        else if (_state == 4) {
          // Error: Expected type. Got an expression (potentially.)
        }
        else if (_state == 5) {
          // ArgumentList start
          _state = 6;
        }
        else if (_state == 6) {
          // Fall through
          goto default;
        }

        break;

      case DToken.Type.Comma:
        if (_state == 2) {
          _state = 3;
        }
        else if (_state == 7) {
          _state = 8;
        }
        break;

      case DToken.Type.RightParen:
        if (_state == 3) {
          // Error: Saw comma, expected expression.
        }
        else if (_state == 1 || _state == 2) {
          // Good
          _state = 4;
        }
        else if (_state == 6 || _state == 7) {
          // Done.
          return false;
        }
        break;

      default:
        _lexer.push(token);
        if (_state == 1 || _state == 3) {
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 2;
        }
        else if (_state == 0 || _state == 4) {
          auto type = (new DTypeUnit(_lexer, &_error)).parse;
          _state = 5;
        }
        else if (_state == 5) {
          // Done
          return false;
        }
        else if (_state == 6 || _state == 8) {
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 7;
        }
        else if (_state == 9) {
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 10;
        }
        break;
    }

    return true;
  }
}
