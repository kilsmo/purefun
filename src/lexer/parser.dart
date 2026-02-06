import 'lexer.dart';
import 'token.dart';
import 'ast.dart';

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

  AstNode parse() {
    return expr();
  }

  AstNode expr() {
    AstNode node = term();

    while (currentToken.type == TokenType.plus ||
        currentToken.type == TokenType.minus) {
      Token op = currentToken;
      if (op.type == TokenType.plus) {
        eat(TokenType.plus);
        node = BinaryOpNode(node, '+', term());
      } else {
        eat(TokenType.minus);
        node = BinaryOpNode(node, '-', term());
      }
    }

    return node;
  }

  AstNode term() {
    AstNode node = factor();

    while (currentToken.type == TokenType.multiply ||
        currentToken.type == TokenType.divide ||
        currentToken.type == TokenType.intDivide ||
        currentToken.type == TokenType.mod) {
      Token op = currentToken;
      if (op.type == TokenType.multiply) {
        eat(TokenType.multiply);
        node = BinaryOpNode(node, '*', factor());
      } else if (op.type == TokenType.divide) {
        eat(TokenType.divide);
        node = BinaryOpNode(node, '/', factor());
      } else if (op.type == TokenType.intDivide) {
        eat(TokenType.intDivide);
        node = BinaryOpNode(node, '//', factor());
      } else if (op.type == TokenType.mod) {
        eat(TokenType.mod);
        node = BinaryOpNode(node, '%', factor());
      }
    }

    return node;
  }

  AstNode factor() {
    Token token = currentToken;

    // integer literal
    if (token.type == TokenType.integer) {
      eat(TokenType.integer);
      return IntNode(token.value as BigInt);
    }

    // double literal
    if (token.type == TokenType.numLiteral) {
      eat(TokenType.numLiteral);
      return NumNode(token.value as double);
    }

    // parentheses or negative literal
    if (token.type == TokenType.leftParen) {
      eat(TokenType.leftParen);

      // negative literal: (-x)
      if (currentToken.type == TokenType.minus) {
        eat(TokenType.minus);
        Token numToken = currentToken;

        if (numToken.type == TokenType.integer) {
          eat(TokenType.integer);
          eat(TokenType.rightParen);
          return NegativeNode(IntNode(numToken.value as BigInt));
        }

        if (numToken.type == TokenType.numLiteral) {
          eat(TokenType.numLiteral);
          eat(TokenType.rightParen);
          return NegativeNode(NumNode(numToken.value as double));
        }

        throw Exception("Invalid negative literal inside parentheses");
      }

      // normal expression inside parentheses
      AstNode node = expr();
      eat(TokenType.rightParen);
      return node;
    }

    throw Exception('Unexpected token: $token');
  }
}
