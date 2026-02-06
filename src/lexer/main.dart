import 'lexer.dart';
import 'token.dart';
import 'parser.dart';

void main() {
  final inputs = [
    '2 + 3 * 4',          // multiplication before addition
    '(2 + 3) * 4',        // parentheses override precedence
    '10 - 6 / 2',         // division before subtraction
    '2 + (3 - 1) * 5',    // combination
    '(-7) * 3 + 1'        // negative literals with multiplication
  ];

  for (final input in inputs) {
    final lexer = Lexer(input);
    final parser = Parser(lexer);
    final result = parser.parse();
    print('$input = $result');
  }
}
