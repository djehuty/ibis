module parse.d.array_literal_disambiguation_unit;

import parse.d.lexer;
import parse.d.token;

class DArrayLiteralDisambiguationUnit {
public:
  enum ArrayLiteralVariant {
    Array,
    AssociatedArray
  }

private:
  DLexer  _lexer;


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

  ArrayLiteralVariant parse() {
    DToken token = _lexer.pop();
    _lexer.push(token);

    return ArrayLiteralVariant.Array;
  }
}

