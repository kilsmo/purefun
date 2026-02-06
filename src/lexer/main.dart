import 'lexer.dart';
import 'parser.dart';

void run(String input) {
  final lexer = Lexer(input);
  final parser = Parser(lexer);
  final result = parser.parse();
  print('$input = $result (${result.runtimeType})');
}

void main() {
  run("7 // 2");
  run("7 % 2");
  run("20 // 3 + 1");
  run("(-7) // 3");
  run("7 / 2");
}
