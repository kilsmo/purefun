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
    if (pos >= text.length) {
      currentChar = null;
    } else {
      currentChar = text[pos];
    }
  }

  void skipWhitespace() {
    while (currentChar != null && currentChar!.trim().isEmpty) {
      advance();
    }
  }

  Token number() {
    String result = '';
    bool isFloat = false;

    while (currentChar != null &&
        (RegExp(r'[0-9]').hasMatch(currentChar!) || currentChar == '.')) {
      if (currentChar == '.') {
        isFloat = true;
      }
      result += currentChar!;
      advance();
    }

    if (isFloat) {
      return Token(TokenType.numLiteral, double.parse(result));
    } else {
      return Token(TokenType.integer, BigInt.parse(result));
    }
  }

  Token getNextToken() {
    while (currentChar != null) {
      if (currentChar!.trim().isEmpty) {
        skipWhitespace();
        continue;
      }

      if (RegExp(r'[0-9]').hasMatch(currentChar!)) {
        return number();
      }

      if (currentChar == '+') {
        advance();
        return Token(TokenType.plus);
      }

      if (currentChar == '-') {
        advance();
        return Token(TokenType.minus);
      }

      if (currentChar == '*') {
        advance();
        return Token(TokenType.multiply);
      }

      if (currentChar == '/') {
        advance();
        return Token(TokenType.divide);
      }

      if (currentChar == '(') {
        advance();
        return Token(TokenType.leftParen);
      }

      if (currentChar == ')') {
        advance();
        return Token(TokenType.rightParen);
      }

      throw Exception('Unknown char: $currentChar');
    }

    return Token(TokenType.eof);
  }
}
