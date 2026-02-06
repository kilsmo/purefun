import 'lexer.dart';
import 'token.dart';

class Parser {
  final Lexer lexer;
  late Token currentToken;

  Parser(this.lexer) {
    currentToken = lexer.getNextToken();
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      throw Exception('Expected $type but got ${currentToken.type}');
    }
  }

  Object parse() {
    return expr();
  }

  Object expr() {
    Object result = term();

    while (currentToken.type == TokenType.plus ||
        currentToken.type == TokenType.minus) {
      Token op = currentToken;

      if (op.type == TokenType.plus) {
        eat(TokenType.plus);
        result = _add(result, term());
      } else {
        eat(TokenType.minus);
        result = _sub(result, term());
      }
    }

    return result;
  }

  Object term() {
    Object result = factor();

    while (currentToken.type == TokenType.multiply ||
        currentToken.type == TokenType.divide) {
      Token op = currentToken;

      if (op.type == TokenType.multiply) {
        eat(TokenType.multiply);
        result = _mul(result, factor());
      } else {
        eat(TokenType.divide);
        result = _div(result, factor());
      }
    }

    return result;
  }

  Object factor() {
    Token token = currentToken;

    if (token.type == TokenType.integer) {
      eat(TokenType.integer);
      return token.value as BigInt;
    }

    if (token.type == TokenType.numLiteral) {
      eat(TokenType.numLiteral);
      return token.value as double;
    }

    if (token.type == TokenType.leftParen) {
      eat(TokenType.leftParen);

      // negative literal: (-5)
      if (currentToken.type == TokenType.minus) {
        eat(TokenType.minus);
        Token numToken = currentToken;

        if (numToken.type == TokenType.integer) {
          eat(TokenType.integer);
          eat(TokenType.rightParen);
          return -(numToken.value as BigInt);
        }

        if (numToken.type == TokenType.numLiteral) {
          eat(TokenType.numLiteral);
          eat(TokenType.rightParen);
          return -(numToken.value as double);
        }

        throw Exception("Invalid negative literal");
      }

      Object result = expr();
      eat(TokenType.rightParen);
      return result;
    }

    throw Exception('Unexpected token: $token');
  }

  Object _add(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a + b;
    if (a is double && b is double) return a + b;
    throw Exception("Type mismatch in +");
  }

  Object _sub(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a - b;
    if (a is double && b is double) return a - b;
    throw Exception("Type mismatch in -");
  }

  Object _mul(Object a, Object b) {
    if (a is BigInt && b is BigInt) return a * b;
    if (a is double && b is double) return a * b;
    throw Exception("Type mismatch in *");
  }

  Object _div(Object a, Object b) {
    if (a is BigInt && b is BigInt) {
      return a.toDouble() / b.toDouble();
    }
    if (a is double && b is double) {
      return a / b;
    }
    throw Exception("Type mismatch in /");
  }
}
