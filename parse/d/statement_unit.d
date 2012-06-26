module parse.d.statement_unit;

import parse.d.version_statement_unit;
import parse.d.if_statement_unit;
import parse.d.for_statement_unit;
import parse.d.try_statement_unit;
import parse.d.foreach_statement_unit;
import parse.d.case_statement_unit;
import parse.d.goto_statement_unit;
import parse.d.do_statement_unit;
import parse.d.while_statement_unit;
import parse.d.throw_statement_unit;
import parse.d.switch_statement_unit;
import parse.d.continue_statement_unit;
import parse.d.default_statement_unit;
import parse.d.break_statement_unit;
import parse.d.pragma_statement_unit;
import parse.d.return_statement_unit;
import parse.d.volatile_statement_unit;

import parse.d.expression_declaration_disambiguation_unit;

import parse.d.expression_unit;

import parse.d.type_declaration_unit;

import parse.d.lexer;
import parse.d.token;

class DStatementUnit {
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
    if (_state == 1 && token.type == DToken.Type.Semicolon) {
      // Good.
      return false;
    }
    else if (_state == 1) {
      // Bad. Expected ;
    }

    switch (token.type) {
      case DToken.Type.Version:
        auto stmt = (new DVersionStatementUnit(false, _lexer, &_error)).parse;
        return false;
      case DToken.Type.Debug:
        break;
      case DToken.Type.Static:
        break;
      case DToken.Type.Class:
        break;
      case DToken.Type.Interface:
        break;
      case DToken.Type.Struct:
      case DToken.Type.Union:
        break;
      case DToken.Type.Mixin:
        break;
      case DToken.Type.Template:
        break;
      case DToken.Type.Enum:
        break;
      case DToken.Type.Cat:
        break;
      case DToken.Type.Do:
        auto stmt = (new DoStatementUnit(_lexer, &_error)).parse;
        return false;

      case DToken.Type.While:
        auto stmt = (new DWhileStatementUnit(_lexer, &_error)).parse;
        return false;

      case DToken.Type.If:
        auto stmt = (new DIfStatementUnit(_lexer, &_error)).parse;
        return false;

      case DToken.Type.With:
        break;
      case DToken.Type.For:
        auto stmt = (new DForStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Foreach:
      case DToken.Type.Foreach_reverse:
        auto stmt = (new DForeachStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Synchronized:
        break;
      case DToken.Type.Volatile:
        auto stmt = (new DVolatileStatementUnit(_lexer, &_error)).parse;
        break;
      case DToken.Type.Case:
        auto stmt = (new DCaseStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Switch:
        auto stmt = (new DSwitchStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Default:
        auto stmt = (new DefaultStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Continue:
        auto stmt = (new DContinueStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Break:
        auto stmt = (new DBreakStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Goto:
        auto stmt = (new DGotoStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Return:
        auto stmt = (new DReturnStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Throw:
        auto stmt = (new DThrowStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Scope:
        break;
      case DToken.Type.Try:
        auto stmt = (new DTryStatementUnit(_lexer, &_error)).parse;
        return false;
      case DToken.Type.Pragma:
        auto stmt = (new DPragmaStatementUnit(_lexer, &_error)).parse;
        break;

      // int a = 5;
      case DToken.Type.Bool:
      case DToken.Type.Byte:
      case DToken.Type.Ubyte:
      case DToken.Type.Short:
      case DToken.Type.Ushort:
      case DToken.Type.Int:
      case DToken.Type.Uint:
      case DToken.Type.Long:
      case DToken.Type.Ulong:
      case DToken.Type.Char:
      case DToken.Type.Wchar:
      case DToken.Type.Dchar:
      case DToken.Type.Float:
      case DToken.Type.Double:
      case DToken.Type.Real:
      case DToken.Type.Ifloat:
      case DToken.Type.Idouble:
      case DToken.Type.Ireal:
      case DToken.Type.Cfloat:
      case DToken.Type.Cdouble:
      case DToken.Type.Creal:
      case DToken.Type.Void:
      case DToken.Type.Auto:
        // Declaration
        _lexer.push(token);
        auto decl = (new DTypeDeclarationUnit(_lexer, &_error)).parse;
        return false;

      case DToken.Type.Identifier:
        // OH FUCK
        // I DON'T KNOW. COULD BE AN EXPRESSION:
        //  a = 5;
        // OR A TYPE DECLARATION!
        // size_t foo = 4;

        // Must disambiguate
        auto disambiguation = (new DExpressionDeclarationDisambiguationUnit(_lexer, &_error)).parse;
        if (disambiguation == DExpressionDeclarationDisambiguationUnit.Variant.Expression) {
          _lexer.push(token);
          auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        }
        else {
          _lexer.push(token);
          auto expr = (new DTypeDeclarationUnit(_lexer, &_error)).parse;
        }
        _state = 1;
        break;

      // 2 + 2;
      default:
        _lexer.push(token);
        auto expr = (new DExpressionUnit(_lexer, &_error)).parse;
        _state = 1;
        break;
    }
    return true;
  }
}
