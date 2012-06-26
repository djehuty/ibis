module parse.d.template_argument_list_unit;

import parse.d.assign_expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  TemplateArgumentList = ( TemplateArguments )

  TemplateArguments = TemplateArgument
                    | TemplateArgument , TemplateArgumentList

  TemplateArgument = Type
                   | AssignExpression

*/

class DTemplateArgumentListUnit {
private:
  DLexer  _lexer;

  enum State {
    LookingForLeftParen,
    TemplateArguments,
    LookingForRightParen,
  }

  State _state;

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
    if (token.type == DToken.Type.Comment) {
      return false;
    }

    switch (token.type) {
      case DToken.Type.LeftParen:
        if (_state == State.LookingForLeftParen) {
          _state = State.TemplateArguments;
        }
        goto default;

      case DToken.Type.RightParen:
        if (_state == State.LookingForRightParen) {
          // Done.
          return false;
        }
        else if (_state == State.LookingForLeftParen) {
          // Error: Expect left paren.
          return false;
        }
        goto default;

      case DToken.Type.Comma:
        if (_state == State.LookingForRightParen) {
          _state = State.TemplateArguments;
        }
        else {
          // Error: Expecting expression, not comma
          return false;
        }

        break;

      default:
        if (_state == State.LookingForLeftParen) {
          // Error: Expect left paren.
          return false;
        }
        else if (_state == State.LookingForRightParen) {
          // Error: Expecting right paren or comma.
          return false;
        }

        auto expr = (new DAssignExpressionUnit(_lexer, &_error)).parse;
        _state = State.LookingForRightParen;
        break;
    }

    return true;
  }
}
