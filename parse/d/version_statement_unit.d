module parse.d.version_statement_unit;

import parse.d.declaration_unit;
import parse.d.block_statement_unit;

import parse.d.lexer;
import parse.d.token;

/*

  version
  VersionStatement = ( Identifier ) DeclarationBlock
                   | ( IntegerLiteral ) DeclarationBlock

  DeclarationBlock = { }
                   | Declaration
                   | { Declarations }

  Declarations = Declaration
               | Declaration Declarations

*/

class DVersionStatementUnit {
private:
  DLexer  _lexer;

  int    _state;
  bool   _asDeclaration;

  char[] _cur_string;

  void delegate (DToken, long, long, char[], char[], char[][]) _errorFunc;

  bool _errors;

  void _error(DToken token, long line, long column,
              char[] msg, char[] hint, char[][] usages) {
    _errors = true;

    _errorFunc(token, line, column, msg, hint, usages);
  }

public:
  this(bool asDeclaration, DLexer lexer,
       void delegate(DToken, long, long, char[], char[], char[][]) errorFunc) {
    _asDeclaration = asDeclaration;
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
    if (_state == 7 && token.type != DToken.Type.Else) {
      // Done
      _lexer.push(token);
      return false;
    }

    if (this._state == 4) {
      // We are looking for declarations
      if (token.type == DToken.Type.RightCurly) {
        // Done. Maybe.
        _state = 7;
      }
      else {
        _lexer.push(token);
        if (_asDeclaration) {
          auto decl = (new DDeclarationUnit(_lexer, &_error)).parse;
        }
        else {
          auto decl = (new DBlockStatementUnit(_lexer, &_error)).parse;
          _state = 7;
        }
      }
      return true;
    }

    // Else, we are looking for the condition

    switch (token.type) {
      // We could be declaring a version
      // version = Release; etc
      case DToken.Type.Assign:
        if (this._state == 1) {
          // Error: Already started to use an identifier
          // TODO:
        }
        else if (this._state == 2) {
          // Error: Already named an identifier.
          // TODO:
        }
        else if (this._state == 3) {
          // Error: Found right paren.
          // TODO:
        }

        // We need to find the identifier or integer to enable.
        this._state = 5;
        break;

      // Look for a left paren first. It must exist.
      case DToken.Type.LeftParen:
        if (this._state == 1) {
          // Error: Too many left parentheses.
          // TODO:
        }
        else if (this._state == 2) {
          // Error: Found an identifier.
          // TODO: Probably mistook left for right parenthesis.
        }
        else if (this._state == 3) {
          // Error: We already found a right paren... Expected colon or brace
          // TODO:
        }
        else {
          this._state = 1;
        }
        break;

      // For version assignment, we are looking for a semicolon to end it.
      case DToken.Type.Semicolon:
        if (this._state == 5) {
          // Error: No identifier given.
          // TODO:
        }
        else if (this._state == 0) {
          // Error: Need '=' first.
          // TODO:
        }
        else if (this._state == 1) {
          // Error: Have left paren.
          // TODO:
        }
        else if (this._state == 2) {
          // Error: Have Identifier for normal foo.
          // TODO:
        }
        else if (this._state == 3) {
          // Error: Have right paren.
          // TODO:
        }

        // else this._state == 6

        // Done.
        return false;

      case DToken.Type.Else:
        if (_state == 7) {
          // Good.
          _state = 8;
        }
        break;

      // Looking for some literal or identifier to use as the version
      case DToken.Type.Identifier:
      case DToken.Type.IntegerLiteral:
        if (this._state == 5) {
          // We are assigning a version
          _cur_string = token.string;
          this._state = 6;
        }
        else if (this._state == 6) {
          // Error: Too many identifiers in a row on a version assign.
          // TODO:
        }
        else if (this._state == 0) {
          // Error: No left parenthesis.
          // TODO: Probably forgot it!
        }
        else if (this._state == 2) {
          // Error: Too many identifiers in a row!
          // TODO: Probably put a space or something in.
        }
        else if (this._state == 3) {
          // Error: Found right parenthesis.
          // TODO: Probably forgot a curly brace.
        }
        else {
          _cur_string = token.string;
          this._state = 2;
        }
        break;

      case DToken.Type.RightParen:
        if (this._state == 0) {
          // Error: Do not have a left paren.
          // TODO: Probably forgot a left parenthesis.
        }
        else if (this._state == 3) {
          // Error: Too many right parens
          // TODO:
        }

        // Now we can look for a : or a curly brace for a declaration block
        this._state = 3;
        break;

      // For declaring the rest of the file under this conditional block
      // static if (foo):
      case DToken.Type.Colon:
        if (this._state == 0) {
          // Error: Do not have a condition!
          // TODO:
        }
        else if (this._state == 1) {
          // Error: Do not have an identifier.
          // TODO:
        }
        else if (this._state == 2) {
          // Error: Do not have a right paren.
          // TODO:
        }
        else if (this._state == 4) {
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
          // Error: Do not have an identifier.
          // TODO:
        }
        else if (this._state == 2) {
          // Error: Do not have a right paren.
          // TODO:
        }

        // Now we look for declarations.
        this._state = 4;
        break;

      default:
        if (_state == 3 || _state == 8) {
          // Declaration
          _lexer.push(token);
          auto decl = (new DDeclarationUnit(_lexer, &_error)).parse;
          if (_state == 8) {
            // Done.
            return false;
          }
          _state = 7;
        }
        break;
    }
    return true;
  }
}
