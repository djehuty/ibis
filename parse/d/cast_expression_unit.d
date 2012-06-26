module parse.d.cast_expression_unit;

import parse.d.unary_expression_unit;
import parse.d.type_unit;

import parse.d.lexer;
import parse.d.token;

/*

  cast
  CastExpression = ( Type ) UnaryExpression

*/

class DCastExpressionUnit {
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
      case DToken.Type.LeftParen:
        if (_state == 0) {
          _state = 1;
        }

        break;

      case DToken.Type.RightParen:
        if (_state == 0) {
          // Error: Did not see a (
          _error(token, token.line, token.column,
              "Cast has a malformed type specification.",
              "Did you mean to place a '(' here?",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
          return false;
        }

        if (_state == 1) {
          // Error: No type specification.
          _error(token, token.line, token.column,
              "Cast must provide a type specification to indicate the type to yield.",
              "Place a type within the parentheses.",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
          return false;
        }

        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      default:
        _lexer.push(token);
        if (_state == 1) {
          auto type = (new DTypeUnit(_lexer, &_error)).parse;
        }
        else if (_state == 0) {
          // Error: Did not see a (
          _error(token, token.line, token.column,
              "Cast must be given a type within parentheses.",
              "Place a type after the cast token.",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
        }
        else if (_state == 2) {
          _error(token, token.line, token.column,
              "Cast type specification is malformed.",
              "Did you intend to place a ')' here?",
              ["cast(int)5", "cast(Object)foo", "cast(typeof(5))42"]);
        }

        _state = 2;
        break;
    }

    return true;
  }
}
