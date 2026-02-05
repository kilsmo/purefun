import 'lexer.dart';
import 'token.dart';

void main() {
  final lexer = Lexer(
      '1234567890123456789012345678901234567890 42 7 987654321098765432109876543210');

  Token token;
  do {
    token = lexer.nextToken();
    print(token);
  } while (token.type != TokenType.eof);
}
