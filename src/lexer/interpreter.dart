import 'ast.dart';

class Interpreter {
  final Set<String> imports;

  Interpreter({required this.imports});

  dynamic eval(AstNode node) {
    if (node is IntNode) return node.value;
    if (node is NumNode) return node.value;

    if (node is NegativeNode) {
      final val = eval(node.value);
      if (val is BigInt) return -val;
      if (val is double) return -val;
    }

    if (node is BinaryOpNode) {
      final left = eval(node.left);
      final right = eval(node.right);

      if (node.op == '+') return _add(left, right);
      if (node.op == '-') return _sub(left, right);
      if (node.op == '*') return _mul(left, right);
      if (node.op == '/') return _div(left, right);
      if (node.op == '//') return _intDiv(left, right);
      if (node.op == '%') return _mod(left, right);
    }

    if (node is CallNode) {
      if (!imports.contains(node.name)) {
        throw Exception('Function not imported: ${node.name}');
      }
      final argVal = eval(node.arg);
      if (node.name == 'toNum') {
        if (argVal is BigInt) return argVal.toDouble();
        return argVal;
      }
      if (node.name == 'toInt') {
        if (argVal is double) return BigInt.from(argVal);
        return argVal;
      }
    }

    throw Exception('Unknown AST node: $node');
  }

  dynamic evalWithConversions(AstNode node) {
    if (node is BinaryOpNode) {
      var left = evalWithConversions(node.left);
      var right = evalWithConversions(node.right);

      // convert types automatically if functions are imported
      if (left is BigInt && right is double && imports.contains('toNum')) {
        left = left.toDouble();
      } else if (left is double && right is BigInt && imports.contains('toNum')) {
        right = right.toDouble();
      }

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
    } else if (node is CallNode || node is IntNode || node is NumNode || node is NegativeNode) {
      return eval(node);
    }

    throw Exception('Unknown AST node for evalWithConversions: $node');
  }

  dynamic _add(dynamic a, dynamic b) {
    if (a.runtimeType != b.runtimeType) throw Exception('Type mismatch for +');
    return a + b;
  }

  dynamic _sub(dynamic a, dynamic b) {
    if (a.runtimeType != b.runtimeType) throw Exception('Type mismatch for -');
    return a - b;
  }

  dynamic _mul(dynamic a, dynamic b) {
    if (a.runtimeType != b.runtimeType) throw Exception('Type mismatch for *');
    return a * b;
  }

  dynamic _div(dynamic a, dynamic b) {
    if (a is BigInt && b is BigInt) return a.toDouble() / b.toDouble();
    if (a is double && b is double) return a / b;
    throw Exception('Type mismatch for /');
  }

  dynamic _intDiv(dynamic a, dynamic b) {
    if (a is BigInt && b is BigInt) return a ~/ b;
    if (a is double && b is double) return (a ~/ b).toInt();
    throw Exception('Type mismatch for //');
  }

  dynamic _mod(dynamic a, dynamic b) {
    if (a.runtimeType != b.runtimeType) throw Exception('Type mismatch for %');
    return a % b;
  }
}
