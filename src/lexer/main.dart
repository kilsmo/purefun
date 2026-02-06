import 'lexer.dart';
import 'parser.dart';

void run(String input) {
  final lexer = Lexer(input);
  final parser = Parser(lexer);
  final result = parser.parse();
  print('$input = $result (${result.runtimeType})');
}

void main() {
  run("2 + 3");
  run("2.0 + 3.1");
  run("(-7) * 3 + 1");
  run("(2 + (-3)) * 5");
}
