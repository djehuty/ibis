module parse.d.parameter_unit;

import parse.d.assign_expression_unit;
import parse.d.declarator_middle_unit;
import parse.d.basic_type_unit;

import parse.d.variable_declaration_node;
import parse.d.declarator_node;
import parse.d.type_node;

import parse.d.lexer;
import parse.d.token;


/*

  Parameter => ( ref | out | in | lazy )? BasicType Declarator ( = AssignExpr )?
         | ( ref | out | in | lazy )? BasicType ( ... )?
         | ( ref | out | in | lazy )? BasicType DeclaratorMiddle ( ... )?

  (can start with one of these: {* [ ( delegate function})
  Declarator => ( BasicTypeSuffix )? ( Declarator ) ( DeclaratorSuffix )*
              | ( BasicTypeSuffix )? Identifier ( DeclaratorSuffix )*

  Declarators HAVE identifiers... DeclaratorMiddles... Don't
  Parameters can have one, the other, or none (eff)

  (must start with one of these: {* [ ( delegate function})
  DeclaratorMiddle => ( BasicTypeSuffix )? ( ( DeclaratorMiddle ) )? ( DeclaratorSuffix )*
  Examples: ref void[], in int, out int (no declarator... technically possible in a parameter)

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

class DParameterUnit {
private:
  DLexer  _lexer;

  int     _state;

  enum States {
    Start,
    FoundPassBySpecifier,
    FoundBasicType,
    FoundDeclaratorMiddle,
  }

  // For DTypeNode formation
  DTypeNode.Type  _type;
  DTypeNode       _subtype;
  char[]          _identifier;

  char[]          _name;

  DeclaratorNode _node;

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

  DVariableDeclarationNode parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return new DVariableDeclarationNode(_name,
                                       new DTypeNode(_type, _subtype, _identifier),
                       null);
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      // Default Initializers
      case DToken.Type.Assign:
        if (_state != States.FoundDeclaratorMiddle) {
          // Error: We don't have a declarator!
          // TODO:
        }

        // TODO:
        auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;

        // Done.
        return false;

      // Figure out the specifier.
      case DToken.Type.In:
      case DToken.Type.Out:
      case DToken.Type.Ref:
      case DToken.Type.Lazy:
        if (_state != States.Start) {
          // Error: Already have an in, out, ref, or lazy specifier.
          // TODO:
        }

        // Specifier.

        _state = States.FoundPassBySpecifier;

        // Fall through to hit the declarator call

        goto default;

      case DToken.Type.Variadic:
        if (_state != States.FoundDeclaratorMiddle) {
          // Error:
          // TODO:
        }

        // Done
        return false;

      case DToken.Type.LeftParen:
      case DToken.Type.Delegate:
      case DToken.Type.Function:
      case DToken.Type.Mul:
      case DToken.Type.LeftBracket:
        if (_state != States.FoundBasicType) {
          // Error:
          // TODO:
        }

        _lexer.push(token);

        _node = (new DeclaratorMiddleUnit(_lexer, &_error)).parse;
        _name = _node.name;
        _state = States.FoundDeclaratorMiddle;
        break;

      default:
        _lexer.push(token);

        if (_state == States.FoundBasicType) {
          // Could be a declarator then.
          _node = (new DeclaratorMiddleUnit(_lexer, &_error)).parse;
          _name = _node.name;
          _state = States.FoundDeclaratorMiddle;
        }
        else if (_state == States.Start ||
            _state == States.FoundPassBySpecifier) {
          // Hopefully this is a BasicType
          auto typeNode = (new DBasicTypeUnit(_lexer, &_error)).parse;
          _type = typeNode.type;
          _subtype = typeNode.subtype;
          _identifier = typeNode.identifier;

          _state = States.FoundBasicType;
        }
        else if (_state == States.FoundDeclaratorMiddle) {
          // Done
          return false;
        }
        break;
    }
    return true;
  }
}
