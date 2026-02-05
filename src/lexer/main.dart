import 'lexer.dart';

void main() {
  print('Debug started');

  final lexer = Lexer('7');
  
  while (true) {
    final token = lexer.nextToken();
    print(token);

    if (token.type == TokenType.eof) {
      break;
    }
  }

  print('Debug finished');
}
