enum TokenType {
  intLiteral,    // BigInt
  numLiteral,    // double
  plus,          // '+'
  minus,         // '-'
  multiply,      // '*'
  divide,        // '/'
  intDivide,     // '//'
  mod,           // '%'
  leftParen,     // '('
  rightParen,    // ')'
  eof,
}

class Token {
  final TokenType type;
  final dynamic value; // BigInt for intLiteral, double for numLiteral

  Token(this.type, [this.value]);

  @override
  String toString() {
    if (value != null) return 'Token($type, $value)';
    return 'Token($type)';
  }
}
