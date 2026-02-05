import 'token.dart';

class Lexer {
  final String input;
  int pos = 0;

  static final Token eofToken = Token(TokenType.eof);

  Lexer(this.input);

  String get currentChar =>
      pos < input.length ? input[pos] : '\x00';

  void advance() {
    pos++;
  }

  Token nextToken() {
    if (pos >= input.length) {
      return eofToken;
    }

    while (currentChar != '\x00') {
      final ch = currentChar;

      if (_isDigit(ch)) {
        return _integer(); // parse multi-digit integer
      }

      if (ch.trim().isEmpty) {
        advance();
        continue;
      }

      throw Exception('Unexpected char: $ch');
    }

    return eofToken;
  }

  Token _integer() {
    final buffer = StringBuffer();

    while (_isDigit(currentChar)) {
      buffer.write(currentChar);
      advance();
    }

    final value = BigInt.parse(buffer.toString());
    return Token(TokenType.integer, value);
  }

  bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}
