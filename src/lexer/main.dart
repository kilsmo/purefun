import 'lexer.dart';
import 'parser.dart';

void testExpression(String expr) {
  final lexer = Lexer(expr);
  final parser = Parser(lexer);
  try {
    final result = parser.parse();
    print('$expr = $result (${result.runtimeType})');
  } catch (e) {
    print('$expr → Error: $e');
  }
}

void main() {
  final tests = [
    // ✅ Valid int operations
    '2 + 3',
    '10 - 7',
    '(-7) * 3 + 1',
    '4 // 2',
    '5 % 2',
    '2 + (3 - 1)',

    // ✅ Valid num operations
    '2.0 + 3.1',
    '4.2 - 1.1',
    '2.5 * (1.2 + 0.3)',
    '10.0 / 4.0',   // division always returns double

    // ✅ int division returning double
    '4 / 2',         // int / int → double
    '3 / 2',         // int / int → double

    // ❌ Mixed type errors (should fail)
    '2 + 3.0',
    '1.5 - 2',
    '4 * 2.0',
    '5 // 2.0',
    '5 % 2.0',
    '3 / 2.0',       // valid because / always returns num, operands must match: 3 (int) / 2.0 (num) → error
  ];

  for (var expr in tests) {
    testExpression(expr);
  }
}
