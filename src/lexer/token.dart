enum TokenType {
  integer,
  numLiteral,
  plus,
  minus,
  multiply,
  divide,
  intDivide,
  mod,
  leftParen,
  rightParen,
  eof,
}

class Token {
  final TokenType type;
  final dynamic value;

  Token(this.type, [this.value]);

  @override
  String toString() {
    if (value != null) return 'Token($type, $value)';
    return 'Token($type)';
  }
}
  