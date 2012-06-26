module parse.d.type_unit;

import parse.d.basic_type_unit;
import parse.d.basic_type_suffix_unit;

import parse.d.lexer;
import parse.d.token;

class DTypeUnit {
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
    if (_state == 0) {
      _lexer.push(token);
      auto basicType = (new DBasicTypeUnit(_lexer, &_error)).parse;
      _state = 1;
    }
    else {
      _lexer.push(token);
      switch(token.type) {
        default:
          return false;
          break;

        case DToken.Type.Mul:
        case DToken.Type.Function:
        case DToken.Type.Delegate:
        case DToken.Type.LeftBracket:
          auto basicTypeSuffix = (new DBasicTypeSuffixUnit(_lexer, &_error)).parse;
          break;
      }
    }

    return true;
  }
}
