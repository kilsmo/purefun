enum TokenType {
  digit,
  eof,
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);

  @override
  String toString() => 'Token($type, $value)';
}

class Lexer {
  final String input;
  int pos = 0;

  Lexer(this.input);

  String get currentChar =>
      pos < input.length ? input[pos] : '\x00';

  void advance() {
    pos++;
  }

  Token nextToken() {
    while (currentChar != '\x00') {
      final ch = currentChar;

      if (_isDigit(ch)) {
        advance();
        return Token(TokenType.digit, ch);
      }

      if (ch.trim().isEmpty) {
        advance();
        continue;
      }

      throw Exception('Unexpected char: $ch');
    }

    return Token(TokenType.eof, '');
  }

  bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}
