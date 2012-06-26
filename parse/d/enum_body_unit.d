module parse.d.enum_body_unit;

import parse.d.assign_expression_unit;

import parse.d.lexer;
import parse.d.token;

class DEnumBodyUnit {
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
      // Looking for a new Dmember name
      case DToken.Type.Identifier:
        if (_state == 1) {
          // Error: A name next to a name??
        }
        _state = 1;
        break;
      case DToken.Type.RightCurly:
        // Done.
        return false;
      case DToken.Type.Comma:
        if (_state != 1) {
          // Error: A comma by itself?
        }
        _state = 0;
        break;
      case DToken.Type.Assign:
        if (_state != 1) {
          // Error: An equals by itself?
        }

        // Look for an assignment expression.
        auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;

        // Stay in the same state and wait for a comma.
        break;
      default:
        break;
    }
    return true;
  }
}
