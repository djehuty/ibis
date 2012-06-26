module parse.d.try_statement_unit;

import parse.d.scoped_statement_unit;
import parse.d.block_statement_unit;
import parse.d.basic_type_unit;

import parse.d.lexer;
import parse.d.token;

/*

  try
  TryStatementUnit = ScopedStatement CatchStatements
                   | ScopedStatement CatchStatements finally FinallyStatement
                   | ScopedStatement finally FinallyStatement

  CatchStatements = catch CatchStatement CatchStatements
                  | catch CatchStatement
                  | catch LastCatchStatement

  catch
  CatchStatement = ( BasicType Identifier ) BlockStatement
                 | ( BasicType Identifier ) NonEmptyStatement

  catch
  LastCatchStatement = BlockStatement
                     | NonEmptyStatement

  finally
  FinallyStatement = BlockStatement
                   | NonEmptyStatement


*/

class DTryStatementUnit {
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
    switch (token.type) {
      case DToken.Type.Catch:
        if (_state == 1) {
          _state = 2;
        }
        break;

      case DToken.Type.LeftParen:
        if (_state == 2) {
          // Catch parameter
          _state = 3;
          break;
        }

        goto default;

      case DToken.Type.RightParen:
        if (_state == 5) {
          // Good.
          _state = 6;
        }
        break;

      case DToken.Type.LeftCurly:
        if (_state == 2 || _state == 6) {
          auto catch_stmts = (new DBlockStatementUnit(_lexer, &_error)).parse;
          _state = 1;
          break;
        }
        else if (_state == 7) {
          auto finally_stmts = (new DBlockStatementUnit(_lexer, &_error)).parse;
          // Done.
          return false;
        }

        goto default;

      case DToken.Type.Finally:
        if (_state == 1) {
          _state = 7;
        }
        break;

      case DToken.Type.Identifier:
        if (_state == 4) {
          // Catch parameter name
          _state = 5;
          break;
        }

        goto default;

      default:
        _lexer.push(token);

        if (_state == 0) {
          auto stmts = (new DScopedStatementUnit(_lexer, &_error)).parse;
          _state = 1;
        }
        else if (_state == 3) {
          // Basic Type?
          auto basic_type = (new DBasicTypeUnit(_lexer, &_error)).parse;
          _state = 4;
        }
        else {
          // Done.
          return false;
        }

        break;
    }
    return true;
  }
}
