enum TokenType {
  add, // +
  and, // &&
  bind, // =
  bool, // keyword
  colon, // :
  comma, // ,
  comment, // #
  div, // /
  dot, // .
  eof, // nothing
  eol, // \r, \r\n, or \n
  eq, // ==
  error,
  ge, // >=
  gt, // >
  identifier, // abc123
  inlineBlock, // ->
  int, // keyword
  intDiv, // //
  integer, // 123
  lBracket, // [
  lCurlyBracket, // {
  le, // <=
  lParen, // (
  lt, // <
  mul, // *
  ne, // !=
  neg, // (-
  num, // keyword
  number, // 123.456
  or, // ||
  pure, // keyword
  rBracket, // ]
  rCurlyBracket, // }
  record, // keyword
  rest, // %
  rParen, // )
  side, // keyword
  sideBlock, // =>
  sub, // -
  space, //
  string, // keyword
  text, // 'Hello world' or "Hello world"
  textBlock, // :=
  variant, // keyword
}

class Token {
  Token(this.tokenType, this.row, this.col, this.str, this.len);

  final TokenType tokenType;
  final int row;
  final int col;
  final String? str;
  final int len;
}
