module parse.d.array_literal_unit;

import parse.d.assign_expression_unit;

import parse.d.lexer;
import parse.d.token;

/*
  [
  ArrayLiteralUnit = AssignExpression , ArrayLiteralUnit
                   | ]
*/

class DArrayLiteralUnit {
private:
  DLexer  _lexer;

  int    _state;

  static const char[][] _common_error_usages = [
    "[]", "[0, 1, 2]", "[0, 2 + 2, foo()]"];

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
      case DToken.Type.RightBracket:
        if (_state == 2) {
          // Error: Saw comma. Require expression
          _error(token, token.line, token.column,
              "This array literal is missing a value before a closing bracket.",
              "The last value may not be followed by a comma. Did you mean to remove it?",
              _common_error_usages);
        }

        // Done
        return false;
      case DToken.Type.Comma:
        if (_state == 0) {
          // Error. Have not seen any expressions
          _error(token, token.line, token.column,
              "Array literal is malformed due to an unexpected comma.",
              "This array literal should start with a value.",
              _common_error_usages);
        }
        else if (_state == 1) {
          // Have seen an expression
          _state = 2;
        }
        break;

      default:
        // AssignExpression
        _lexer.push(token);
        if (_state == 0 || _state == 2) {
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else {
          // Error: Did not see a comma.
          _error(token, token.line, token.column,
              "Array literal is malformed due to multiple expressions given.",
              "Did you mean to place a comma here?",
              _common_error_usages);
          return false;
        }
        break;
    }

    return true;
  }
}
