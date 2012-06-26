module parse.d.unit_test_unit;

import parse.d.function_body_unit;

import parse.d.lexer;
import parse.d.token;

class DUnitTestUnit {
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
      // Look for the beginning of a functionbody
      case DToken.Type.In:
      case DToken.Type.Out:
      case DToken.Type.Body:
      case DToken.Type.LeftCurly:
        _lexer.push(token);
        auto test_body = (new DFunctionBodyUnit(_lexer, &_error)).parse;

        // Done.
        return false;

      // Errors otherwise.
      default:
        break;
    }
    return true;
  }
}
