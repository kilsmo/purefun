import 'token.dart';

class Lexer {
  final String input;
  int pos = 0;

  Lexer(this.input);

  String get currentChar => pos < input.length ? input[pos] : '\x00';

  void advance() => pos++;

  String _peekNext([int offset = 1]) {
    final nextPos = pos + offset;
    return nextPos < input.length ? input[nextPos] : '\x00';
  }

  bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;

  bool _isWhitespace(String ch) => ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r';

  Token nextToken() {
    while (_isWhitespace(currentChar)) advance();

    if (pos >= input.length) return Token(TokenType.eof);

    final ch = currentChar;

    // Negative literal: (-123) or (-3.14)
    if (ch == '(' && _peekNext() == '-') {
      return _negativeLiteral();
    }

    // Numbers
    if (_isDigit(ch)) return _number();

    // Operators
    if (ch == '+') { advance(); return Token(TokenType.plus); }
    if (ch == '-') { advance(); return Token(TokenType.minus); }
    if (ch == '*') { advance(); return Token(TokenType.multiply); }
    if (ch == '/') {
      if (_peekNext() == '/') { advance(); advance(); return Token(TokenType.intDivide); }
      advance(); 
      return Token(TokenType.divide);
    }
    if (ch == '%') { advance(); return Token(TokenType.mod); }

    // Parentheses
    if (ch == '(') { advance(); return Token(TokenType.leftParen); }
    if (ch == ')') { advance(); return Token(TokenType.rightParen); }

    throw Exception('Unexpected character: $ch');
  }

  Token _number() {
    final buffer = StringBuffer();
    bool hasDot = false;

    while (_isDigit(currentChar) || currentChar == '.') {
      if (currentChar == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(currentChar);
      advance();
    }

    final text = buffer.toString();
    if (hasDot) return Token(TokenType.numLiteral, double.parse(text));
    return Token(TokenType.intLiteral, BigInt.parse(text));
  }

  Token _negativeLiteral() {
    advance(); // skip '('
    advance(); // skip '-'

    final buffer = StringBuffer();
    bool hasDot = false;

    while (_isDigit(currentChar) || currentChar == '.') {
      if (currentChar == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      buffer.write(currentChar);
      advance();
    }

    if (currentChar != ')') throw Exception('Expected ")" at end of negative literal');
    advance(); // skip ')'

    final text = buffer.toString();
    if (hasDot) return Token(TokenType.numLiteral, -double.parse(text));
    return Token(TokenType.intLiteral, -BigInt.parse(text));
  }
}
