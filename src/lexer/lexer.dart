import 'token.dart';

class Lexer {
  final String text;
  int pos = 0;
  String? currentChar;

  Lexer(this.text) {
    currentChar = text.isNotEmpty ? text[0] : null;
  }

  void advance() {
    pos++;
    currentChar = pos < text.length ? text[pos] : null;
  }

  void skipWhitespace() {
    while (currentChar != null && currentChar!.trim().isEmpty) {
      advance();
    }
  }

  bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);
  bool _isLetter(String char) => RegExp(r'[a-zA-Z]').hasMatch(char);

  Token integer() {
    String result = '';
    while (currentChar != null && _isDigit(currentChar!)) {
      result += currentChar!;
      advance();
    }
    return Token(TokenType.integer, BigInt.parse(result));
  }

  Token numLiteral() {
    String result = '';
    bool hasDot = false;

    while (currentChar != null &&
        (_isDigit(currentChar!) || currentChar == '.')) {
      if (currentChar == '.') {
        if (hasDot) break;
        hasDot = true;
      }
      result += currentChar!;
      advance();
    }

    return Token(TokenType.numLiteral, double.parse(result));
  }

  Token identifierToken() {
    String result = '';
    while (currentChar != null &&
        (_isLetter(currentChar!) || _isDigit(currentChar!))) {
      result += currentChar!;
      advance();
    }
    return Token(TokenType.identifier, result);
  }

  Token getNextToken() {
    while (currentChar != null) {
      if (currentChar!.trim().isEmpty) {
        skipWhitespace();
        continue;
      }

      if (_isDigit(currentChar!)) {
        int lookahead = pos;
        bool hasDot = false;
        while (lookahead < text.length &&
            (_isDigit(text[lookahead]) || text[lookahead] == '.')) {
          if (text[lookahead] == '.') hasDot = true;
          lookahead++;
        }
        if (hasDot) return numLiteral();
        return integer();
      }

      if (_isLetter(currentChar!)) return identifierToken();

      switch (currentChar) {
        case '+':
          advance();
          return Token(TokenType.plus);
        case '-':
          advance();
          return Token(TokenType.minus);
        case '*':
          advance();
          return Token(TokenType.multiply);
        case '/':
          advance();
          if (currentChar == '/') {
            advance();
            return Token(TokenType.intDivide);
          }
          return Token(TokenType.divide);
        case '%':
          advance();
          return Token(TokenType.mod);
        case '(':
          advance();
          return Token(TokenType.leftParen);
        case ')':
          advance();
          return Token(TokenType.rightParen);
        case ':':
          advance();
          return Token(TokenType.colon);
      }

      throw Exception('Unknown character: $currentChar');
    }

    return Token(TokenType.eof);
  }
}
