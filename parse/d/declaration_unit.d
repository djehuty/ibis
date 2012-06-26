module parse.d.declaration_unit;

import parse.d.pragma_statement_unit;
import parse.d.static_disambiguation_unit;
import parse.d.static_if_statement_unit;
import parse.d.static_assert_statement_unit;
import parse.d.attribute_unit;
import parse.d.debug_statement_unit;
import parse.d.type_declaration_unit;
import parse.d.class_declaration_unit;
import parse.d.interface_declaration_unit;
import parse.d.enum_declaration_unit;
import parse.d.aggregate_declaration_unit;
import parse.d.import_declaration_unit;
import parse.d.constructor_declaration_unit;
import parse.d.destructor_declaration_unit;
import parse.d.version_statement_unit;

import parse.d.declaration_node;
import parse.d.import_declaration_node;
import parse.d.type_declaration_node;

import parse.d.lexer;
import parse.d.token;

final class DDeclarationUnit {
private:
  DLexer  _lexer;

  DDeclarationNode _declaration;

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

  DDeclarationNode parse() {
    DToken token;

    do {
      token = _lexer.pop();
    } while (tokenFound(token));

    return _declaration;
  }

  bool tokenFound(DToken token) {
    switch (token.type) {
      case DToken.Type.EOF:
        return false;

      case DToken.Type.Comment:
        return true;

      // Module Declaration
      case DToken.Type.Module:
        // Error: The module declaration is found,
        // but it is not at the root of the parse tree.
        _error(token, token.line, token.column,
               "Module declaration should be on one of the first lines of the file.",
               "Did you mean this to be an import instead of a module?", ["module foo.bar;"]);
        break;

      case DToken.Type.Pragma:
        auto stmt = (new DPragmaStatementUnit(_lexer, &_error)).parse;
        break;

      // Static
      case DToken.Type.Static:
        auto staticVariant = (new DStaticDisambiguationUnit(_lexer, &_error)).parse;

        if (staticVariant == DStaticDisambiguationUnit.StaticVariant.StaticIf) {
          auto declaration = (new DStaticIfStatementUnit(_lexer, &_error)).parse;
        }
        else if (staticVariant == DStaticDisambiguationUnit.StaticVariant.StaticAssert) {
          // Get rid of assert token
          _lexer.pop();

          // Get declaration that follows
          _declaration = (new DStaticAssertStatementUnit(_lexer, &_error)).parse;
        }
        else if (staticVariant == DStaticDisambiguationUnit.StaticVariant.StaticConstructor) {
//          _declaration = (new DStaticConstructorStatementUnit(_lexer, &_error)).parse;
        }
        else if (staticVariant == DStaticDisambiguationUnit.StaticVariant.StaticDestructor) {
//          _declaration = (new DStaticDestructorStatementUnit(_lexer, &_error)).parse;
        }
        else if (staticVariant == DStaticDisambiguationUnit.StaticVariant.StaticAttribute) {
          _lexer.push(token);
          _declaration = (new DAttributeUnit(_lexer, &_error)).parse;
        }
        break;

      // Attribute Specifier
      case DToken.Type.Colon:
        // Let the error go to the appropriate place
      case DToken.Type.Const:
      case DToken.Type.Synchronized:
      case DToken.Type.Deprecated:
      case DToken.Type.Final:
      case DToken.Type.Override:
      case DToken.Type.Auto:
      case DToken.Type.Scope:
      case DToken.Type.Private:
      case DToken.Type.Public:
      case DToken.Type.Package:
      case DToken.Type.Protected:
      case DToken.Type.Export:
      case DToken.Type.Extern:
      case DToken.Type.Align:
        _lexer.push(token);
        _declaration = (new DAttributeUnit(_lexer, &_error)).parse;
        break;

      // Import Declaration
      case DToken.Type.Import:
        auto import_path = (new DImportDeclarationUnit(_lexer, &_error)).parse;
        auto type = DDeclarationNode.Type.ImportDeclaration;
        auto node = new DImportDeclarationNode(import_path);
        _declaration = new DDeclarationNode(type, node);
        break;

      // Enum Declaration
      case DToken.Type.Enum:
        auto decl = (new DEnumDeclarationUnit(_lexer, &_error)).parse;
        break;

      // Template Declaration
      case DToken.Type.Template:
        break;

      // Mixin Declaration
      case DToken.Type.Mixin:
        break;

      // Class Declaration
      case DToken.Type.Class:
        auto type = DDeclarationNode.Type.ClassDeclaration;
        auto node = (new DClassDeclarationUnit(_lexer, &_error)).parse;
        _declaration = new DDeclarationNode(type, node);
        break;

      // Interface Declaration
      case DToken.Type.Interface:
        auto decl = (new DInterfaceDeclarationUnit(_lexer, &_error)).parse;
        break;

      // Aggregate Declaration
      case DToken.Type.Struct:
      case DToken.Type.Union:
        auto decl = (new DAggregateDeclarationUnit(_lexer, &_error)).parse;
        break;

      // Constructor Declaration
      case DToken.Type.This:
        auto type = DDeclarationNode.Type.ConstructorDeclaration;
        auto node = (new DConstructorDeclarationUnit(_lexer, &_error)).parse;
        _declaration = new DDeclarationNode(type, node);
        break;

      // Destructor Declaration
      case DToken.Type.Cat:
        auto type = DDeclarationNode.Type.DestructorDeclaration;
        auto node = (new DestructorDeclarationUnit(_lexer, &_error)).parse;
        _declaration = new DDeclarationNode(type, node);
        break;

      // Version Block
      case DToken.Type.Version:
        auto tree = (new DVersionStatementUnit(true, _lexer, &_error)).parse;
        break;

      // Debug Block
      case DToken.Type.Debug:
        auto stmt = (new DDebugStatementUnit(_lexer, &_error)).parse;
        break;

      // Unittest Block
      case DToken.Type.Unittest:
//        auto tree = expand!(UnittestUnit)();
        break;

      // Typedef Declaration
      case DToken.Type.Typedef:
        break;

      // Alias Declaration
      case DToken.Type.Alias:
        break;

      // A random semicolon, can't hurt
      case DToken.Type.Semicolon:
        break;

      // If we cannot figure it out, it must be a Type Declaration
      default:
        _lexer.push(token);
        auto decl = (new DTypeDeclarationUnit(_lexer, &_error)).parse;
        if (decl.type == DTypeDeclarationNode.Type.FunctionDeclaration) {
          auto node = decl.node;
          auto type = DDeclarationNode.Type.FunctionDeclaration;
          _declaration = new DDeclarationNode(type, node);
        }
        else if (decl.type == DTypeDeclarationNode.Type.VariableDeclaration) {
          auto node = decl.node;
          auto type = DDeclarationNode.Type.VariableDeclaration;
          _declaration = new DDeclarationNode(type, node);
        }
        break;
    }
    return false;
  }
}
