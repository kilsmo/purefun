import 'token.dart';
import 'tokenizer.dart';

List<Token> negNormalizer(List<Token> tokens) {
  int i = 0;
  final normalizedTokens = <Token>[];

  while (i < tokens.length) {
    final token = tokens[i];

    if (token.tokenType == TokenType.neg) {
      if (i + 2 >= tokens.length) {
        normalizedTokens.add(Token(
          TokenType.error,
          token.row,
          token.col,
          '',
          token.len,
        ));
        i++;
      } else {
        final next = tokens[i + 1];
        final nextNext = tokens[i + 2];
        if (
          (next.tokenType == TokenType.integer || next.tokenType == TokenType.number) &&
          nextNext.tokenType == TokenType.rParen
        ) {
          normalizedTokens.add(Token(
            next.tokenType,
            token.row,
            token.col,
            '-' + (next.str ?? ''),
            token.len + next.len + nextNext.len,
          ));

          i += 3;
        } else {
          normalizedTokens.add(Token(
            TokenType.error,
            token.row,
            token.col,
            '',
            token.len,
          ));
          i++;
        }
      }
    } else {
      normalizedTokens.add(token);
      i++;
    }
  }

  return normalizedTokens;
}

void main() {
  final tokens = tokenize('(-42.33)');
  final normalizedTokens = negNormalizer(tokens);
  print(tokens.length);
  print(normalizedTokens.length);
}
