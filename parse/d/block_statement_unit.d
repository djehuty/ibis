module parse.d.block_statement_unit;

import parse.d.statement_unit;

import parse.d.lexer;
import parse.d.token;

class DBlockStatementUnit {
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
    switch (token.type) {
      case DToken.Type.RightCurly:
        // Done.
        return false;
      default:
        // We can look for a simple declaration
        _lexer.push(token);
        auto stmt = (new DStatementUnit(_lexer, &_error)).parse;
        break;
    }
    return true;
  }
}
