module parse.d.do_statement_unit;

import parse.d.scoped_statement_unit;
import parse.d.statement_unit;
import parse.d.block_statement_unit;
import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  do
  DoStatement = ScopedStatement while ( Expression )

*/

class DoStatementUnit {
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
      case DToken.Type.While:
        if (_state == 0) {
          // Error: Expected statement.
        }
        else if (_state == 1) {
          // Ok.
          _state = 2;
        }
        else {
          goto default;
        }
        break;

      case DToken.Type.LeftParen:
        if (_state == 2) {
          // OK.
          // While expression follows.
          auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
          _state = 3;
        }
        else {
          goto default;
        }
        break;

      case DToken.Type.RightParen:
        if (_state == 3) {
          // OK.
          _state = 4;
        }
        else {
          goto default;
        }
        break;

      case DToken.Type.Semicolon:
        if (_state == 4) {
          // OK. Done.
          return false;
        }
        else {
          goto default;
        }
        break;

      default:
        _lexer.push(token);

        if (_state == 0) {
          auto stmt = (new DScopedStatementUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else {
          // Error.
          return false;
        }
    }

    return true;
  }
}