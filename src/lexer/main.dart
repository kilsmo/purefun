import 'lexer.dart';
import 'parser.dart';
import 'interpreter.dart';

void run(String input) {
  final lexer = Lexer(input);
  final parser = Parser(lexer);

  parser.parseImports(); // parse all atom: imports first
  final ast = parser.parse();
  final interpreter = Interpreter(imports: parser.importedFunctions);
  final result = interpreter.evalWithConversions(ast);

  print('$input = $result (${result.runtimeType})\n');
}

void main() {
  run('''
atom:int
  toNum

toNum(7) + 3
''');

  run('7 + 3');

  run('2.0 + 3.1');

  run('''
atom:int
  toNum

(2 + (-3)) * 5
''');

  run('''
atom:int
  toNum

7 // 3
''');

  run('''
atom:int
  toNum

7 % 3
''');
}
