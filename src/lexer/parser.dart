import 'lexer.dart';
import 'token.dart';
import 'ast.dart';

class Parser {
  final Lexer lexer;
  late Token currentToken;
  final Set<String> importedFunctions = {};

  Parser(this.lexer) {
    currentToken = lexer.getNextToken();
  }

  // --- parse atom imports ---
  void parseImports() {
    while (currentToken.type == TokenType.identifier &&
        currentToken.value.startsWith('atom')) {
      _eat(TokenType.identifier); // 'atom'
      _eat(TokenType.colon);      // ':'
      while (currentToken.type == TokenType.identifier) {
        importedFunctions.add(currentToken.value);
        _eat(TokenType.identifier);
      }
    }
  }

  void _eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      throw Exception('Unexpected token: $currentToken');
    }
  }

  AstNode parse() => expr();

  AstNode expr() {
    AstNode node = term();
    while (currentToken.type == TokenType.plus ||
        currentToken.type == TokenType.minus) {
      String op = currentToken.type == TokenType.plus ? '+' : '-';
      _eat(currentToken.type);
      node = BinaryOpNode(node, op, term());
    }
    return node;
  }

  AstNode term() {
    AstNode node = factor();
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
          throw Exception('Unknown operator: $currentToken');
      }
      _eat(currentToken.type);
      node = BinaryOpNode(node, op, factor());
    }
    return node;
  }

  AstNode factor() {
    Token tok = currentToken;

    if (tok.type == TokenType.leftParen) {
      _eat(TokenType.leftParen);

      AstNode node;
      // support negative literal inside parentheses only
      if (currentToken.type == TokenType.minus) {
        _eat(TokenType.minus);
        final inner = factor(); // next token must be a literal or parenthesis
        node = NegativeNode(inner);
      } else {
        node = expr();
      }

      _eat(TokenType.rightParen);
      return node;
    } else if (tok.type == TokenType.integer) {
      _eat(TokenType.integer);
      return IntNode(tok.value);
    } else if (tok.type == TokenType.numLiteral) {
      _eat(TokenType.numLiteral);
      return NumNode(tok.value);
    } else if (tok.type == TokenType.identifier) {
      return _identifier();
    }

    throw Exception('Unexpected token in factor: $tok');
  }

  AstNode _identifier() {
    String name = currentToken.value;
    _eat(TokenType.identifier);

    if (currentToken.type == TokenType.leftParen) {
      _eat(TokenType.leftParen);
      AstNode arg = expr();
      _eat(TokenType.rightParen);
      return CallNode(name, arg);
    }

    throw Exception('Unknown identifier usage: $name');
  }
}
