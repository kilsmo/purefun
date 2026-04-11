import 'token.dart';
import 'tokenizer.dart';

const Map<String, TokenType> keywordMap = {
  'bool': TokenType.bool,
  'block': TokenType.block,
  'false': TokenType.false
  'int': TokenType.int,
  'num': TokenType.num,
  'pure': TokenType.pure,
  'record': TokenType.record,
  'self': TokenType.self,
  'side': TokenType.side,
  'string': TokenType.string,
  'true': TokenType.true,
  'variant': TokenType.variant,
};

Token keywordToken(TokenType type, Token original) {
  return Token(
    type,
    original.row,
    original.col,
    '',
    original.len,
  );
}

List<Token> keywordNormalizer(List<Token> tokens) {
  final normalizedTokens = <Token>[];

  for (final token in tokens) {
    if (token.tokenType == TokenType.identifier) {
      final keywordType = keywordMap[token.str];

      if (keywordType != null) {
        normalizedTokens.add(keywordToken(keywordType, token));
        continue;
      }
    }

    normalizedTokens.add(token);
  }

  return normalizedTokens;
}

void main() {
  final tokens = tokenize('  42 pure  37\n21 22 ');
  final normalizedTokens = keywordNormalizer(tokens);

  print(tokens.length);
  print(normalizedTokens.length);
}
