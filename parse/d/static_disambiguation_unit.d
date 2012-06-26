module parse.d.static_disambiguation_unit;

/*import parse.d.static_if_statement_unit;
import parse.d.static_assert_statement_unit;
import parse.d.type_declaration_unit;
*/

import parse.d.declaration_node;
//import parse.d.type_declaration_node;

import parse.d.lexer;
import parse.d.token;

class DStaticDisambiguationUnit {
public:
  enum StaticVariant {
    StaticIf,
    StaticAssert,
    StaticConstructor,
    StaticDestructor,
    StaticAttribute
  }

private:
  DLexer  _lexer;

  int    _state;

public:
  this(DLexer lexer,
       void delegate(DToken, long, long, char[], char[], char[][]) errorFunc) {
    _lexer  = lexer;
  }

  StaticVariant parse() {
    DToken token = _lexer.pop();
    _lexer.push(token);

    if (token.type == DToken.Type.If) {
      return StaticVariant.StaticIf;
    }

    if (token.type == DToken.Type.Assert) {
      return StaticVariant.StaticAssert;
    }

    if (token.type == DToken.Type.This) {
      return StaticVariant.StaticConstructor;
    }

    if (token.type == DToken.Type.Cat) {
      return StaticVariant.StaticDestructor;
    }

    return StaticVariant.StaticAttribute;
  }
}
