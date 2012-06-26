module parse.d.static_assert_statement_unit;

//import parse.d.assign_expression_unit;

import parse.d.declaration_node;

import parse.d.lexer;
import parse.d.token;

/*

  static assert
  StaticAssertStatement = assert ( AssignExpression , AssignExpression )
                        | assert ( AssignExpression )

*/

final class DStaticAssertStatementUnit {
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

  DDeclarationNode parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return null;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      case DToken.Type.LeftParen:
        if (_state == 0) {
//          auto expr = (new DAssignExpressionUnit(_lexer, _error)).parse;
          _state = 1;
        }
        else {
          // Error: TODO
        }
        break;

      case DToken.Type.Comma:
        if (_state == 1) {
          // Good
//          auto expr = (new DAssignExpressionUnit(_lexer, _error)).parse;
          _state = 2;
        }
        else if (_state == 0) {
        }
        else if (_state == 2) {
        }
        break;

      case DToken.Type.RightParen:
        if (_state == 1 || _state == 2) {
          // Done.
          return false;
        }
        else {
        }
        break;

      default:
        break;
    }

    return true;
  }
}
