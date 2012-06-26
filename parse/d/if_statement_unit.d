module parse.d.if_statement_unit;

import parse.d.scoped_statement_unit;
import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  if
  IfStmt => ( IfCondition ) ScopeStatement ( else ScopeStatement )?

  IfCondition => Expression
               | auto Identifier = Expression
         | BasicType Declarator = Expression

*/

class DIfStatementUnit {
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
    switch(_state) {
      case 0:
        switch (token.type) {
          case DToken.Type.LeftParen:
            _state = 1;
            break;

          case DToken.Type.RightParen:
          case DToken.Type.Semicolon:
            // Bad
            break;

          default:
            break;
        }
        break;

      case 1: // IfCondition
        switch (token.type) {
          case DToken.Type.Auto:
            _state = 2;
            break;
          default:
            // Expression
            _lexer.push(token);
            auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
            _state = 4;
            break;
        }
        break;
      case 2: // IfCondition: auto... Identifier = Expression
        switch (token.type) {
          case DToken.Type.Identifier:
            _state = 3;
            break;
          default:
            // Bad
            break;
        }
        break;
      case 3: // IfCondition: auto Identifier... = Expression
        switch (token.type) {
          case DToken.Type.Assign:
            auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
            _state = 4;
            break;
          default:
            // Bad
            break;
        }
        break;
      case 4: // IfCondition consumed
        switch (token.type) {
          case DToken.Type.RightParen:
            // Good
            auto stmt = (new DScopedStatementUnit(_lexer, &_error)).parse;
            _state = 5;
            break;
          default:
            // Bad
            break;
        }
        break;
      case 5: // ( IfCondition ) ScopeStatement ... else ScopeStatement
        switch (token.type) {
          case DToken.Type.Else:
            // Alright
            auto stmt = (new DScopedStatementUnit(_lexer, &_error)).parse;
            break;

          default:
            // Fine
            _lexer.push(token);
            break;
        }
        return false;
    }
    return true;
  }
}
