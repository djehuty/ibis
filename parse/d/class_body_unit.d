module parse.d.class_body_unit;

import parse.d.declaration_unit;

import parse.d.class_node;
import parse.d.function_node;
import parse.d.declaration_node;

import parse.d.lexer;
import parse.d.token;

class DClassBodyUnit {
private:
  DLexer  _lexer;

  int    _state;

  DFunctionNode[] _functions;
  DFunctionNode[] _constructors;
  DFunctionNode   _destructor;

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

  DFunctionNode[][] parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return [_constructors, [_destructor], _functions];
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      // We are always looking for the end of the body.
      case DToken.Type.RightCurly:
        // Done.
        return false;

      // A new Dkeyword will set up an allocator.
      case DToken.Type.New:
        // TODO:
        break;

      // Ditto for a delete token for deallocator.
      case DToken.Type.Delete:
        // TODO:
        break;

      case DToken.Type.Public:
        break;
      case DToken.Type.Private:
        break;
      case DToken.Type.Static:
        break;
      case DToken.Type.Final:
        break;
      case DToken.Type.Protected:
        break;
      case DToken.Type.Colon:
        break;

      // Otherwise, it must be some Declarator
      default:
        _lexer.push(token);
        auto decl = (new DDeclarationUnit(_lexer, &_error)).parse;
        if (decl is null) {
        }
        else if (decl.type == DDeclarationNode.Type.FunctionDeclaration) {
          _functions ~= cast(DFunctionNode)decl.node;
        }
        else if (decl.type == DDeclarationNode.Type.ConstructorDeclaration) {
          _constructors ~= cast(DFunctionNode)decl.node;
        }
        else if (decl.type == DDeclarationNode.Type.DestructorDeclaration) {
          if (_destructor is null) {
            _destructor = cast(DFunctionNode)decl.node;
          }
          else {
            // XXX: Error. Two destructors.
          }
        }
        break;
    }
    return true;
  }
}
