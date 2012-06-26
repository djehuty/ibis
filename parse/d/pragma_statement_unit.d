module parse.d.pragma_statement_unit;

import parse.d.lexer;
import parse.d.token;

final class DPragmaStatementUnit {
private:
  DLexer  _lexer;

  int    _state;

  char[] _cur_string;

  void delegate(DToken, long line, long column, char[], char[], char[][]) _errorFunc;

  bool _errors;

  void _error(DToken token, long line, long column, char[] msg, char[] hint, char[][] usages) {
    _errors = true;

    _errorFunc(token, line, column, msg, hint, usages);
  }

public:
  this(DLexer lexer, void delegate(DToken, long, long,
                                   char[], char[], char[][]) errorFunc) {
    _lexer = lexer;
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
        if(this._state >= 1){
          //XXX: Error
        }

        this._state = 1;
        break;
      case DToken.Type.Identifier:
        if(this._state != 1){
          //XXX: Error
        }

        _cur_string = token.string;
        this._state = 2;
        break;
      case DToken.Type.RightParen:
        if(this._state != 2 && this._state != 3){
          //XXX: Error
        }

        if (this._state == 2) {
          //auto tree = expand!(StatementUnit)();
        }

        // Done.
        return false;
      case DToken.Type.Comma:
        if(this._state != 2){
          //XXX: Error
        }

        this._state = 3;

        //TODO: Argument List

        break;
      default:
        break;
    }
    return true;
  }
}
