enum TokenType {
  integer,
  plus,
  minus,
  eof,
}

class Token {
  final TokenType type;
  final BigInt? value; // BigInt supports infinite positive/negative integers

  Token(this.type, [this.value]);

  @override
  String toString() {
    if (type == TokenType.integer) {
      return 'Token($type, $value)';
    }
    return 'Token($type)';
  }
}
