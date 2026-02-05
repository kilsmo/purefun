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
    if (pos >= input.length) return eofToken;

    while (currentChar != '\x00') {
      final ch = currentChar;

      // Handle negative literals: syntax is always '(-digits)'
      if (ch == '(' && _peekNext() == '-') {
        return _negativeInteger();
      }

      if (_isDigit(ch)) {
        return _integer(); // positive integer
      }

      if (ch.trim().isEmpty) {
        advance();
        continue;
      }

      throw Exception('Unexpected char: $ch');
    }

    return eofToken;
  }

  // Read positive integer (multi-digit)
  Token _integer() {
    final buffer = StringBuffer();

    while (_isDigit(currentChar)) {
      buffer.write(currentChar);
      advance();
    }

    final value = BigInt.parse(buffer.toString());
    return Token(TokenType.integer, value);
  }

  // Read negative integer literal in form (-digits)
  Token _negativeInteger() {
    advance(); // skip '('
    advance(); // skip '-'

    final buffer = StringBuffer();
    while (_isDigit(currentChar)) {
      buffer.write(currentChar);
      advance();
    }

    if (currentChar != ')') {
      throw Exception('Expected ")" at end of negative literal');
    }
    advance(); // skip ')'

    final value = BigInt.parse(buffer.toString()) * BigInt.from(-1);
    return Token(TokenType.integer, value);
  }

  bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  // Peek next character without advancing
  String _peekNext() {
    final nextPos = pos + 1;
    if (nextPos >= input.length) return '\x00';
    return input[nextPos];
  }
}
