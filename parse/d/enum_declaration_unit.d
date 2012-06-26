module parse.d.enum_declaration_unit;

import parse.d.enum_body_unit;
import parse.d.type_unit;

import parse.d.lexer;
import parse.d.token;

class DEnumDeclarationUnit {
private:
  DLexer  _lexer;

  int    _state;

  char[] _cur_string;

  char[] cur_string = "";

  static const char[] _common_error_msg = "Enum declaration is invalid.";
  static const char[][] _common_error_usages = null;

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
    // Looking for a name, or a colon for a type, or a curly
    // braces for the enum body
    switch (token.type) {
      case DToken.Type.Identifier:
        // The name of the enum
        if (_state >= 1) {
          // We are already passed the name stage.
          // XXX: error
        }
        _state = 1;
        _cur_string = token.string;
        break;
      case DToken.Type.Colon:
        // The type of the enum
        if (_state >= 2) {
          // Already passed the type stage.
          // XXX: error
        }
        _state = 2;
        auto type = (new DTypeUnit(_lexer, &_error)).parse;
        break;
      case DToken.Type.Semicolon:
        if (_state == 0) {
          // Need some kind of information about the enum.
          _error(token, token.line, token.column, _common_error_msg,
              "Without a name, the linker will not know what it should be linking to.",
              ["enum FooBar;", "enum FooBar : uint;"]);
          return false;
        }
        // Done.
        return false;
      case DToken.Type.LeftCurly:
        // We are going into the body of the enum
        auto enum_body = (new DEnumBodyUnit(_lexer, &_error)).parse;
        // Done.
        return false;
      default:
        break;
    }
    return true;
  }
}
