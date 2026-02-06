import 'ast.dart';

class Interpreter {
  Object eval(AstNode node) {
    if (node is IntNode) return node.value;
    if (node is NumNode) return node.value;

    if (node is NegativeNode) {
      final v = eval(node.value);
      if (v is BigInt) return -v;
      if (v is double) return -v;
      throw Exception("Invalid negative type");
    }

    if (node is BinaryOpNode) {
      final left = eval(node.left);
      final right = eval(node.right);

      switch (node.op) {
        case '+':
          return _add(left, right);
        case '-':
          return _sub(left, right);
        case '*':
          return _mul(left, right);
        case '/':
          return _div(left, right);
        case '//':
          return _intDiv(left, right);
        case '%':
          return _mod(left, right);
      }
    }

    throw Exception("Unknown AST node");
  }

  Object _add(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a + b;
    if (a is double && b is double) return a + b;
    throw Exception("Type mismatch +");
  }

  Object _sub(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a - b;
    if (a is double && b is double) return a - b;
    throw Exception("Type mismatch -");
  }

  Object _mul(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a * b;
    if (a is double && b is double) return a * b;
    throw Exception("Type mismatch *");
  }

  Object _div(Object a, Object b) {
    if (a is BigInt && b is BigInt) {
      return a.toDouble() / b.toDouble();
    }
    if (a is double && b is double) return a / b;
    throw Exception("Type mismatch /");
  }

  Object _intDiv(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a ~/ b;
    throw Exception("// only ints");
  }

  Object _mod(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a % b;
    throw Exception("% only ints");
  }
}
