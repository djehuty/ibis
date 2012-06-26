module parse.d.postfix_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.primary_expression_unit;
import parse.d.index_or_slice_expression_unit;
import parse.d.argument_list_unit;

/*

*/

class DPostfixExpressionUnit {
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
        if (_state == 1) {
          // Disambiguate between index and slice expression
          auto expr = (new DIndexOrSliceExpressionUnit(_lexer, &_error)).parse;
        }
        else {
          goto default;
        }

        break;

      case DToken.Type.Identifier:
        if (_state == 2) {
          _state = 1;
        }
        else if (_state == 1) {
          // Error: Expect a dot, not an identifier.
        }
        else if (_state == 0) {
          goto default;
        }
        break;

      case DToken.Type.Dot:
        if (_state == 1) {
          _state = 2;
        }
        else if (_state == 0) {
          goto default;
        }
        break;

      case DToken.Type.Decrement:
        if (_state == 1) {
          // Done.
          return false;
        }
        goto default;

      case DToken.Type.Increment:
        if (_state == 1) {
          // Done.
          return false;
        }
        goto default;

      case DToken.Type.LeftParen:
        if (_state == 1) {
          auto args = (new DArgumentListUnit(_lexer, &_error)).parse;
          _state = 1;
          break;
        }
        goto default;

      default:
        _lexer.push(token);
        if (_state == 1) {
          // Done.
          return false;
        }
        auto expr = (new DPrimaryExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
    }

    return true;
  }
}
