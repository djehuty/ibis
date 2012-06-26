module parse.d.aggregate_declaration_unit;

import parse.d.aggregate_body_unit;

import parse.d.lexer;
import parse.d.token;

class DAggregateDeclarationUnit {
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
      // We have found the name
      case DToken.Type.Identifier:
        if (_cur_string != "") {
          // Error: Two names?
        }
        _cur_string = token.string;
        break;

      // We have found the left brace, so parse the body
      case DToken.Type.LeftCurly:
        auto aggregate_body = (new DAggregateBodyUnit(_lexer, &_error)).parse;
        // Done.
        return false;

      case DToken.Type.Semicolon:
        if (_cur_string == "") {
          // Error: No name?
        }
        // Done.
        return false;
      default:
        break;
    }
    return true;
  }
}
