enum TokenType {
  integer,
  eof,
}

class Token {
  final TokenType type;
  final BigInt? value; // BigInt for infinite integers, null for EOF

  Token(this.type, [this.value]);

  @override
  String toString() {
    if (type == TokenType.integer) {
      return 'Token($type, $value)';
    }
    return 'Token($type)';
  }
}
