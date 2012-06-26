module parse.d.declarator_unit;

import parse.d.basic_type_suffix_unit;
import parse.d.declarator_suffix_unit;
import parse.d.parameter_list_unit;

import parse.d.declarator_node;
import parse.d.variable_declaration_node;
import parse.d.type_node;

import parse.d.token;
import parse.d.lexer;

/*

  Declarator => ( BasicTypeSuffix )* ( Declarator ) ( DeclaratorSuffix )*
              | ( BasicTypeSuffix )* Identifier ( DeclaratorSuffix )*

  (must start with one of these: {* [ ( delegate function})
  DeclaratorMiddle => ( BasicTypeSuffix )* ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*

  DeclaratorSuffix => [ ]
                    | [ Expression ]
                    | [ Type ]
                    | ( ( TemplateParameterList )? ( ParameterList

  BasicTypeSuffix => *
                   | [ ]
                   | [ Expression ]
           | [ Expression .. Expression ]
                   | [ Type ]
                   | delegate ( ParameterList
                   | function ( ParameterList

  Must disambiguate between BasicTypeSuffix and DeclaratorSuffix
  If it is a BasicTypeSuffix, disambiguate between Declarator and
  DeclaratorMiddle by looking for a following Identifier or (
  If it is a ( then it could still be either a Declarator or DeclaratorMiddle
  until it finds an Identifier.

  The only difference is that a Declarator can have an initial value.
  That is, = is only allowed (and ... disallowed) when a Declarator is
  found over a DeclaratorMiddle.

*/

class DeclaratorUnit {
private:
  DLexer  _lexer;

  int    _state;

  char[]   _name;
  DTypeNode _type;
  DTypeNode _basicType;

  DVariableDeclarationNode[] _parameters = null;

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

  DeclaratorNode parse(DTypeNode basicType) {
    _basicType = basicType;

    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return new DeclaratorNode(_name, _type, _parameters);
  }

  bool tokenFound(DToken token) {
    switch (_state) {
      case 0:
        switch (token.type) {
          case DToken.Type.LeftBracket:
          case DToken.Type.Delegate:
          case DToken.Type.Function:
          case DToken.Type.Mul:
            _lexer.push(token);
            auto suffixType = (new DBasicTypeSuffixUnit(_lexer, &_error)).parse;
            if (_type is null) {
              _type = _basicType;
            }

            _type = new DTypeNode(suffixType.type, _type, suffixType.identifier);
            break;

          case DToken.Type.LeftParen:
            // Recursive Declarator
            auto inner_declarator = (new DeclaratorUnit(_lexer, &_error)).parse(_basicType);
            _state = 2;
            break;

          case DToken.Type.Identifier:
            _state = 3;
            _name = token.string;
            break;

          default:
            // Bad
            break;
        }
        break;

      // Found BasicTypeSuffix, Look for either a recursive Declarator
      // Identifier or DeclaratorSuffix
      case 1:
        switch (token.type) {
          case DToken.Type.LeftParen:
            // Recursive Declarator
            //auto tree = expand!(DeclaratorUnit)();
            _state = 2;
            break;
          case DToken.Type.Identifier:
            _state = 3;
            _name = token.string;
            break;
          default:
            // Bad
            break;
        }
        break;

      // After a recursive Declarator, look for the end parenthesis
      case 2:
        switch(token.type) {
          case DToken.Type.RightParen:
            _state = 3;
            break;
          case DToken.Type.Identifier:
          default:
            // Bad
            break;
        }
        break;

      // Found (Declarator) or Identifier... look for Declarator Suffix (if exists)
      case 3:
        switch(token.type) {
          case DToken.Type.LeftParen:
            _parameters = (new DParameterListUnit(_lexer, &_error)).parse;
            break;

          case DToken.Type.LeftBracket:
          case DToken.Type.Mul:
            _lexer.push(token);
            auto tree = (new DeclaratorSuffixUnit(_lexer, &_error)).parse;
            break;

          default:
            // Fine.
            _lexer.push(token);
            break;
        }
        return false;
      default:
        break;
    }
    return true;
  }

}
