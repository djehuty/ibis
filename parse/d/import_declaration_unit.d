module parse.d.import_declaration_unit;

import parse.d.lexer;
import parse.d.token;

/*

  import
  ImportDecl => ImportList ;

  ImportList => ( Identifier . )+ ( : ImportBindList )? , ImportList
              | ( Identifier . )+ ( : ImportBindList )?

  ImportBindList => Identifier ( = Identifier )? , ImportBindList
                  | Identifier ( = Identifier )?

*/

class DImportDeclarationUnit {
private:
  DLexer  _lexer;

  int    _state;

  DToken  _last;

  char[] _cur_string = "";
  char[] _name = "";

  static const char[] _common_error_msg = "The import declaration is not formed correctly.";
  static const char[][] _common_error_usages = [
    "import package.file;",
    "import MyAlias = package.file;",
    "import MyFoo = package.file : Foo;"
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

  char[] parse() {
    DToken token;
    for (;;) {
      token = _lexer.pop();
      if (token.type == 0 || !tokenFound(token)) {
        break;
      }
      if (_errors) {
        return null;
      }
      _last = token;
    }

    return _cur_string;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      case DToken.Type.Dot:
        if (_cur_string.length > 0 && _cur_string[$-1] == '.') {

          // Error: We found two dots, probably left behind after an edit.
          _error(token, token.line, token.column, _common_error_msg,
              "There are a few too many dots in a row. Did you mean to have only one?",
              _common_error_usages);

        }
        else {
          _cur_string ~= ".";
        }
        break;

      case DToken.Type.Semicolon:
        // End of declaration
        return false;

      case DToken.Type.Identifier:
        if (_cur_string.length > 0 && _cur_string[$-1] != '.') {

          // Error: Found an identifier and then another identifier. Probably
          // due to an editing mistake.
          _error(token, token.line, token.column, _common_error_msg,
              "Did you mean to place a '.' between the two names?",
              _common_error_usages);

        }
        else {
          // Add the package or module name to the overall value.
          _cur_string ~= token.string;
        }
        break;

      case DToken.Type.Assign:
        // renamed import
        _name = _cur_string;
        _cur_string = "";
        break;

      case DToken.Type.Slice:
        // Error: Found .. when we expected just one dot.
        _error(token, token.line, token.column, _common_error_msg,
          "You placed two dots, did you mean to only have one?",
          _common_error_usages);
        break;

      case DToken.Type.Variadic:
        // Error: Found ... when we expected just one dot.
        _error(token, token.line, token.column, _common_error_msg,
          "You placed three dots, did you mean to only have one?",
          _common_error_usages);
        break;

      default:
        // Error: Found some illegal token. Probably due to lack of semicolon.
        _error(token, token.lineEnd, token.columnEnd, _common_error_msg,
          "You probably forgot a semicolon.",
          _common_error_usages);
        break;
    }
    return true;
  }
}
