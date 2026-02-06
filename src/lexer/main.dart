import 'lexer.dart';
import 'parser.dart';
import 'interpreter.dart';

void run(String source) {
  print(source.trim());
  final lexer = Lexer(source);
  final parser = Parser(lexer);

  parser.parseImports(); // parse top-level atom imports

  final ast = parser.parse();
  final interpreter = Interpreter();
  final result = interpreter.eval(ast);

  print('= $result (${result.runtimeType})\n');
}

void main() {
  run('''
atom:int
  toNum

toNum(7) + 3
''');

  run('7 + 3');
  run('2.0 + 3.1');
  run('(-7) * 3 + 1');
  run('(2 + (-3)) * 5');
  run('7 // 3');
  run('7 % 3');
  run('(-3.2) + 2.0');
  run('2.0 + (-3.1)');
}
