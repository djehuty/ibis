module parse.d.function_literal_unit;

import parse.d.function_body_unit;
import parse.d.parameter_list_unit;
import parse.d.type_unit;

import parse.d.lexer;
import parse.d.token;

/*

  FunctionLiteral = ( ParameterList FunctionBody
                  | function Type FunctionBody
                  | delegate Type FunctionBody
                  | function Type ( ParameterList FunctionBody
                  | delegate Type ( ParameterList FunctionBody
                  | function FunctionBody
                  | delegate FunctionBody
                  | function ( ParameterList FunctionBody
                  | delegate ( ParameterList FunctionBody
                  | FunctionBody

*/

class DFunctionLiteralUnit {
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
    if (token.type == DToken.Type.Comment) {
      return true;
    }

    switch (token.type) {
      case DToken.Type.Function:
      case DToken.Type.Delegate:
        if (_state == 0) {
          _state = 1;
          return true;
        }

        goto default;

      case DToken.Type.LeftParen:
        if (_state == 0 || _state == 1 || _state == 2) {
          auto params = (new DParameterListUnit(_lexer, &_error)).parse;
          _state = 3;
          return true;
        }

        goto default;

      case DToken.Type.Body:
      case DToken.Type.Out:
      case DToken.Type.In:
      case DToken.Type.LeftCurly:
        if (_state == 0 || _state == 1 || _state == 2 || _state == 3) {
          _lexer.push(token);
          auto functionBody = (new DFunctionBodyUnit(_lexer, &_error)).parse;
          return false;
        }

        goto default;

      default:
        _lexer.push(token);
        if (_state == 1) {
          auto type = (new DTypeUnit(_lexer, &_error)).parse;
          _state = 2;
        }
        else {
          // Error
        }

        break;
    }

    return true;
  }
}
