import 'lexer.dart';
import 'token.dart';
import 'parser.dart';

void main() {
  final inputs = [
    '2 + 3 - 1',
    '2 + (3 - 1)',
    '(-7) + 5',
    '2 + (3 - 1) - (-7)'
  ];

  for (final input in inputs) {
    final lexer = Lexer(input);
    final parser = Parser(lexer);
    final result = parser.parse();
    print('$input = $result');
  }
}
