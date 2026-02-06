import 'lexer.dart';
import 'token.dart';

class Parser {
  final Lexer lexer;
  Token currentToken;

  Parser(this.lexer) : currentToken = lexer.nextToken();

  void _eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.nextToken();
    } else {
      throw Exception('Unexpected token: $currentToken, expected $type');
    }
  }

  BigInt parse() => _expr();

  // expr ::= term ((PLUS | MINUS) term)*
  BigInt _expr() {
    BigInt result = _term();

    while (currentToken.type == TokenType.plus ||
        currentToken.type == TokenType.minus) {
      final op = currentToken.type;
      _eat(op);
      final rhs = _term();

      if (op == TokenType.plus) {
        result += rhs;
      } else {
        result -= rhs;
      }
    }

    return result;
  }

  // term ::= factor ((MUL | DIV) factor)*
  BigInt _term() {
    BigInt result = _factor();

    while (currentToken.type == TokenType.multiply ||
        currentToken.type == TokenType.divide) {
      final op = currentToken.type;
      _eat(op);
      final rhs = _factor();

      if (op == TokenType.multiply) {
        result *= rhs;
      } else {
        result ~/= rhs; // integer division
      }
    }

    return result;
  }

  // factor ::= INTEGER | '(' expr ')'
  BigInt _factor() {
    if (currentToken.type == TokenType.intLiteral) {
      final value = currentToken.value! as BigInt;
      _eat(TokenType.intLiteral);
      return value;
    } else if (currentToken.type == TokenType.leftParen) {
      _eat(TokenType.leftParen);
      final value = _expr();
      _eat(TokenType.rightParen);
      return value;
    } else {
      throw Exception('Unexpected token in factor: $currentToken');
    }
  }
}
