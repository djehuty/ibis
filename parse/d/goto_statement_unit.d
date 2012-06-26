module parse.d.goto_statement_unit;

import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  goto
  GotoStmt => Identifier ;
            | default ;
            | case ( Expression )? ;

*/

class DGotoStatementUnit {
private:
  DLexer  _lexer;

  int    _state;

  char[] _cur_string;

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
      case DToken.Type.Semicolon:
        if (_state == 0) {
          // Error.
          // TODO:
        }
        if (_state == 2) {
          // Error.
          // TODO:
        }
        // Done.
        return false;
      case DToken.Type.Identifier:
        if (_state != 0) {
          // Error
          // TODO:
        }
        _cur_string = token.string;
        _state = 1;
        break;
      case DToken.Type.Default:
        _state = 2;
        break;
      case DToken.Type.Case:
        _state = 2;
        break;
      default:
        if (_state != 2) {
          // Error
          // TODO:
        }

        _lexer.push(token);
        if (_state == 3) {
          // Error: Multiple expressions
          // TODO:
        }
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 3;
        break;
    }
    return true;
  }
}
