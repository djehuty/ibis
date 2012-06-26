module parse.d.return_statement_unit;

import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  return
  ReturnStmt => ( Expression )? ;

*/

class DReturnStatementUnit {
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
      if (_errors) {
        return null;
      }
    } while (tokenFound(token));

    return "";
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      case DToken.Type.Semicolon:
        // Done.
        return false;

      default:
        if (_state == 1) {
          // Error: Multiple expressions
          // TODO:
          _error(token, token.line, token.column,
            "There are two expressions given for this return statement.",
            "Did you mean to place a semicolon between the two?",
            ["return;", "return 3", "return 2+2;"]);
          return true;
        }

        _lexer.push(token);

        // Expression follows... and then a semicolon
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
    }
    return true;
  }
}
