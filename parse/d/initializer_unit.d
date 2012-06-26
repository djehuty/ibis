module parse.d.initializer_unit;

import parse.d.assign_expression_unit;
import parse.d.array_initializer_unit;

import parse.d.lexer;
import parse.d.token;

/*

*/

class DInitializerUnit {
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
      case DToken.Type.Void:
        // Done
        return false;

      case DToken.Type.LeftBracket:
        // Could be an ArrayInitializer
        auto expr = (new DArrayInitializerUnit(_lexer, &_error)).parse;

        // Done
        return false;

      case DToken.Type.LeftCurly:
        // Could be a StructInitializer
        return false;

      default:
        // AssignExpression
        _lexer.push(token);
        auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
        return false;
    }
    return true;
  }
}
