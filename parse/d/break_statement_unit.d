module parse.d.break_statement_unit;

import parse.d.lexer;
import parse.d.token;

class DBreakStatementUnit {
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
      case DToken.Type.Semicolon:
        // Done.
        return false;
      case DToken.Type.Identifier:
        if (this._state == 1) {
          // Error: More than one identifier?!?!
          // TODO:
        }
        this._state = 1;
        _cur_string = token.string;
        break;
      default:
        // Error:
        // TODO:
        break;
    }
    return true;
  }
}
