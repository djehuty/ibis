module parse.d.basic_type_suffix_unit;

import parse.d.expression_unit;
import parse.d.parameter_list_unit;

import parse.d.type_node;

import parse.d.token;
import parse.d.lexer;

class DBasicTypeSuffixUnit {
private:
  DLexer  _lexer;

  DTypeNode _type;

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

  DTypeNode parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _type;
  }

  bool tokenFound(DToken token) {
    switch(_state) {
      case 0:
        switch (token.type) {
          case DToken.Type.Mul:
            _type = new DTypeNode(DTypeNode.Type.Pointer, null, null);
            return false;

          case DToken.Type.LeftBracket:
            _state = 1;
            break;

          case DToken.Type.Delegate:
          case DToken.Type.Function:
            _state = 2;
            break;

          default:
            // Error:
            // TODO:
            break;
        }
        break;

      // Saw [ looking for Expression, Type, or ]
      case 1:
        switch(token.type) {
          case DToken.Type.RightBracket:
            _type = new DTypeNode(DTypeNode.Type.Array, null, null);
            return false;

          default:
            // XXX: Disambiguate between Type and Expression
            _lexer.push(token);
            auto tree = (new DExpressionUnit(_lexer, &_error)).parse;
            _state = 3;
            break;
        }
        break;

      // Saw Delegate/Function ... looking for ( ParameterList
      case 2:
        switch(token.type) {
          case DToken.Type.LeftParen:
            auto params = (new DParameterListUnit(_lexer, &_error)).parse;
            _type = new DTypeNode(DTypeNode.Type.UserDefined, null, "delegate");
            return false;

          default:
            // Bad
            break;
        }
        break;

      // Saw Expression, looking for .. or ]
      case 3:
        switch(token.type) {
          case DToken.Type.RightBracket:
            _type = new DTypeNode(DTypeNode.Type.Array, null, null);
            return false;

          case DToken.Type.Slice:
            auto tree = (new DExpressionUnit(_lexer, &_error)).parse;
            _state = 4;
            break;
        }
        break;

      // Saw Expression .. Expression, looking for ]
      case 4:
        switch(token.type) {
          case DToken.Type.RightBracket:
            _type = new DTypeNode(DTypeNode.Type.Array, null, null);
            return false;
          default:
            // Bad
            break;
        }
    }
    return true;
  }
}
