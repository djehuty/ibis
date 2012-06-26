module parse.d.function_node;

import parse.d.statement_node;
import parse.d.variable_declaration_node;
import parse.d.type_node;

class DFunctionNode {
private:
  char[]                    _name;
  DStatementNode[]           _bodyBlock;
  DStatementNode[]           _inBlock;
  DStatementNode[]           _outBlock;
  DVariableDeclarationNode[] _params;
  DTypeNode                  _returnType;
  char[]                    _comment;

public:
  this(char[] name,
       DTypeNode returnType,
       DVariableDeclarationNode[] params,
       DStatementNode[] bodyBlock,
       DStatementNode[] inBlock,
       DStatementNode[] outBlock,
       char[]           comment = null) {

    _name = name.dup;
    _bodyBlock = bodyBlock.dup;
    _inBlock = inBlock.dup;
    _outBlock = outBlock.dup;
    _params = params.dup;
    _comment = comment.dup;
    _returnType = returnType;
  }

  char[] name() {
    return _name.dup;
  }

  DTypeNode returnType() {
    return _returnType;
  }

  DStatementNode[] bodyBlock() {
    return _bodyBlock.dup;
  }

  DStatementNode[] inBlock() {
    return _inBlock.dup;
  }

  DStatementNode[] outBlock() {
    return _outBlock.dup;
  }

  DVariableDeclarationNode[] parameters() {
    return _params.dup;
  }

  char[] comment() {
    return _comment.dup;
  }
}
