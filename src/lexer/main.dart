import 'lexer.dart';
import 'parser.dart';
import 'interpreter.dart';

void run(String input) {
  final lexer = Lexer(input);
  final parser = Parser(lexer);
  final ast = parser.parse();

  final interpreter = Interpreter();
  final result = interpreter.eval(ast);

  print('$input = $result (${result.runtimeType})');
}

void main() {
  run("2 + 3");
  run("2.0 + 3.1");
  run("(-7) * 3 + 1");
  run("(2 + (-3)) * 5");
  run("7 // 2");
  run("7 % 2");
  run("20 // 3 + 1");
  run("(-7) // 3");
  run("7 / 2");
}
