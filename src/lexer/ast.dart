abstract class AstNode {}

class IntNode extends AstNode {
  final BigInt value;
  IntNode(this.value);
}

class NumNode extends AstNode {
  final double value;
  NumNode(this.value);
}

class BinaryOpNode extends AstNode {
  final AstNode left;
  final String op;
  final AstNode right;

  BinaryOpNode(this.left, this.op, this.right);
}

class NegativeNode extends AstNode {
  final AstNode value;
  NegativeNode(this.value);
}
