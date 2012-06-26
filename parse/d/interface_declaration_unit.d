module parse.d.interface_declaration_unit;

import parse.d.interface_body_unit;

import parse.d.lexer;
import parse.d.token;

class DInterfaceDeclarationUnit {
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
      // The start of the body
      case DToken.Type.LeftCurly:
        auto interface_body = (new DInterfaceBodyUnit(_lexer, &_error)).parse;

        // Done.
        return false;

      // Look for a template parameter list
      case DToken.Type.LeftParen:
        if (_cur_string == "") {
          // Error: No name?
          // TODO:
        }
        if (_state >= 1) {
          // Error: Already have base class Dlist or template parameters
          // TODO:
        }
        _state = 1;

        // TODO: expand out parameter list
        break;

      // Look for inherited classes
      case DToken.Type.Colon:
        if (_cur_string == "") {
          // Error: No name?
          // TODO:
        }
        if (_state >= 2) {
          // Error: Already have base class Dlist
          // TODO:
        }
        _state = 2;

        // TODO: expand out base class Dlist
        break;

      // Name
      case DToken.Type.Identifier:
        if (_cur_string != "") {
          // Error: Two names?
          // TODO:
        }
        _cur_string = token.string;
        break;

      default:
        // Error: Unrecognized foo.
        break;
    }
    return true;
  }
}
