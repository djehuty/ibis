module parse.d.function_literal_expression_disambiguation_unit;

import parse.d.lexer;
import parse.d.token;

/*

  It is a function literal when the following matches:

  (
  FunctionLiteralExpressionDisambiguation = (NotParen)* ) {
                                          | (NotParen)* ( AnyParenthesized ) {

  (
  AnyParenthesized = (NotParen)* )
                   | (NotParen)* ( AnyParenthesized AnyParenthesized

*/

class DFunctionLiteralExpressionDisambiguationUnit {
public:
  enum ExpressionVariant {
    FunctionLiteral,
    Expression,
  }

private:
  DLexer  _lexer;

  int    _state;

  DToken[] _tokens;

  ExpressionVariant _variant;

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

  ExpressionVariant parse() {
    // Starts with a left paren already consumed.
    _state = 1;

    DToken token;

    do {
      token = _lexer.pop();
      _tokens ~= token;
    } while (tokenFound(token));

    foreach_reverse(t; _tokens) {
      _lexer.push(t);
    }

    return _variant;
  }

  bool tokenFound(DToken token) {
    if (token.type == DToken.Type.Comment) {
      return true;
    }

    if (token.type == DToken.Type.LeftParen) {
      if (_state == 0) {
        // Hmm. An error is likely, but not a function literal for that matter.
        _variant = ExpressionVariant.Expression;
        return false;
      }
      _state++;
    }
    else if (token.type == DToken.Type.RightParen) {
      _state--;

      if (_state < 0) {
        // It is an expression since the right paren appears awkwardly
        // meaning that this is a parenthesized expression within another.
        _variant = ExpressionVariant.Expression;
        return false;
      }
    }
    else if (token.type == DToken.Type.LeftCurly) {
      if (_state == 0) {
        // Function Literal
        _variant = ExpressionVariant.FunctionLiteral;
        return false;
      }
    }
    else if (_state == 0) {
      // { should appear directly outside of the parameter list. It does not.
      _variant = ExpressionVariant.Expression;
      return false;
    }

    return true;
  }
}
