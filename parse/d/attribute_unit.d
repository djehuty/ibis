module parse.d.attribute_unit;

import parse.d.declaration_unit;

import parse.d.declaration_node;
import parse.d.type_declaration_node;

import parse.d.lexer;
import parse.d.token;

class DAttributeUnit {
public:
  enum Attribute {
    Static,
    Extern,
    Deprecated,
    Final,
    Synchronized,
    Override,
    Abstract,
    Const,
    Auto,
    Scope,
    Align,
    Pragma,
    Public,
    Protected,
    Private,
    Package
  }

private:
  DLexer  _lexer;

  int _state;

  DDeclarationNode _declaration;
  Attribute[] _attributes;

  // Put in AST node
  void _addAttributeIfUnique(Attribute attribute) {
    bool shouldAdd = true;
    foreach(attr; _attributes) {
      if (attr == attribute) {
        shouldAdd = false;
        break;
      }
    }

    if (shouldAdd) {
      _attributes ~= attribute;
    }
  }

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

  DDeclarationNode parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _declaration;
  }

  bool tokenFound(DToken token) {
    if (_state > 0) {
      switch (token.type) {
        case DToken.Type.LeftParen:
          _state = 1;
          break;

        case DToken.Type.Identifier:
          _state = 2;
          break;

        case DToken.Type.Increment:
          _state = 2;
          break;

        case DToken.Type.RightParen:
          _state = 0;
          break;
      }
      return true;
    }

    switch(token.type) {
      case DToken.Type.Static:
        _addAttributeIfUnique(Attribute.Static);
        return true;

      case DToken.Type.Const:
        _addAttributeIfUnique(Attribute.Const);
        return true;

      case DToken.Type.Public:
        _addAttributeIfUnique(Attribute.Public);
        return true;

      case DToken.Type.Private:
        _addAttributeIfUnique(Attribute.Private);
        return true;

      case DToken.Type.Protected:
        _addAttributeIfUnique(Attribute.Protected);
        return true;

      case DToken.Type.Package:
        _addAttributeIfUnique(Attribute.Package);
        return true;

      case DToken.Type.Synchronized:
        _addAttributeIfUnique(Attribute.Synchronized);
        return true;

      case DToken.Type.Deprecated:
        _addAttributeIfUnique(Attribute.Deprecated);
        return true;

      case DToken.Type.Override:
        _addAttributeIfUnique(Attribute.Override);
        return true;

      case DToken.Type.Final:
        _addAttributeIfUnique(Attribute.Final);
        return true;

      case DToken.Type.Extern:
        _addAttributeIfUnique(Attribute.Extern);
        _state = 1;
        // TODO: extern ( x ) // Do parens list
        return true;

      case DToken.Type.Scope:
        // TODO: scope ( x ) // Do parens list
        _addAttributeIfUnique(Attribute.Extern);
        return true;

      case DToken.Type.Auto:
        // TODO: scope ( x ) // Do parens list
        _addAttributeIfUnique(Attribute.Auto);
        return true;

      case DToken.Type.Colon:
        if (_attributes.length == 0) {
          _error(token, token.line, token.column,
              "Attribute list is empty.",
              "Did you mean to place 'public' or 'private' (etc) here?",
              ["public:", "private:", "public static:"]);
        }

        // Done
        return false;

      default:
        break;
    }

    // Followed by declaration
    _lexer.push(token);
    _declaration = (new DDeclarationUnit(_lexer, &_error)).parse;
    return false;
  }
}
