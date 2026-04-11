import 'token.dart';

class Character {
  static const int and = 38;
  static const int bind = 61;
  static const int colon = 58;
  static const int comma = 44;
  static const int cr = 13;
  static const int div = 47;
  static const int dot = 46;
  static const int doubleQuote = 34;
  static const int gt = 62;
  static const int hash = 35;
  static const int lBracket = 91;
  static const int lCurlyBracket = 123;
  static const int lf = 10;
  static const int lowerCaseA = 97;
  static const int lowerCaseZ = 122;
  static const int lParen = 40;
  static const int lt = 60;
  static const int mul = 42;
  static const int nine = 57;
  static const int not = 33;
  static const int or = 124;
  static const int plus = 43;
  static const int rBracket = 93;
  static const int rCurlyBracket = 125;
  static const int rest = 37;
  static const int rParen = 41;
  static const int singleQuote = 39;
  static const int space = 32;
  static const int sub = 45;
  static const int upperCaseA = 65;
  static const int upperCaseZ = 90;
  static const int zero = 48;
}

bool isLower(int c) => c >= Character.lowerCaseA && c <= Character.lowerCaseZ;
bool isUpper(int c) => c >= Character.upperCaseA && c <= Character.upperCaseZ;
bool isDigit(int c) => c >= Character.zero && c <= Character.nine;
bool isLetter(int c) => isLower(c) || isUpper(c);
bool isAlnum(int c) => isLetter(c) || isDigit(c);

String stringifyTokenType(Token token) {
  TokenType tokenType = token.tokenType;
  switch (tokenType) {
    case TokenType.add: return 'add';
    case TokenType.and: return 'and';
    case TokenType.bind: return 'bind';
    case TokenType.block: return 'block';
    case TokenType.bool: return 'bool';
    case TokenType.colon: return 'colon';
    case TokenType.comma: return 'comma';
    case TokenType.comment: return 'comment';
    case TokenType.div: return 'div';
    case TokenType.dot: return 'dot';
    case TokenType.eof: return 'eof';
    case TokenType.eol: return 'eol';
    case TokenType.eq: return 'eq';
    case TokenType.error: return 'error';
    case TokenType.false: return 'false';
    case TokenType.ge: return 'ge';
    case TokenType.gt: return 'gt';
    case TokenType.identifier: return 'identifier';
    case TokenType.inlineBlock: return 'inlineBlock';
    case TokenType.int: return 'int';
    case TokenType.intDiv: return 'intDiv';
    case TokenType.integer: return 'integer';
    case TokenType.lBracket: return 'lBracket';
    case TokenType.lCurlyBracket: return 'lCurlyBracket';
    case TokenType.le: return 'le';
    case TokenType.lParen: return 'lParen';
    case TokenType.lt: return 'lt';
    case TokenType.mul: return 'mul';
    case TokenType.ne: return 'ne';
    case TokenType.neg: return 'neg';
    case TokenType.num: return 'num';
    case TokenType.number: return 'number';
    case TokenType.or: return 'or';
    case TokenType.pure: return 'pure';
    case TokenType.rBracket: return 'rBracket';
    case TokenType.rCurlyBracket: return 'rCurlyBracket';
    case TokenType.record: return 'record';
    case TokenType.rest: return 'rest';
    case TokenType.rParen: return 'rParen';
    case TokenType.self: return 'self';
    case TokenType.side: return 'side';
    case TokenType.sideBlock: return 'sideBlock';
    case TokenType.space: return 'space';
    case TokenType.string: return 'string';
    case TokenType.sub: return 'sub';
    case TokenType.text: return 'text';
    case TokenType.true: return 'true';
    case TokenType.variant: return 'variant';
  }
}

enum TokenizeState {
  and, // (&) [&&]
  bind, // = [== =>]
  comment, // # a comment
  cr, // Cr
  div, // / [//]
  doubleQuote, // "abc hi"
  gt, // > [>=]
  identifier, // abc123
  integer, // 42
  integerDot, // 2.
  lParen, // ( [(-]
  lt, // < [<=]
  noToken,
  number, // 1.5
  not, // (!) !=
  or, // (|) ||
  singleQuote, // 'abc hello'
  space, // ' '
  sub, // - [->]
  zero, // 0
}

class ConsumeResult {
  final TokenizeState nextState; // Only use if !generateToken
  final bool generateToken;
  final TokenType tokenType;
  final IncludeString includeString;
  final bool advance;
  final bool isEol;

  ConsumeResult(
    this.nextState,
    this.generateToken,
    this.tokenType,
    this.includeString,
    this.advance,
    this.isEol
  );
}

enum IncludeString {
  yes, // identifier, integer, number
  no, // operators (keywords are like operators)
  skipEnds, // singleQuote or doubleQuote string
  skipStart, // comment
  len, // Spaces length
}

class Consume {
  
  static ConsumeResult tokenResult(
    TokenType tokenType,
    IncludeString includeString,
    bool advance) {
    return ConsumeResult(
      TokenizeState.noToken,
      true,
      tokenType,
      includeString,
      advance,
      tokenType == TokenType.eol
    );
  }

  static ConsumeResult and(int c) {
    if (c == Character.and) {
      return operatorResult(TokenType.and, true);
    } else {
      return tokenResult(TokenType.error, IncludeString.no, true);
    }
  }

  static ConsumeResult bind(int c) {
    if (c == Character.bind) {
      return operatorResult(TokenType.eq, true);
    } else if (c == Character.gt) {
      return operatorResult(TokenType.sideBlock, true);
    } else {
      return operatorResult(TokenType.bind, false);
    }
  }

  static ConsumeResult comment(int c) {
    if (c == Character.cr || c == Character.lf) {
      return tokenResult(TokenType.comment, IncludeString.skipStart, false);
    } else {
      return stateResult(TokenizeState.comment);
    }
  }

  static ConsumeResult consume(TokenizeState tokenizeState, int c) {
    switch (tokenizeState) {
      case TokenizeState.and:
        return Consume.and(c);
      case TokenizeState.bind:
        return Consume.bind(c);
      case TokenizeState.comment:
        return Consume.comment(c);
      case TokenizeState.cr:
        return Consume.cr(c);
      case TokenizeState.div:
        return Consume.div(c);
      case TokenizeState.doubleQuote:
        return Consume.doubleQuote(c);
      case TokenizeState.gt:
        return Consume.gt(c);
      case TokenizeState.identifier:
        return Consume.identifier(c);
      case TokenizeState.integer:
        return Consume.integer(c);
      case TokenizeState.integerDot:
        return Consume.integerDot(c);
      case TokenizeState.lParen:
        return Consume.lParen(c);
      case TokenizeState.lt:
        return Consume.lt(c);
      case TokenizeState.not:
        return Consume.not(c);
      case TokenizeState.noToken:
        return Consume.noToken(c);
      case TokenizeState.number:
        return Consume.number(c);
      case TokenizeState.or:
        return Consume.or(c);
      case TokenizeState.singleQuote:
        return Consume.singleQuote(c);
      case TokenizeState.space:
        return Consume.space(c);
      case TokenizeState.sub:
        return Consume.sub(c);
      case TokenizeState.zero:
        return Consume.zero(c);
    }
  }

  static ConsumeResult cr(int c) {
    if (c == Character.lf) {
      return operatorResult(TokenType.eol, true);
    } else {
      return operatorResult(TokenType.eol, false);
    }
  }

  static ConsumeResult div(int c) {
    if (c == Character.div) {
      return operatorResult(TokenType.intDiv, true);
    } else {
      return operatorResult(TokenType.div, false);
    }
  }

  static ConsumeResult doubleQuote(int c) {
    if (c == Character.doubleQuote) {
      return tokenResult(TokenType.string, IncludeString.skipEnds, true);
    }
    else if (c == Character.cr || c == Character.lf) {
      return tokenResult(TokenType.error, IncludeString.no, false);
    }
    else {
      return stateResult(TokenizeState.doubleQuote);
    }
  }

  static ConsumeResult gt(int c) {
    if (c == Character.bind) {
      return operatorResult(TokenType.ge, true);
    } else {
      return operatorResult(TokenType.gt, false);
    }
  }

  static ConsumeResult identifier(int c) {
    if (isAlnum(c)) {
      return stateResult(TokenizeState.identifier);
    } else {
      return tokenResult(TokenType.identifier, IncludeString.yes, false);
    }
  }

  static ConsumeResult integer(int c) {
    if (c == Character.dot) {
      return stateResult(TokenizeState.integerDot);
    } else if (isDigit(c)) {
      return stateResult(TokenizeState.integer);
    } else {
      return tokenResult(TokenType.integer, IncludeString.yes, false);
    }
  }

  static ConsumeResult integerDot(int c) {
    if (isDigit(c)) {
      return stateResult(TokenizeState.number);
    } else {
      return tokenResult(TokenType.error, IncludeString.no, false);
    }
  }

  static ConsumeResult lParen(int c) {
    if (c == Character.sub) {
      return operatorResult(TokenType.neg, true);
    } else {
      return operatorResult(TokenType.lParen, false);
    }
  }

  static ConsumeResult lt(int c) {
    if (c == Character.bind) {
      return operatorResult(TokenType.le, true);
    } else {
      return operatorResult(TokenType.lt, false);
    }
  }

  static ConsumeResult not(int c) {
    if (c != Character.bind) {
      return operatorResult(TokenType.error, false);
    } else {
      return operatorResult(TokenType.ne, true);
    }
  }

  static ConsumeResult noToken(int c) {
    if (isLetter(c)) {
      return stateResult(TokenizeState.identifier);
    } else if (isDigit(c)) {
      return stateResult(TokenizeState.integer);
    } else {
      switch (c) {
        case Character.and:
          return stateResult(TokenizeState.and);
        case Character.bind:
          return stateResult(TokenizeState.bind);
        case Character.colon:
          return tokenResult(TokenType.colon, IncludeString.no, true);
        case Character.comma:
          return tokenResult(TokenType.comma, IncludeString.no, true);
        case Character.cr:
          return stateResult(TokenizeState.cr);
        case Character.div:
          return stateResult(TokenizeState.div);
        case Character.dot:
          return tokenResult(TokenType.dot, IncludeString.no, true);
        case Character.doubleQuote:
          return stateResult(TokenizeState.doubleQuote);
        case Character.gt:
          return stateResult(TokenizeState.gt);
        case Character.hash:
          return stateResult(TokenizeState.comment);
        case Character.lBracket:
          return tokenResult(TokenType.lBracket, IncludeString.no, true);
        case Character.lCurlyBracket:
          return tokenResult(TokenType.lCurlyBracket, IncludeString.no, true);
        case Character.lf:
          return tokenResult(TokenType.eol, IncludeString.no, true);
        case Character.lParen:
          return stateResult(TokenizeState.lParen);
        case Character.lt:
          return stateResult(TokenizeState.lt);
        case Character.mul:
          return tokenResult(TokenType.mul, IncludeString.no, true);
        case Character.not:
          return stateResult(TokenizeState.not);
        case Character.or:
          return stateResult(TokenizeState.or);
        case Character.plus:
          return tokenResult(TokenType.add, IncludeString.no, true);
        case Character.rBracket:
          return tokenResult(TokenType.rBracket, IncludeString.no, true);
        case Character.rCurlyBracket:
          return tokenResult(TokenType.rCurlyBracket, IncludeString.no, true);
        case Character.rest:
          return tokenResult(TokenType.rest, IncludeString.no, true);
        case Character.rParen:
          return tokenResult(TokenType.rParen, IncludeString.no, true);
        case Character.singleQuote:
          return stateResult(TokenizeState.singleQuote);
        case Character.space:
          return stateResult(TokenizeState.space);
        case Character.sub:
          return stateResult(TokenizeState.sub);
        case Character.zero:
          return stateResult(TokenizeState.zero);
        default:
          return tokenResult(TokenType.error, IncludeString.no, true);
      }
    }
  }

  static ConsumeResult number(int c) {
    if (isDigit(c)) {
      return stateResult(TokenizeState.number);
    } else {
      return tokenResult(TokenType.number, IncludeString.yes, false);
    }
  }

  static ConsumeResult operatorResult(TokenType tokenType, bool advance) {
    return tokenResult(tokenType, IncludeString.no, advance);
  }

  static ConsumeResult or(int c) {
    if (c != Character.or) {
      return operatorResult(TokenType.error, false);
    } else {
      return operatorResult(TokenType.or, true);
    }
  }

  static ConsumeResult singleQuote(int c) {
    if (c == Character.singleQuote) {
      return tokenResult(TokenType.string, IncludeString.skipEnds, true);
    }
    else if (c == Character.cr || c == Character.lf) {
      return tokenResult(TokenType.error, IncludeString.no, false);
    }
    else {
      return stateResult(TokenizeState.singleQuote);
    }
  }

  static ConsumeResult space(int c) {
    if (c == Character.space) {
      return stateResult(TokenizeState.space);
    } else {
      return tokenResult(TokenType.space, IncludeString.len, false);
    }
  }

  static ConsumeResult stateResult(TokenizeState state) {
    return ConsumeResult(
      state,
      false,
      TokenType.error,
      IncludeString.no,
      true,
      false
    );
  }

  static ConsumeResult sub(int c) {
    if (c == Character.gt) {
      return operatorResult(TokenType.inlineBlock, true);
    } else {
      return operatorResult(TokenType.sub, false);
    }
  }

  static ConsumeResult zero(int c) {
    if (c == Character.dot) {
      return stateResult(TokenizeState.integerDot);
    } else if (isAlnum(c)) {
      return tokenResult(TokenType.error, IncludeString.no, true);
    }  else {
      return tokenResult(TokenType.integer, IncludeString.yes, false);
    }
  }
}

List<Token> tokenize(String input) {
  final tokenString = input + String.fromCharCode(Character.lf);
  final tokens = <Token>[];

  var row = 1;
  var i = 0;
  var start = 0;
  var lineStart = 0;
  var state = TokenizeState.noToken;

  while (i < tokenString.length - 1 || (i == tokenString.length - 1 && state != TokenizeState.noToken)) {
    final c = tokenString.codeUnitAt(i);
    final consumeResult = Consume.consume(state, c);

    if (consumeResult.generateToken) {
      final tokenStart = start;
      final tokenEnd = consumeResult.advance ? i + 1 : i;
      final tokenLen = tokenEnd - tokenStart;
      final tokenCol = tokenStart - lineStart + 1;

      String tokenStr = '';

      switch (consumeResult.includeString) {
        case IncludeString.yes:
          tokenStr = tokenString.substring(tokenStart, tokenEnd);
          break;
        case IncludeString.skipEnds:
          tokenStr = tokenString.substring(tokenStart + 1, tokenEnd - 1);
          break;
        case IncludeString.skipStart:
          tokenStr = tokenString.substring(tokenStart + 1, tokenEnd);
          break;
        case IncludeString.len:
          tokenStr = '';
          break;
        case IncludeString.no:
          tokenStr = '';
          break;
      }

      tokens.add(Token(
        consumeResult.tokenType,
        row,
        tokenCol,
        tokenStr,
        tokenLen
      ));

      start = tokenEnd;
      state = TokenizeState.noToken;
    } else {
      state = consumeResult.nextState;
    }

    if (consumeResult.advance) {
      i++;
    }

    if (consumeResult.isEol) {
      row++;
      lineStart = i;
      start = i;
    }
  }

  final eofCol = i - lineStart + 1;

  tokens.add(Token(TokenType.eof, row, eofCol, '', 0));
  return tokens;
}

void runTokenizerTests() {
  List<Token> tokens = tokenize('a\nb\n  c');
  for (final token in tokens) {
    print(stringifyTokenType(token));
  }
}

/*
void main() {
  runTokenizerTests();
}
*/
