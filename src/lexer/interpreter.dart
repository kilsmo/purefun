import 'ast.dart';

class Interpreter {
  dynamic eval(AstNode node) {
    if (node is IntNode) return node.value;
    if (node is NumNode) return node.value;
    if (node is NegativeNode) return _negate(node.expr);

    if (node is BinaryOpNode) {
      var left = eval(node.left);
      var right = eval(node.right);

      switch (node.op) {
        case '+':
          return _add(left, right);
        case '-':
          return _sub(left, right);
        case '*':
          return _mul(left, right);
        case '/':
          return _div(left, right);      // always returns num
        case '//':
          return _intDiv(left, right);   // returns BigInt
        case '%':
          return _mod(left, right);      // returns BigInt
        default:
          throw Exception('Unknown operator ${node.op}');
      }
    }

    if (node is CallNode) {
      var argValue = eval(node.arg);
      switch (node.name) {
        case 'toNum':
          return argValue is BigInt ? argValue.toDouble() : argValue;
        case 'toInt':
          return argValue is double ? BigInt.from(argValue) : argValue;
        default:
          throw Exception('Unknown function ${node.name}');
      }
    }

    throw Exception('Unknown AST node: $node');
  }

  // helpers
  dynamic _negate(AstNode node) {
    var value = eval(node);
    if (value is BigInt) return -value;
    if (value is double) return -value;
    throw Exception('Invalid type for negation: $value');
  }

  dynamic _add(left, right) {
    if (left.runtimeType != right.runtimeType) throw Exception('Type mismatch for +');
    return left + right;
  }

  dynamic _sub(left, right) {
    if (left.runtimeType != right.runtimeType) throw Exception('Type mismatch for -');
    return left - right;
  }

  dynamic _mul(left, right) {
    if (left.runtimeType != right.runtimeType) throw Exception('Type mismatch for *');
    return left * right;
  }

  num _div(left, right) {
    return (left is BigInt ? left.toDouble() : left) /
           (right is BigInt ? right.toDouble() : right);
  }

  BigInt _intDiv(left, right) {
    if (left is BigInt && right is BigInt) return left ~/ right;
    throw Exception('Integer division requires BigInt');
  }

  BigInt _mod(left, right) {
    if (left is BigInt && right is BigInt) return left % right;
    throw Exception('Modulo requires BigInt');
  }
}
