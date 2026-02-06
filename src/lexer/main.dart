import 'lexer.dart';
import 'token.dart';

void main() {
  final lexer = Lexer('2 + (3 - 1) - (-7)');

  Token token;
  do {
    token = lexer.nextToken();
    print(token);
  } while (token.type != TokenType.eof);
}
