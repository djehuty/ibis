module parse.d.foreach_statement_unit;

import parse.d.scoped_statement_unit;
import parse.d.expression_unit;
import parse.d.type_unit;

import parse.d.lexer;
import parse.d.token;

/*

  foreach | foreach_reverse
  ForeachStmt => ( ForeachTypeList ; Expression ) ScopeStmt
               | ( ForeachTypeList ; Tuple ) ScopeStmt

  ForeachTypeList => ForeachType , ForeachTypeList
                   | ForeachType

  ForeachType => ref Type Identifier
               | Type Identifier
               | ref Identifier
               | Identifier

*/

class DForeachStatementUnit {
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
      case DToken.Type.LeftParen:
        if (_state > 0) {
          // Error: Already found left parenthesis.
          // TODO:
        }
        _state = 1;
        break;
      case DToken.Type.RightParen:
        if (_state != 5) {
        }
        auto stmt = (new DScopedStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Ref:
        if (_state == 0) {
        }
        else if (_state >= 2) {
        }
        _state = 2;
        break;
      case DToken.Type.Identifier:
        if (_state == 0) {
        }
        if (_state > 3) {
        }
        if (_state == 3) {
          _state = 4;
        }
        else {
          // This needs lookahead to know it isn't a type
          DToken foo = _lexer.pop();
          _lexer.push(foo);
          if (foo.type == DToken.Type.Comma || foo.type == DToken.Type.Semicolon) {
            _state = 4;
          }
          else {
            _lexer.push(token);

            // Getting type of identifier
            auto type = (new DTypeUnit(_lexer, &_error)).parse;

            _state = 3;
          }
        }

        if (_state == 4) {
        }
        break;
      case DToken.Type.Semicolon:
        if (_state < 4) {
        }
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 5;
        break;
      case DToken.Type.Comma:
        if (_state != 4) {
        }
        _state = 1;
        break;
      default:
        break;
    }
    return true;
  }
}
