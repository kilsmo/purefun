abstract class AstNode {}

class IntNode extends AstNode {
  final BigInt value;
  IntNode(this.value);
}

class NumNode extends AstNode {
  final double value;
  NumNode(this.value);
}

class NegativeNode extends AstNode {
  final AstNode expr; // field name corrected
  NegativeNode(this.expr);
}

class BinaryOpNode extends AstNode {
  final AstNode left;
  final String op;
  final AstNode right;
  BinaryOpNode(this.left, this.op, this.right);
}

class CallNode extends AstNode {
  final String name;
  final AstNode arg;
  CallNode(this.name, this.arg);
}
