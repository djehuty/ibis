module parse.d.static_if_statement_unit;

//import parse.d.assign_expression_unit;
import parse.d.declaration_unit;

import parse.d.lexer;
import parse.d.token;

class DStaticIfStatementUnit {
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
    if (this._state == 3) {
      // We are looking for declarations
      if (token.type == DToken.Type.RightCurly) {
        // Done.
        return false;
      }
      else {
        _lexer.push(token);
//        auto decl = (new DeclarationUnit(_lexer, &_error)).parse;
      }
      return true;
    }

    // Else, we are looking for the condition

    switch (token.type) {
      // Look for a left paren first. It must exist.
      case DToken.Type.LeftParen:
        if (this._state == 1) {
          // Error: Too many left parentheses.
          // TODO:
        }
        else if (this._state == 2) {
          // Error: We already found a right paren... Expected colon or brace
          // TODO:
        }
        this._state = 1;

        // The conditional part
//        auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
        break;

      case DToken.Type.RightParen:
        if (this._state == 0) {
          // Error: Do not have a left paren.
          // TODO: Probably forgot a left parenthesis.
        }
        else if (this._state == 2) {
          // Error: Too many right parens
          // TODO:
        }

        // Now we can look for a : or a curly brace for a declaration block
        this._state = 2;
        break;

      // For declaring the rest of the file under this conditional block
      // static if (foo):
      case DToken.Type.Colon:
        if (this._state == 0) {
          // Error: Do not have a condition!
          // TODO:
        }
        else if (this._state == 1) {
          // Error: Do not have a right paren.
          // TODO:
        }
        else if (this._state == 3) {
          // Error: After a left curly brace. We are within the block.
          // TODO:
        }

        // Done.
        return false;

      // For specifying a declaration block for this condition
      case DToken.Type.LeftCurly:
        if (this._state == 0) {
          // Error: Do not have a condition!
          // TODO:
        }
        else if (this._state == 1) {
          // Error: Do not have a right paren.
          // TODO:
        }

        // Now we look for declarations.
        this._state = 3;
        break;

      // Errors for any unknown tokens.
      default:
        break;
    }

    return true;
  }
}
