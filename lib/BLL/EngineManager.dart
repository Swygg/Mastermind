import 'package:mastermind/BO/Combination.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/BO/Result.dart';
import 'dart:math';

import 'package:mastermind/BO/Token.dart';

class EngineManager {
  static EngineManager _instance;
  static const int _nbMaxTry = 10;

  Combination _combination;
  List<Result> _results;
  int _nbTry;

  // ignore: unused_element
  _engineManager() {}

  EngineManager getInstance() {
    if (_instance == null) {
      _instance = new EngineManager();
    }
    return _instance;
  }

  void generateNewCombination({int combinationLength = 4}) {
    var random = new Random();
    random.nextInt(100);
    _combination = Combination();
    for (int i = 0; i < combinationLength; i++) {
      var randomNumber = random.nextInt(100);
      _combination.addToken(Token(randomNumber));
    }
    _nbTry = 0;
    _results = List<Result>();
  }

  Result compare(Combination combination) {
    _nbTry++;
    var tempoRealCombination1 = _combination.getOnlyIntValue();
    var tempoCombination2 = combination.getOnlyIntValue();

    var nbInGoodPlace = 0;
    for (var index = 0; index < tempoCombination2.length; index++) {
      if (tempoRealCombination1[index] == tempoCombination2[index]) {
        nbInGoodPlace++;
        tempoRealCombination1[index] = -1;
        tempoCombination2[index] = -1;
      }
    }
    var nbInBadPlace = 0;
    for (var index = 0; index < tempoCombination2.length; index++) {
      if (tempoCombination2[index] != -1) {
        for (var index2 = 0; index2 < tempoRealCombination1.length; index2++) {
          if (tempoRealCombination1[index2] != -1 &&
              tempoRealCombination1[index] == tempoCombination2[index]) {
            nbInBadPlace++;
            tempoRealCombination1[index] = -1;
            tempoCombination2[index] = -1;
          }
        }
      }
    }

    EResult eResult;
    if (nbInGoodPlace == tempoCombination2.length) {
      eResult = EResult.PlayerWin;
    } else if (_nbTry > _nbMaxTry) {
      eResult = EResult.PlayerLose;
    } else {
      eResult = EResult.PlayerCanContinues;
    }

    var result = Result(eResult, nbInGoodPlace, nbInBadPlace);
    _results.add(result);
    return result;
  }

  List<Result> getLastResults() {
    return _results;
  }
}
