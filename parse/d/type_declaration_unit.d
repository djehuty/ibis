module parse.d.type_declaration_unit;

import parse.d.declarator_unit;
import parse.d.initializer_unit;
import parse.d.function_body_unit;
import parse.d.basic_type_unit;

import parse.d.lexer;
import parse.d.token;

import parse.d.type_declaration_node;
import parse.d.declarator_node;
import parse.d.function_node;
import parse.d.variable_declaration_node;
import parse.d.type_node;

class DTypeDeclarationUnit {
private:
  DLexer  _lexer;

  int    _state = 0;

  DTypeNode _basicType;
  DTypeNode _type;
  DeclaratorNode _node;
  DFunctionNode _function;
  DVariableDeclarationNode _variable;
  char[] _comment;

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

  DTypeDeclarationNode parse() {
    // Get all comments
    _comment = "";
    while(!_lexer.isCommentEmpty()) {
      auto t = _lexer.commentPop();
      _comment = t.string ~ "\n" ~ _comment;
    }

    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    if (_function) {
      return new DTypeDeclarationNode(_function);
    }

    if (_type is null) {
      _type = _basicType;
    }

    if (_variable is null && _node !is null) {
      _variable = new DVariableDeclarationNode(_node.name, _type, null);
    }

    return new DTypeDeclarationNode(_variable);
  }

  bool tokenFound(DToken token) {
    if (token.type == DToken.Type.Comment) {
      return true;
    }

    switch(this._state) {

      // Looking for a basic type or identifier
      case 0:
        switch (token.type) {
          case DToken.Type.Bool:
          case DToken.Type.Byte:
          case DToken.Type.Ubyte:
          case DToken.Type.Short:
          case DToken.Type.Ushort:
          case DToken.Type.Int:
          case DToken.Type.Uint:
          case DToken.Type.Long:
          case DToken.Type.Ulong:
          case DToken.Type.Char:
          case DToken.Type.Wchar:
          case DToken.Type.Dchar:
          case DToken.Type.Float:
          case DToken.Type.Double:
          case DToken.Type.Real:
          case DToken.Type.Ifloat:
          case DToken.Type.Idouble:
          case DToken.Type.Ireal:
          case DToken.Type.Cfloat:
          case DToken.Type.Cdouble:
          case DToken.Type.Creal:
          case DToken.Type.Void:
          case DToken.Type.Identifier:
            _lexer.push(token);
            _basicType = (new DBasicTypeUnit(_lexer, &_error)).parse();

            // We have a basic type... look for Declarator
            _node = (new DeclaratorUnit(_lexer, &_error)).parse(_basicType);
            this._state = 1;

            _type = _node.type;
            break;

          case DToken.Type.Typeof:
            // TypeOfExpression
            // TODO: this
            break;

          // Invalid token for this _state
          case DToken.Type.Assign:
            break;

          // Invalid token for this _state
          case DToken.Type.Semicolon:
            break;

          default:

            // We will pass this off to a Declarator
            _lexer.push(token);
            auto decl = (new DeclaratorUnit(_lexer, &_error)).parse(_basicType);
            this._state = 1;
            break;
        }
        break;

      // We have found a basic type and are looking for either an initializer
      // or another type declaration. We could also have a function body
      // for function literals.
      case 1:
        switch(token.type) {
          case DToken.Type.Semicolon:
            // Done
            if (_node !is null && _node.parameters !is null) {
              _function = new DFunctionNode(_node.name, _basicType, _node.parameters, null, null, null, _comment);
            }
            return false;

          case DToken.Type.Comma:
            // Look for another declarator
            auto expr = (new DeclaratorUnit(_lexer, &_error)).parse(_basicType);
            break;

          case DToken.Type.Assign:
            // Initializer
            auto expr = (new DInitializerUnit(_lexer, &_error)).parse;
            this._state = 4;
            break;
          case DToken.Type.LeftCurly:
          case DToken.Type.In:
          case DToken.Type.Out:
          case DToken.Type.Body:
            // It could be a function body
            _lexer.push(token);
            auto function_body = (new DFunctionBodyUnit(_lexer, &_error)).parse;
            _function = new DFunctionNode(_node.name, _basicType, _node.parameters, null, null, null, _comment);
            return false;

          default:
            // Bad
            break;
        }
        break;

      case 4:
        switch(token.type) {
          case DToken.Type.Comma:
            // Initializer list
            auto decl = (new DeclaratorUnit(_lexer, &_error)).parse(_basicType);
            _state = 1;
            break;

          case DToken.Type.Assign:
            // Bad
            _error(token, token.line, token.column,
                "Declaration cannot contain more than one assignment.",
                "Did you mean to place a semicolon here?",
                []);
            break;

          case DToken.Type.Semicolon:
            // Done
            return false;

          default:
            // Bad
            _error(token, token.line, token.column,
                "Declaration malformed.",
                "Did you mean to place a semicolon here?",
                []);
            return false;
        }
        break;

      default:
        break;
    }

    return true;
  }
}
