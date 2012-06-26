module parse.d.if_node;

import parse.d.expression_node;
import parse.d.block_node;

class DIfNode {
private:
  ExpressionNode _expression;
  BlockNode _trueBlock;
  BlockNode _falseBlock;

public:

  this(ExpressionNode e, BlockNode trueBlock, BlockNode falseBlock) {
    _expression = e;
    _trueBlock = trueBlock;
    _falseBlock = falseBlock;
  }

  ExpressionNode expression() {
    return _expression;
  }

  BlockNode trueBlock() {
    return _trueBlock;
  }

  BlockNode falseBlock() {
    return _falseBlock;
  }
}
