module parse.d.for_statement_unit;

import parse.d.scoped_statement_unit;
import parse.d.statement_unit;
import parse.d.block_statement_unit;
import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  for
  ForStmt => ( NoScopeNonEmptyStmt ; Increment ) ScopeStmt
           | ( NoScopeNonEmptyStmy ; ; ) ScopeStmt
           | ( ; Expression ; Increment ) ScopeStmt
           | ( ; Expression ; ) ScopeStmt
           | ( ; ; Increment ) ScopeStmt
           | ( ; ; ) ScopeStmt

*/

class DForStatementUnit {
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
        _state = 1;
        break;

      case DToken.Type.RightParen:
        if (_state < 4 || _state > 5) {
        }

        // Found end of for loop expressions
        _state = 6;
        auto stmt = (new DScopedStatementUnit(_lexer, &_error)).parse;
        return false;

      case DToken.Type.Semicolon:
        if (_state == 0) {
        }

        if (_state == 1) {
          // No expression.
          _state = 2;
        }
        else if (_state == 2 || _state == 3) {
          // Had expression, looking for end
          // or loop expression
          _state = 4;
        }
        break;

      // We have an expression here.
      default:
        if (_state == 1) {
          // Initialization Expression
          _lexer.push(token);
          auto stmt = (new DStatementUnit(_lexer, &_error)).parse;
          _state = 2;
        }
        else if (_state == 2) {
          // Invariant Expression
          _lexer.push(token);
          auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
          _state = 3;
        }
        else if (_state == 4) {
          // Loop expression
          _lexer.push(token);
          auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
          _state = 5;
        }
        break;
    }
    return true;
  }
}
