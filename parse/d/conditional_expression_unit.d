module parse.d.conditional_expression_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.logical_or_expression_unit;

/*

   ConditionalExpr => LogicalOrExpr ? Expression : ConditionalExpr
                    | LogicalOrExpr

*/

class DConditionalExpressionUnit {
private:
  DLexer  _lexer;

  int    _state;

  static const char[][] _common_error_usages = [
    "x > 5 ? 0 : 1", "x <= 5 ? foo : bar"];

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
      case DToken.Type.Question:
        if (_state == 1) {
          _state = 2;
          break;
        }
        else if (_state == 0) {
          // Question mark precedes expression
          _error(token, token.line, token.column,
              "Ternary operator is missing test expression.",
              "Did you forget to add a boolean expression to test with?",
              _common_error_usages);
        }
        else if (_state == 2) {
          // Two question marks
          _error(token, token.line, token.column,
              "Ternary operator has too many question marks.",
              "Did you accidentally add another question mark??",
              _common_error_usages);
        }
        else {
          // Question mark mishap
          _error(token, token.line, token.column,
              "Ternary operator is malformed.",
              "You seem to have misplaced this question mark.",
              _common_error_usages);
        }

        goto default;

      case DToken.Type.Colon:
        if (_state == 3) {
          _state = 4;
          break;
        }
        else if (_state == 1) {
          // Expecting Question, got colon... not an error, but it means this is not a conditional
          _lexer.push(token);

          // Done.
          return false;
        }
        else if (_state == 2) {
          // No expression given
          _error(token, token.line, token.column,
              "Ternary operator is missing expression to yield on true.",
              "You seem to have forgotten to place a value here.",
              _common_error_usages);
        }
        else {
          // Colon is surprising!
          _lexer.push(token);
          return false;
        }

        goto default;

      default:
        _lexer.push(token);
        if (_state == 5) {
          // Done.
          return false;
        }

        if (_state == 1) {
          // Done.
          return false;
        }

        if (_state == 3) {
          // Looking for colon
          // Error
          _error(token, token.line, token.column,
              "Ternary operator is missing third operand.",
              "Did you mean to place a colon here?",
              _common_error_usages);
          return false;
        }
        auto tree = (new DLogicalOrExpressionUnit(_lexer, &_error)).parse;

        _state++;
        break;
    }

    return true;
  }
}
