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

  dynamic parse() => _expr();

  // expr ::= term ((PLUS | MINUS) term)*
  dynamic _expr() {
    var result = _term();

    while (currentToken.type == TokenType.plus ||
           currentToken.type == TokenType.minus) {
      final op = currentToken.type;
      _eat(op);
      final rhs = _term();

      // Type check: both operands must match, except division handled separately
      if (_typesMatch(result, rhs)) {
        if (op == TokenType.plus) result = _add(result, rhs);
        else result = _sub(result, rhs);
      } else {
        throw Exception('Type mismatch for $op: $result vs $rhs');
      }
    }

    return result;
  }

  // term ::= factor ((MUL | DIV | INTDIV | MOD) factor)*
  dynamic _term() {
    var result = _factor();

    while (currentToken.type == TokenType.multiply ||
           currentToken.type == TokenType.divide ||
           currentToken.type == TokenType.intDivide ||
           currentToken.type == TokenType.mod) {
      final op = currentToken.type;
      _eat(op);
      final rhs = _factor();

      switch (op) {
        case TokenType.multiply:
          if (!_typesMatch(result, rhs)) throw Exception('Type mismatch for *: $result vs $rhs');
          result = _mul(result, rhs);
          break;
        case TokenType.divide:
          if (!_typesMatch(result, rhs)) throw Exception('Type mismatch for /: $result vs $rhs');
          result = _div(result, rhs);
          break;
        case TokenType.intDivide:
          if (!_isInt(result) || !_isInt(rhs)) throw Exception('// requires integers');
          result = (result as BigInt) ~/ (rhs as BigInt);
          break;
        case TokenType.mod:
          if (!_isInt(result) || !_isInt(rhs)) throw Exception('% requires integers');
          result = (result as BigInt) % (rhs as BigInt);
          break;
        default:
          throw Exception('Unknown operator $op');
      }
    }

    return result;
  }

  // factor ::= intLiteral | numLiteral | '(' expr ')'
  dynamic _factor() {
    if (currentToken.type == TokenType.intLiteral ||
        currentToken.type == TokenType.numLiteral) {
      final value = currentToken.value!;
      _eat(currentToken.type);
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

  // helpers
  bool _typesMatch(dynamic a, dynamic b) => (a is BigInt && b is BigInt) || (a is double && b is double);
  bool _isInt(dynamic a) => a is BigInt;

  dynamic _add(dynamic a, dynamic b) => a + b;
  dynamic _sub(dynamic a, dynamic b) => a - b;
  dynamic _mul(dynamic a, dynamic b) => a * b;

  dynamic _div(dynamic a, dynamic b) {
    // both operands must match type, either BigInt or double
    if (a is BigInt && b is BigInt) return a.toDouble() / b.toDouble();
    if (a is double && b is double) return a / b;
    throw Exception('Type mismatch in division: $a / $b');
}}
