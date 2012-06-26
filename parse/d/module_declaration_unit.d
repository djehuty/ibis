module parse.d.module_declaration_unit;

import parse.d.lexer;
import parse.d.token;

/*

   ModuleDecl => ( . Identifier )+ ;

*/

final class DModuleDeclarationUnit {
private:
  char[] cur_string;
  DLexer _lexer;
  int _state = 0;

  DToken _last;

  static const char[] _common_error_msg = "The module declaration is not formed correctly.";
  static const char[][] _common_error_usages = ["module package.file;"];

  void delegate(DToken, long line, long column, char[], char[], char[][]) _errorFunc;

  bool _errors;

  void _error(DToken token, long line, long column, char[] msg, char[] hint, char[][] usages) {
    _errors = true;

    _errorFunc(token, line, column, msg, hint, usages);
  }

public:
  this(DLexer lexer, void delegate(DToken, long, long,
                                   char[], char[], char[][]) errorFunc) {
    _lexer = lexer;
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
    return cur_string;
  }

  bool tokenFound(DToken current) {
    switch (current.type) {
      case DToken.Type.Dot:
        if (_state == 0) {
          _error(current, current.line, current.column, _common_error_msg,
                        "You may not start a declaration with a dot.",
                        _common_error_usages);
          return true;
        }
        else if (_state == 1) {
          _error(current, current.line, current.column, _common_error_msg,
                        "There are a few too many dots in a row. Did you mean to have only one?",
                        _common_error_usages);
          return true;
        }

        _state = 1;

        if (cur_string.length > 0 && cur_string[$-1] == '.') {

          // Error: We found two dots, probably left behind after an edit.
          _error(current, current.line, current.column, _common_error_msg,
                        "There are a few too many dots in a row. Did you mean to have only one?",
                        _common_error_usages);
          return true;
        }
        else {
          cur_string ~= ".";
        }
        break;
      case DToken.Type.Semicolon:

        if (_state == 0) {
          // module ;
          // Error: No module name given
          _error(current, current.line, current.column, _common_error_msg,
            "You forgot to name the module.",
            _common_error_usages);
          return true;
        }
        else if (_state == 1) {
          // module foo. ;
          // Error: Ended on a dot.
          _error(current, current.line, current.column, _common_error_msg,
            "You ended the module name with a dot. Perhaps you forgot to delete this dot?",
            _common_error_usages);
          return true;
        }

        // End of declaration
        return false;

      case DToken.Type.Identifier:

        if (_state == 2) {
          // Error: Found an identifier next to an identifier... unintentional space?
          _error(current, current.line, current.column, _common_error_msg,
            "You cannot put a space in a module name. Did you mean to use an underscore?",
            _common_error_usages);
          return true;
        }

        _state = 2;

        if (cur_string.length > 0 && cur_string[$-1] != '.') {

          // Error: Found an identifier and then another identifier. Probably
          // due to an editing mistake.
          _error(current, current.line, current.column, _common_error_msg,
              "Did you mean to place a '.' between the two names?",
              _common_error_usages);
          return true;
        }
        else {

          // Add the package or module name to the overall value.
          cur_string ~= current.string;

        }

        break;

      // Common erroneous tokens
      case DToken.Type.Slice:
        // Error: Found .. when we expected just one dot.
        _error(current, current.line, current.column, _common_error_msg,
          "You placed two dots, did you mean to only have one?",
          _common_error_usages);
        return true;

      case DToken.Type.Variadic:
        // Error: Found ... when we expected just one dot.
        _error(current, current.line, current.column, _common_error_msg,
          "You placed three dots, did you mean to only have one?",
          _common_error_usages);
        return true;

      case DToken.Type.IntegerLiteral:
      case DToken.Type.FloatingPointLiteral:
        _error(current, current.line, current.column, _common_error_msg,
          "Identifiers, such as module names, cannot start with a number.",
          _common_error_usages);
        return true;
      default:

        // Error: Found some illegal token. Probably due to lack of semicolon.
        _error(_last, current.lineEnd, current.columnEnd, _common_error_msg,
          "You probably forgot a semicolon.",
          _common_error_usages);
        return true;
    }
    return true;
  }
}
