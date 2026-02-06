import 'lexer.dart';
import 'token.dart';
import 'ast.dart';
import 'dart:core';

class Parser {
  final Lexer lexer;
  late Token currentToken;

  Parser(this.lexer) {
    currentToken = lexer.getNextToken();
  }

  void _eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      throw Exception('Unexpected token: $currentToken, expected $type');
    }
  }

  /// Parse optional top-level atom imports
  void parseImports() {
    while (currentToken.type == TokenType.identifier) {
      var atomName = currentToken.value as String;
      _eat(TokenType.identifier);

      _eat(TokenType.colon);

      while (currentToken.type == TokenType.identifier) {
        // For now we just skip function names, e.g., toNum, toInt
        _eat(TokenType.identifier);
      }
    }
  }

  AstNode parse() => _expr();

  // --- Expression grammar ---

  // expr: term ((+ | -) term)*
  AstNode _expr() {
    var node = _term();

    while (currentToken.type == TokenType.plus ||
        currentToken.type == TokenType.minus) {
      final op = currentToken.type == TokenType.plus ? '+' : '-';
      _eat(currentToken.type);
      node = BinaryOpNode(node, op, _term());
    }

    return node;
  }

  // term: factor ((* | / | // | %) factor)*
  AstNode _term() {
    var node = _factor();

    while (currentToken.type == TokenType.multiply ||
        currentToken.type == TokenType.divide ||
        currentToken.type == TokenType.intDivide ||
        currentToken.type == TokenType.mod) {
      String op;
      switch (currentToken.type) {
        case TokenType.multiply:
          op = '*';
          break;
        case TokenType.divide:
          op = '/';
          break;
        case TokenType.intDivide:
          op = '//';
          break;
        case TokenType.mod:
          op = '%';
          break;
        default:
          throw Exception('Unexpected operator: $currentToken');
      }
      _eat(currentToken.type);
      node = BinaryOpNode(node, op, _factor());
    }

    return node;
  }

  // factor: INTEGER | NUM | ( '(' expr ')' ) | (-INTEGER/-NUM inside parens) | IDENTIFIER '(' expr ')'
  AstNode _factor() {
    final token = currentToken;

    if (token.type == TokenType.integer) {
      _eat(TokenType.integer);
      return IntNode(token.value as BigInt);
    }

    if (token.type == TokenType.numLiteral) {
      _eat(TokenType.numLiteral);
      return NumNode(token.value as double);
    }

    if (token.type == TokenType.leftParen) {
      _eat(TokenType.leftParen);

      // check for negative literal inside parentheses
      if (currentToken.type == TokenType.minus) {
        _eat(TokenType.minus);
        AstNode valueNode;
        if (currentToken.type == TokenType.integer) {
          valueNode = IntNode(currentToken.value as BigInt);
        } else if (currentToken.type == TokenType.numLiteral) {
          valueNode = NumNode(currentToken.value as double);
        } else {
          throw Exception(
              'Expected integer or num after minus in parentheses');
        }
        _eat(currentToken.type);
        _eat(TokenType.rightParen);
        return NegativeNode(valueNode);
      }

      final node = _expr();
      _eat(TokenType.rightParen);
      return node;
    }

    if (token.type == TokenType.identifier) {
      return _identifier();
    }

    throw Exception('Unexpected token in factor: $token');
  }

  // Handle function calls like toNum(expr) / toInt(expr)
  AstNode _identifier() {
    final name = currentToken.value as String;
    _eat(TokenType.identifier);

    _eat(TokenType.leftParen);
    final argNode = _expr();
    _eat(TokenType.rightParen);

    return CallNode(name, argNode);
  }
}
