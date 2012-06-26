module parse.d.primary_expression_unit;

import parse.d.function_literal_expression_disambiguation_unit;
import parse.d.function_literal_unit;
import parse.d.array_literal_disambiguation_unit;
import parse.d.array_literal_unit;
import parse.d.expression_unit;
import parse.d.template_argument_list_unit;

import parse.d.lexer;
import parse.d.token;

/*

*/

class DPrimaryExpressionUnit {
private:
  DLexer  _lexer;

  int    _state;

  char[] _cur_string;

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

    if (_state == 3) {
      if (token.type == DToken.Type.Bang) {
        // Template Argument List
        auto templateList = (new DTemplateArgumentListUnit(_lexer, &_error)).parse;
        // Done.
        return false;
      }
      else {
        // Done.
        _lexer.push(token);
        return false;
      }
    }

    switch (token.type) {
      case DToken.Type.StringLiteral:
      case DToken.Type.CharacterLiteral:
        if (_state == 1) {
          // Error:
          return false;
        }
        _cur_string = token.string;
        return false;

      case DToken.Type.IntegerLiteral:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.Identifier:
        _state = 3;
        return true;

      case DToken.Type.This:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.Null:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.True:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.False:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.Dollar:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.Super:
        if (_state == 1) {
          // Error:
          return false;
        }
        return false;

      case DToken.Type.Dot:
        _state = 1;
        return true;

      case DToken.Type.LeftBracket:
        // Disambiguate between different array literal types:
        auto arrayType = (new DArrayLiteralDisambiguationUnit(_lexer, &_error)).parse;
        if (arrayType == DArrayLiteralDisambiguationUnit.ArrayLiteralVariant.Array) {
          auto array = (new DArrayLiteralUnit(_lexer, &_error)).parse;
        }
        return false;

      case DToken.Type.LeftParen:
        if (_state == 2) {
          // Error: Unexpected left parentheses.
          return false;
        }

        auto isFunctionLiteral = (new DFunctionLiteralExpressionDisambiguationUnit(_lexer, &_error)).parse;

        if (isFunctionLiteral == DFunctionLiteralExpressionDisambiguationUnit.ExpressionVariant.FunctionLiteral) {
          _lexer.push(token);
          auto expr = (new DFunctionLiteralUnit(_lexer, &_error)).parse;
          return false;
        }

        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 2;
        return true;

      case DToken.Type.RightParen:
        if (_state == 2) {
          // Good
          return false;
        }
        else {
          // Maybe the close of the last expression? Let's throw it back.
          // Whichever the case, we are Done here.
          _lexer.push(token);
          return false;
        }
        break;

      case DToken.Type.Function:
      case DToken.Type.Delegate:
      case DToken.Type.Body:
      case DToken.Type.In:
      case DToken.Type.Out:
      case DToken.Type.LeftCurly:
        _lexer.push(token);
        auto expr = (new DFunctionLiteralUnit(_lexer, &_error)).parse;
        return false;

      default:
        break;
    }
    return false;
  }
}
