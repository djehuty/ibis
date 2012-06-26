module parse.d.parser;

import parse.d.lexer;
import parse.d.token;

import parse.d.module_node;

import parse.d.module_unit;

final class DParser {
private:
  DLexer _lexer;

public:
  this(DLexer lexer) {
    _lexer = lexer;
  }

  DModuleNode parse(void delegate(DToken, long, long,
                                  char[], char[], char[][]) errorFunc) {
    return (new DModuleUnit(_lexer, errorFunc)).parse;
  }
}
