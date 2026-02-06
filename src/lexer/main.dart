import 'lexer.dart';
import 'parser.dart';

void main() {
  final examples = [
    '2 + 3',                 // int
    '2.0 + 3.1',             // num
    '(-7) * 3 + 1',          // negative int literal
    '4 / 2',                  // int division returns num
    '4 // 2',                 // int division returns int
    '2 + (3 - 1)',           // parentheses
    '2.5 * (1.2 + 0.3)',     // floating point with parentheses
  ];

  for (var input in examples) {
    final lexer = Lexer(input);
    final parser = Parser(lexer);
    final result = parser.parse();
    print('$input = $result (${result.runtimeType})');
  }
}
