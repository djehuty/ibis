module parse.d.constructor_declaration_unit;

import parse.d.parameter_list_unit;
import parse.d.function_body_unit;

import parse.d.function_node;
import parse.d.variable_declaration_node;

import parse.d.lexer;
import parse.d.token;

class DConstructorDeclarationUnit {
private:
  DLexer  _lexer;

  int    _state;

  DFunctionNode              _functionNode;
  DVariableDeclarationNode[] _parameters;
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

  DFunctionNode parse() {
    // Get all comments
    _comment = "";
    while(!_lexer.isCommentEmpty()) {
      auto t = _lexer.commentPop();
      _comment ~= t.string;
    }

    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _functionNode;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      // First, we look for the left paren of the parameter list
      case DToken.Type.LeftParen:
        if (_state != 0) {
          // It should be the first thing!
          // Error: Too many left parentheses!
        }
        _state = 1;
        break;

      // After finding a left paren, look for a right one
      case DToken.Type.RightParen:
        if (_state == 0) {
          // Error: No left paren found before this right one!
          // TODO:
        }
        else if (_state != 1) {
          // Error: Already parsed a right paren! We have too many right parens!
          // TODO:
        }
        _state = 2;
        break;

      // Look for the end of a bodyless declaration
      case DToken.Type.Semicolon:
        if (_state == 0) {
          // Error: Have not found a left paren!
          // TODO:
        }
        if (_state != 2) {
          // Error: Have not found a right paren!
          // TODO:
        }
        if (_functionNode is null) {
          _functionNode = new DFunctionNode(null, null, _parameters, null, null, null, _comment);
        }
        // Done.
        return false;

      // Function body
      case DToken.Type.In:
      case DToken.Type.Out:
      case DToken.Type.Body:
      case DToken.Type.LeftCurly:
        // Have we found a parameter list?
        if (_state == 0) {
          // Error: No parameter list given at all
          // TODO:
        }
        else if (_state == 1) {
          // Error: We have a left parenthesis... but no right one
          // TODO:
        }
        else if (_state != 2) {
          // Error: No parameter list
          // TODO:
        }

        // Function body!
        _lexer.push(token);
        auto functionBody = (new DFunctionBodyUnit(_lexer, &_error)).parse;
        _functionNode = new DFunctionNode(null, null, _parameters, null, null, null, _comment);

        // Done.
        return false;

      // Otherwise, we might have found something that is in the parameter list
      default:
        if (_state == 1) {
          // Found a left paren, but not a right paren...
          // Look for the parameter list.
          _lexer.push(token);
          _parameters = (new DParameterListUnit(_lexer, &_error)).parse;
        }
        else {
          // Errors!
          if (_state == 0) {
            // Error this BLEH...Need parameters!
            // TODO:
          }
          else if (_state == 2) {
            // Error: this(...) BLEH... Need function body or semicolon!
            // TODO:
          }
        }
        break;
    }
    return true;
  }
}

