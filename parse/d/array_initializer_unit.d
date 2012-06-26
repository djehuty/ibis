module parse.d.array_initializer_unit;

import parse.d.assign_expression_unit;

import parse.d.lexer;
import parse.d.token;

/*
  [
  ArrayInitializerUnit = ArrayMemberInitializers ]

  ArrayMemberInitializers = ArrayMemberInitializer
                          | ArrayMemberInitializer ,
                          | ArrayMemberInitializer , ArrayMemberInitializers

  ArrayMemberInitializer = AssignExpression : NonVoidInitializer
                         | NonVoidInitializer

  NonVoidInitializer = AssignExpression
                     | [ ArrayInitializer
                     | { StructInitializer
*/

class DArrayInitializerUnit {
private:
  DLexer  _lexer;

  int    _state;

  static const char[][] _common_error_usages = [
    "auto array = []", "auto array = [0, 1, 2]", "auto array = [0:1, 4:2 + 2, 5, 16:foo()]"];

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
          // Oddly, this is allowed.
        }

        // Done
        return false;

      case DToken.Type.Comma:
        if (_state == 0) {
          // Error: Have not seen any expressions.
          _error(token, token.line, token.column,
              "Array literal is malformed due to an unexpected comma.",
              "This array literal should start with a value.",
              _common_error_usages);
        }
        else if (_state == 2) {
          // Error: Double comma.
          _error(token, token.line, token.column,
              "Array literal is malformed due to an unexpected comma.",
              "Did you mean to have one comma? Or maybe you forgot a value?",
              _common_error_usages);
        }
        else if (_state == 1 || _state == 4) {
          // Have seen an expression
          _state = 2;
        }
        break;

      case DToken.Type.Colon:
        if (_state == 0 || _state == 2) {
          // Error. Have not seen any expressions.
          _error(token, token.line, token.column,
              "Array literal is malformed due to an unexpected colon.",
              "This array literal should start with a value.",
              _common_error_usages);
          return false;
        }
        else if (_state == 3) {
          // Error: Double colon.
          _error(token, token.line, token.column,
              "Array literal is malformed due to an unexpected colon.",
              "Did you accidentally place two colons here?",
              _common_error_usages);
          return false;
        }
        else if (_state == 4) {
          // Error: Double colon (colon after expression)
          _error(token, token.line, token.column,
              "Array literal has too many indexes.",
              "Only one index can be used. Did you mean to place a comma?",
              _common_error_usages);
          return false;
        }
        else if (_state == 1) {
          // Have seen an expression
          _state = 3;
        }
        else {
          goto default;
        }
        break;

      case DToken.Type.LeftBracket:
        if (_state == 0 || _state == 2 || _state == 3) {
          auto expr = (new DArrayInitializerUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else {
          // Follow through for error
          goto default;
        }
        break;

      case DToken.Type.LeftCurly:
        // TODO: StructInitializerUnit
        if (_state == 0 || _state == 2 || _state == 3) {
        }
        else {
          // Follow through for error
          goto default;
        }
        break;

      default:
        // AssignExpression
        if (_state == 3) {
          _lexer.push(token);
          auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
          _state = 4;
        }
        else if (_state == 0 || _state == 2) {
          _lexer.push(token);
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
