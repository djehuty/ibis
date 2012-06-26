module parse.d.basic_type_unit;

import parse.d.type_node;

import parse.d.lexer;
import parse.d.token;

/*

  BasicType => bool
             | byte
             | ubyte
             | short
             | ushort
             | int
             | uint
             | long
             | ulong
             | char
             | wchar
             | dchar
             | float
             | double
             | real
             | ifloat
             | idouble
             | ireal
             | cfloat
             | cdouble
             | creal
             | void
             | . IdentifierList
             | IdentifierList
             | Typeof ( . IdentifierList )?

  IdentifierList => Identifier . IdentifierList
                  | Identifier
                  | TemplateInstance . IdentifierList
                  | TemplateInstance

*/

class DBasicTypeUnit {
private:
  DLexer  _lexer;

  int    _state;

  DTypeNode _typeNode;

  char[] _cur_string = "";

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

    if (_typeNode is null && _cur_string.length > 0) {
      _typeNode = new DTypeNode(DTypeNode.Type.UserDefined, null, _cur_string);
    }

    return _typeNode;
  }

  bool tokenFound(DToken token) {
    if (_state == 1 || _state == 2) {
      // Identifier list
      if (_state == 2 && token.type == DToken.Type.Dot) {
        // Good
        _cur_string ~= ".";
        _state = 1;
      }
      else if (_state == 1 && token.type == DToken.Type.Identifier) {
        // Good.
        _cur_string ~= token.string;
        _state = 2;
      }
      else {
        // Done
        _lexer.push(token);
        return false;
      }

      return true;
    }

    switch (token.type) {
      case DToken.Type.Bool:
        _typeNode = new DTypeNode(DTypeNode.Type.Bool, null, null);
        return false;

      case DToken.Type.Byte:
        _typeNode = new DTypeNode(DTypeNode.Type.Byte, null, null);
        return false;

      case DToken.Type.Ubyte:
        _typeNode = new DTypeNode(DTypeNode.Type.Ubyte, null, null);
        return false;

      case DToken.Type.Short:
        _typeNode = new DTypeNode(DTypeNode.Type.Short, null, null);
        return false;

      case DToken.Type.Ushort:
        _typeNode = new DTypeNode(DTypeNode.Type.Ushort, null, null);
        return false;

      case DToken.Type.Int:
        _typeNode = new DTypeNode(DTypeNode.Type.Int, null, null);
        return false;

      case DToken.Type.Uint:
        _typeNode = new DTypeNode(DTypeNode.Type.Uint, null, null);
        return false;

      case DToken.Type.Long:
        _typeNode = new DTypeNode(DTypeNode.Type.Long, null, null);
        return false;

      case DToken.Type.Ulong:
        _typeNode = new DTypeNode(DTypeNode.Type.Ulong, null, null);
        return false;

      case DToken.Type.Char:
        _typeNode = new DTypeNode(DTypeNode.Type.Char, null, null);
        return false;

      case DToken.Type.Wchar:
        _typeNode = new DTypeNode(DTypeNode.Type.Wchar, null, null);
        return false;

      case DToken.Type.Dchar:
        _typeNode = new DTypeNode(DTypeNode.Type.Dchar, null, null);
        return false;

      case DToken.Type.Float:
        _typeNode = new DTypeNode(DTypeNode.Type.Float, null, null);
        return false;

      case DToken.Type.Double:
        _typeNode = new DTypeNode(DTypeNode.Type.Double, null, null);
        return false;

      case DToken.Type.Real:
        _typeNode = new DTypeNode(DTypeNode.Type.Real, null, null);
        return false;

      case DToken.Type.Ifloat:
        _typeNode = new DTypeNode(DTypeNode.Type.Ifloat, null, null);
        return false;

      case DToken.Type.Idouble:
        _typeNode = new DTypeNode(DTypeNode.Type.Idouble, null, null);
        return false;

      case DToken.Type.Ireal:
        _typeNode = new DTypeNode(DTypeNode.Type.Ireal, null, null);
        return false;

      case DToken.Type.Cfloat:
        _typeNode = new DTypeNode(DTypeNode.Type.Cfloat, null, null);
        return false;

      case DToken.Type.Cdouble:
        _typeNode = new DTypeNode(DTypeNode.Type.Cdouble, null, null);
        return false;

      case DToken.Type.Creal:
        _typeNode = new DTypeNode(DTypeNode.Type.Creal, null, null);
        return false;

      case DToken.Type.Void:
        _typeNode = new DTypeNode(DTypeNode.Type.Void, null, null);
        return false;

      case DToken.Type.Identifier:
        // Named Type, could be a scoped list
        _cur_string ~= token.string;
        _state = 2;
        break;

      // Scope Operator
      case DToken.Type.Dot:
        _state = 1;
        _cur_string ~= ".";
        break;

      case DToken.Type.Typeof:
        // TypeOfExpression
        // TODO: this
        break;

      default:
        // Error:
        // TODO:
        break;
    }
    return true;
  }
}
