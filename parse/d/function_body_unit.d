module parse.d.function_body_unit;

import parse.d.block_statement_unit;

import parse.d.statement_node;

import parse.d.lexer;
import parse.d.token;

class DFunctionBodyUnit {
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

  DStatementNode[] parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return null;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      // We always look FIRST for a left curly brace
      case DToken.Type.LeftCurly:
        auto stmt = (new DBlockStatementUnit(_lexer, &_error)).parse;
        break;

      // TODO: in, out, body, block_statement foo
      case DToken.Type.In:
        if (_state & 1 > 0) {
          // Bad (In already found)
        }
        if (_state & 4 > 0) {
          // Bad (Body already found)
        }
        _state = _state | 1;
        break;
      case DToken.Type.Out:
        if (_state & 2 > 0) {
          // Bad (Out already found)
        }
        if (_state & 4 > 0) {
          // Bad (Body already found)
        }
        _state = _state | 2;
        break;
      case DToken.Type.Body:
        _state = _state | 4;
        break;

      default:
        _lexer.push(token);
        return false;
    }
    return true;
  }
}
