module parse.d.expression_declaration_disambiguation_unit;

import parse.d.lexer;
import parse.d.token;

/*

  Identifier is found and is common with both.

  Identifier
  TypeDeclaration = (. Identifier)* Identifier ...

*/

class DExpressionDeclarationDisambiguationUnit {
public:
  enum Variant {
    Expression,
    Declaration
  }

private:
  DLexer  _lexer;

  int    _state;

  Variant _variant;

  DToken[] _tokens;

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

  Variant parse() {
    DToken token;

    do {
      token = _lexer.pop();
      _tokens ~= token;
    } while (tokenFound(token));

    foreach_reverse(t; _tokens) {
      _lexer.push(t);
    }

    return _variant;
  }

  bool tokenFound(DToken token) {
    if (token.type == DToken.Type.Comment) {
      return true;
    }

    switch (token.type) {
      case DToken.Type.Dot:
        if (_state == 0 || _state == 1) {
          _state = 2;
        }
        else {
          return false;
        }
        break;

      case DToken.Type.Identifier:
        if (_state == 2) {
          _state = 1;
        }
        else {
          _variant = Variant.Declaration;
          return false;
        }
        break;

      default:
        return false;
    }

    return true;
  }
}
