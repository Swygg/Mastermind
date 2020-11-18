import 'package:mastermind/BO/Token.dart';

class Combination {
  List<Token> _tokens;

  Combination() {
    _tokens = new List<Token>();
  }

  List<Token> getValue() {
    return _tokens;
  }

  List<int> getOnlyIntValue() {
    var result = List<int>();
    for (var i = 0; i < _tokens.length; i++) {
      result.add(_tokens[i].id);
    }
    return result;
  }

  void setValue(List<Token> tokens) {
    _tokens = tokens;
  }

  void addToken(Token token) {
    _tokens.add(token);
  }

  void clear() {
    _tokens = new List<Token>();
  }

  int getValueLength() {
    return _tokens.length;
  }
}
