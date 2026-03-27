import 'token.dart';
import 'tokenizer.dart';

List<Token> spaceNormalizer(List<Token> tokens) {
  int i = 0;
  final normalizedTokens = <Token>[];

  while (i < tokens.length) {
    final token = tokens[i];

    if (token.tokenType != TokenType.space || token.col == 1) {
      normalizedTokens.add(token);
    }

    i++;
  }

  return normalizedTokens;
}

void main() {
  final tokens = tokenize('  42  37\n21 22 ');
  final normalizedTokens = spaceNormalizer(tokens);
  print(tokens.length);
  print(normalizedTokens.length);
}
