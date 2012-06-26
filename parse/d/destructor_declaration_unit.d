module parse.d.destructor_declaration_unit;

import parse.d.function_body_unit;

import parse.d.function_node;

import parse.d.lexer;
import parse.d.token;

class DestructorDeclarationUnit {
private:
  DLexer  _lexer;

  int    _state;

  bool   _thisFound = false;

  DFunctionNode _functionNode;

  static const char[] _common_error_msg = "Destructor declaration invalid.";
  static const char[][] _common_error_usages = [
    "~this() { }",
    "~this();"
  ];

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
        if (!_thisFound) {
          // Error: Need this after ~
          _error(token, token.line, token.column, _common_error_msg,
              "Did you intend on having a destructor here? You are missing 'this'.",
              _common_error_usages);
        }
        else if (_state != 0) {
          // It should be the first thing!
          // Error: Too many left parentheses!
          _error(token, token.line, token.column, _common_error_msg,
              "You accidentally placed too many left parentheses here.",
              _common_error_usages);
        }
        _state = 1;
        break;

        // After finding a left paren, look for a right one
      case DToken.Type.RightParen:
        if (!_thisFound) {
          // Error: Need this after ~
          _error(token, token.line, token.column, _common_error_msg,
              null,
              _common_error_usages);
        }
        else if (_state == 0) {
          // Error: No left paren found before this right one!
          _error(token, token.line, token.column, _common_error_msg,
              "You are missing a left parenthesis.",
              _common_error_usages);
        }
        else if (_state != 1) {
          // Error: Already parsed a right paren! We have too many right parens!
          _error(token, token.line, token.column, _common_error_msg,
              "You have placed too many right parentheses.",
              _common_error_usages);
        }
        _state = 2;
        break;

        // Look for the end of a bodyless declaration
      case DToken.Type.Semicolon:
        if (!_thisFound) {
          // Error: Need this after ~
          _error(token, token.line, token.column, _common_error_msg,
              "A '~' does nothing on its own.",
              _common_error_usages);
        }
        else if (_state == 0) {
          // Error: Have not found a left paren!
          _error(token, token.line, token.column, _common_error_msg,
              "You must have a empty parameter list for your destructor.",
              _common_error_usages);
        }
        else if (_state != 2) {
          // Error: Have not found a right paren!
          _error(token, token.line, token.column, _common_error_msg,
              "You accidentally left out a right parenthesis.",
              _common_error_usages);
        }
        // Done.
        _functionNode = new DFunctionNode(null, null, null, null, null, null);
        return false;

        // Function body
      case DToken.Type.In:
      case DToken.Type.Out:
      case DToken.Type.Body:
      case DToken.Type.LeftCurly:
        // Have we found a parameter list?
        if (!_thisFound) {
          // Error: Need this after ~
          _error(token, token.line, token.column, _common_error_msg,
              null,
              _common_error_usages);
        }
        else if (_state == 0 ) {
          // Error: No parameter list given at all
          _error(token, token.line, token.column, _common_error_msg,
              "You must have an empty parameter list for a destructor.",
              _common_error_usages);
        }
        else if (_state == 1) {
          // Error: We have a left parenthesis... but no right one
          _error(token, token.line, token.column, _common_error_msg,
              "You have accidentally left out a right parenthesis.",
              _common_error_usages);
        }

        // Function body!
        _lexer.push(token);
        auto destructor_body = (new DFunctionBodyUnit(_lexer, &_error)).parse;
        _functionNode = new DFunctionNode(null, null, null, null, null, null);

        // Done.
        return false;

        // We are only given that the first token, ~, is found...
        // So, we must ensure that the This keyword is the first item
      case DToken.Type.This:
        if (_state == 0 && !_thisFound) {
          _thisFound = true;
        }
        else if (_state == 0 && _thisFound) {
          // Error: this this <- listed twice in a row
          _error(token, token.line, token.column, _common_error_msg,
              "You accidentally placed two 'this' in a row.",
              _common_error_usages);
        }
        else if (_state == 1) {
          // Error: Expected right paren, got this.
          _error(token, token.line, token.column, _common_error_msg,
              "The parameter list should be empty for a destructor.",
              _common_error_usages);
        }
        else {
          // Error: Got this, expected function body or ;
          _error(token, token.line, token.column, _common_error_msg,
              "You probably forgot a semicolon.",
              _common_error_usages);
        }
        break;

        // All other tokens are errors.
      default:
        if (!_thisFound) {
          // Error: Need this after ~
          _error(token, token.line, token.column, _common_error_msg,
              "A '~' character is unexpected here.",
              _common_error_usages);
        }
        else if (_state == 0) {
          // Error this BLEH...Need ()
          _error(token, token.line, token.column, _common_error_msg,
              "The destructor must have an empty parameter list: ~this ()",
              _common_error_usages);
        }
        else if (_state == 1) {
          // Error: Expected right paren
          _error(token, token.line, token.column, _common_error_msg,
              "The destructor must have an empty parameter list: ~this ()",
              _common_error_usages);
        }
        else if (_state == 2) {
          // Error: this(...) BLEH... Need function body or semicolon!
          _error(token, token.line, token.column, _common_error_msg,
              "You are probably missing a curly brace or a semicolon.",
              _common_error_usages);
        }
        break;
    }
    return true;
  }
}
