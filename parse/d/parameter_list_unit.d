module parse.d.parameter_list_unit;

import parse.d.parameter_unit;

import parse.d.variable_declaration_node;

import parse.d.lexer;
import parse.d.token;

/*

  (
  ParameterList => Parameter , ParameterList
                 | Parameter )
                 | )

*/

class DParameterListUnit {
private:
  DLexer  _lexer;

  int    _state;

  DVariableDeclarationNode[] _parameters;

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

  DVariableDeclarationNode[] parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _parameters;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      case DToken.Type.RightParen:
        // Done.
        return false;

      case DToken.Type.Variadic:
        if (_state == 2) {
          // Error: Have two variadics?!
          // TODO: One too many variadics.
        }
        // We have a variadic!
        _state = 2;
        break;

      case DToken.Type.Comma:
        if (_state == 0) {
          // Error: Expected a parameter!
          // TODO: Probably accidently removed a parameter without removing the comma.
        }

        // Get Parameter
        _state = 0;
        break;

      default:
        if (_state == 0) {
          // Look for a parameter
          _lexer.push(token);
          _parameters ~= (new DParameterUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else if (_state == 2) {
          // Error: Parameter after variadic?
          // TODO: Forgot comma.
        }
        else {
          // Error: otherwise
          // TODO:
        }

        break;
    }
    return true;
  }
}
