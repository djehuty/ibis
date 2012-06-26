module parse.d.declarator_suffix_unit;

import parse.d.parameter_list_unit;
import parse.d.expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  DeclaratorSuffix => [ ]
                    | [ Expression ]
                    | [ Type ]
                    | ( TemplateParameterList )? ( ParameterList

*/

class DeclaratorSuffixUnit {
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

  char[] parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return "";
  }

  bool tokenFound(DToken token) {
    switch (_state) {
      case 0:
        // Looking for ( or [
        // Types which have () or [] after them
        switch (token.type) {
          case DToken.Type.LeftParen:
            _state = 1;
            break;
          case DToken.Type.LeftBracket:
            _state = 2;
            break;
          default:
            break;
        }
        break;

      case 1:
        // We have found a ( so we are searching for
        // a right parenthesis
        switch (token.type) {
          case DToken.Type.RightParen:
            // Done
            break;
          default:
            // This is a parameter list
            // XXX:
            _lexer.push(token);
            auto params = (new DParameterListUnit(_lexer, &_error)).parse;
            break;
        }
        return false;

      case 2:
        // We have found a [ so we are searching for
        // a right bracket.
        switch (token.type) {
          case DToken.Type.RightBracket:
            // Done
            return false;

          case DToken.Type.Dot:
            break;

          case DToken.Type.Identifier:
            break;

          default:
            // We should assume it is an expression
            _lexer.push(token);
            auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
            break;
        }
        break;
      default:
        break;
    }
    return true;
  }
}
