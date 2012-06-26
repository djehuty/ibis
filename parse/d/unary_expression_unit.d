module parse.d.unary_expression_unit;

import parse.d.postfix_expression_unit;
import parse.d.cast_expression_unit;
import parse.d.new_expression_unit;

import parse.d.lexer;
import parse.d.token;

/*

  UnaryExpr => & UnaryExpr
             | ++ UnaryExpr
             | -- UnaryExpr
             | * UnaryExpr
             | - UnaryExpr
             | + UnaryExpr
             | ! UnaryExpr
             | ~ UnaryExpr
             | ( Type ) . Identifier
             | NewExpression
             | delete UnaryExpression
             | CastExpression
             | PostfixExpression

*/

class DUnaryExpressionUnit {
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
    if (token.type == DToken.Type.Comment) {
      return true;
    }

    switch (token.type) {
      case DToken.Type.Cast:
        auto cast_expr = (new DCastExpressionUnit(_lexer, &_error)).parse;
        return false;

      // ComplementExpression: ~x
      case DToken.Type.Cat:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // DereferenceExpression: *x
      case DToken.Type.Mul:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // NegativeExpression: -x
      case DToken.Type.Sub:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // NotExpression: !x
      case DToken.Type.Bang:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // PositiveExpression: +x
      case DToken.Type.Add:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // PreIncrementExpression: ++x
      case DToken.Type.Increment:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // PreDecrementExpression: --x
      case DToken.Type.Decrement:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // ReferenceExpression: &x
      case DToken.Type.And:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // DeleteExpression: delete x
      case DToken.Type.Delete:
        auto expr = (new DUnaryExpressionUnit(_lexer, &_error)).parse;
        return false;

      // NewExpression: new Dx
      case DToken.Type.New:
        auto expr = (new DNewExpressionUnit(_lexer, &_error)).parse;
        return false;

      default:
        _lexer.push(token);
        auto expr = (new DPostfixExpressionUnit(_lexer, &_error)).parse;
        break;
    }

    return false;
  }
}
