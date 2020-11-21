import 'package:mastermind/BO/AttemptAndResult.dart';
import 'package:mastermind/BO/Combination.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/BO/Result.dart';
import 'dart:math';

import 'package:mastermind/BO/Token.dart';
import 'package:mastermind/Tools/ColorsManager.dart';

class EngineManager {
  static EngineManager _instance;
  static const int _nbMaxTry = 12;

  Combination _combination;
  List<AttemptAndResult> _results;

  // ignore: unused_element
  _engineManager() {}

  static EngineManager getInstance() {
    if (_instance == null) {
      _instance = new EngineManager();
    }
    return _instance;
  }

  void generateNewCombination({int combinationLength = 4}) {
    var random = new Random();
    _combination = Combination();
    for (int i = 0; i < combinationLength; i++) {
      var randomNumber = random.nextInt(ColorsManager.getColors().length);
      _combination.addToken(Token(randomNumber));
    }
    _results = List<AttemptAndResult>();
  }

  Result compare(List<int> combination) {
    var tempoRealCombination = _combination.getOnlyIntValue();
    var tempoCombination = [];
    for (int i = 0; i < combination.length; i++) {
      tempoCombination.add(combination[i]);
    }

    var nbInGoodPlace = 0;
    for (var index = 0; index < tempoCombination.length; index++) {
      if (tempoRealCombination[index] == tempoCombination[index]) {
        nbInGoodPlace++;
        tempoRealCombination[index] = -1;
        tempoCombination[index] = -1;
      }
    }
    var nbInBadPlace = 0;
    for (var index = 0; index < tempoCombination.length; index++) {
      if (tempoCombination[index] != -1) {
        for (var index2 = 0; index2 < tempoRealCombination.length; index2++) {
          if (tempoRealCombination[index2] != -1 &&
              tempoRealCombination[index2] == tempoCombination[index]) {
            nbInBadPlace++;
            tempoRealCombination[index] = -1;
            tempoCombination[index] = -1;
          }
        }
      }
    }

    EResult eResult;
    if (nbInGoodPlace == tempoCombination.length) {
      eResult = EResult.PlayerWin;
    } else if (_results.length + 1 > (_nbMaxTry - 1)) {
      eResult = EResult.PlayerLose;
    } else {
      eResult = EResult.PlayerCanContinues;
    }

    var result = Result(eResult, nbInGoodPlace, nbInBadPlace);
    _results.add(AttemptAndResult(combination, result));
    return result;
  }

  List<AttemptAndResult> getLastAttemptsAndResults() {
    return _results;
  }

  int getCombinationLength() {
    return _combination.getValueLength();
  }

  List<int> getCombination() {
    return _combination.getOnlyIntValue();
  }
}
