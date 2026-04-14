record Token
  type string
  row int
  col int
  value string
  len int

record CharCode
  and int
  bind int
  colon int
  comma int
  cr int
  div int
  dot int
  doubleQuote int
  gt int
  hash int
  lBracket int
  lCurlyBracket int
  lf int
  lowerCaseA int
  lowerCaseZ int
  lParen int
  lt int
  mul int
  nine intgi
  not int
  or int
  plus int
  rBracket int
  rCurlyBracket int
  rest int
  rParen int
  singleQuote int
  space int
  sub int
  upperCaseA int
  upperCaseZ int
  zero int

charCode = CharCode {
  and: 38,
  bind: 61,
  colon: 58,
  comma: 44,
  cr: 13,
  div: 47,
  dot: 46,
  doubleQuote: 34,
  gt: 62,
  hash: 35,
  lBracket: 91,
  lCurlyBracket: 123,
  lf: 10,
  lowerCaseA: 97,
  lowerCaseZ: 122,
  lParen: 40,
  lt: 60,
  mul: 42,
  nine: 57,
  not: 33,
  or: 124,
  plus: 43,
  rBracket: 93,
  rCurlyBracket: 125,
  rest: 37,
  rParen: 41,
  singleQuote: 39,
  space: 32,
  sub: 45,
  upperCaseA: 65,
  upperCaseZ: 90,
  zero: 48
}

pure isLower(c int) : bool
  c >= charCode.lowerCaseA && c <= charCode.lowerCaseZ

pure isUpper(c int) : bool
  c >= charCode.upperCaseA && c <= charCode.upperCaseZ

pure isDigit(c int) : bool
  c >= charCode.zero && c <= charCode.nine

pure isLetter(c int) : bool
  isLower(c) || isUpper(c)

pure isAlnum(c int) : bool
  isLetter(c) || isDigit(c)

pure tokenize(input string) : List<Token>
  tokenizeLoop(input + "\n", 0, "noToken", 1, 0, empty())

pure tokenizeLoop(input string, i int, state string, row int, lineStart int, tokens List<Token>) : List<Token>
  i >= length(input)
    append(tokens, Token { type: "eof", row: row, col: 1, value: "", len: 0 })
  _ 
    c = charAt(input, i)

    state
      'noToken' -> noToken(input, i, c, row, lineStart, tokens)
      'identifier' -> identifier(input, i, c, row, lineStart, tokens)
      'integer' -> integer(input, i, c, row, lineStart, tokens)
      'number' -> number(input, i, c, row, lineStart, tokens)
      'string' -> stringState(input, i, c, row, lineStart, tokens)
      'comment' -> comment(input, i, c, row, lineStart, tokens)
      'space' -> space(input, i, c, row, lineStart, tokens)
      _ -> tokenizeLoop(input, i + 1, "noToken", row, lineStart, tokens)

pure noToken(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  isLetter(c)
    tokenizeLoop(input, i + 1, "identifier", row, lineStart, tokens)
  isDigit(c)
    tokenizeLoop(input, i + 1, "integer", row, lineStart, tokens)
  _
    c
      charCode.and
        tokenizeLoop(input, i + 1, "and", row, lineStart, tokens)
      charCode.bind
        tokenizeLoop(input, i + 1, "bind", row, lineStart, tokens)
      charCode.colon
        tokenizeLoop(input, i + 1, "colon", row, lineStart, tokens)
      charCode.comma
        addToken("comma", input, i, row, lineStart, tokens, true)
      charCode.cr || charCode.hash
        tokenizeLoop(input, i + 1, "comment", row, lineStart, tokens)
      charCode.div
        tokenizeLoop(input, i + 1, "div", row, lineStart, tokens)
      charCode.dot
        addToken("dot", input, i, row, lineStart, tokens, true)
      charCode.doubleQuote
        tokenizeLoop(input, i + 1, "string", row, lineStart, tokens)
      charCode.gt
        tokenizeLoop(input, i + 1, "gt", row, lineStart, tokens)
      charCode.lBracket
        addToken("lBracket", input, i, row, lineStart, tokens, true)
      charCode.lCurlyBracket
        addToken("lCurlyBracket", input, i, row, lineStart, tokens, true)
      charCode.lf
        addToken("eol", input, i, row + 1, i + 1, tokens, true)
      charCode.lParen
        tokenizeLoop(input, i + 1, "lParen", row, lineStart, tokens)
      charCode.lt
        tokenizeLoop(input, i + 1, "lt", row, lineStart, tokens)
      charCode.mul
        addToken("mul", input, i, row, lineStart, tokens, true)
      charCode.not
        tokenizeLoop(input, i + 1, "not", row, lineStart, tokens)
      charCode.or
        tokenizeLoop(input, i + 1, "or", row, lineStart, tokens)
      charCode.plus
        addToken("add", input, i, row, lineStart, tokens, true)
      charCode.rBracket
        addToken("rBracket", input, i, row, lineStart, tokens, true)
      charCode.rCurlyBracket
        addToken("rCurlyBracket", input, i, row, lineStart, tokens, true)
      charCode.rest
        addToken("rest", input, i, row, lineStart, tokens, true)
      charCode.rParen
        addToken("rParen", input, i, row, lineStart, tokens, true)
      charCode.singleQuote
        tokenizeLoop(input, i + 1, "string", row, lineStart, tokens)
      charCode.space
        tokenizeLoop(input, i + 1, "space", row, lineStart, tokens)
      charCode.sub
        tokenizeLoop(input, i + 1, "sub", row, lineStart, tokens)
      charCode.zero
        tokenizeLoop(input, i + 1, "integer", row, lineStart, tokens)
      _
        addToken("error", input, i, row, lineStart, tokens, true)


pure identifier(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  isAlnum(c)
    tokenizeLoop(input, i + 1, "identifier", row, lineStart, tokens)
  _
    addToken("identifier", input, i, row, lineStart, tokens, false)

pure integer(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  isDigit(c)
    tokenizeLoop(input, i + 1, "integer", row, lineStart, tokens)
  c == charCode.dot
    tokenizeLoop(input, i + 1, "number", row, lineStart, tokens)
  _
    addToken("integer", input, i, row, lineStart, tokens, false)

pure number(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  isDigit(c)
    tokenizeLoop(input, i + 1, "number", row, lineStart, tokens)
  _
    addToken("number", input, i, row, lineStart, tokens, false)

pure stringState(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  c != charCode.doubleQuote
    tokenizeLoop(input, i + 1, "string", row, lineStart, tokens)
  _
    addToken("text", input, i, row, lineStart, tokens, true)

pure comment(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  c != charCode.lf
    tokenizeLoop(input, i + 1, "comment", row, lineStart, tokens)
  _
    tokenizeLoop(input, i + 1, "noToken", row + 1, i + 1, tokens)

pure space(input string, i int, c int, row int, lineStart int, tokens List<Token>) : List<Token>
  c == charCode.space
    tokenizeLoop(input, i + 1, "space", row, lineStart, tokens)
  _
    tokenizeLoop(input, i, "noToken", row, lineStart, tokens)

pure addToken(type string, input string, i int, row int, lineStart int, tokens List<Token>, advance bool) : List<Token>
  prepend(
    Token {
        type: type,
        row: row,
        col: i - lineStart + 1,
        value: "",
        len: 1
    },
    tokens
  )
