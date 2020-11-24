import 'package:mastermind/BO/AttemptAndResult.dart';
import 'package:mastermind/BO/Combination.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/BO/Options.dart';
import 'package:mastermind/BO/Result.dart';
import 'dart:math';
import 'package:mastermind/BO/Token.dart';

class EngineManager {
  static EngineManager _instance;
  static const int _nbMaxTry = 12;

  Combination _combination;
  DateTime _start;
  DateTime _end;
  List<AttemptAndResult> _results;
  Options _options;

  EngineManager._();

  DateTime get start => _start;
  DateTime get end => _end;

  static EngineManager getInstance() {
    if (_instance == null) {
      _instance = EngineManager._();
    }
    return _instance;
  }

  void generateNewCombination(Options options, {int combinationLength = 4}) {
    if (options == null) options = Options();
    _options = options;
    var random = new Random();
    var tempo = List<int>();
    _combination = Combination();
    for (int i = 0; i < combinationLength; i++) {
      var randomNumber = random.nextInt(_options.getColors().length);
      if (_options.allowRepetitivColor || !tempo.contains(randomNumber)) {
        tempo.add(randomNumber);
        _combination.addToken(Token(randomNumber));
      } else {
        i--;
      }
    }
    _results = List<AttemptAndResult>();
  }

  Result compare(List<int> combination) {
    if (_results.length == 0) {
      _start = DateTime.now();
    }

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
    if(result.eResult == EResult.PlayerWin)
    {
      _end = DateTime.now();
    }
    _results.add(AttemptAndResult(combination, result));

    return result;
  }

  List<AttemptAndResult> getLastAttemptsAndResults() {
    if (_results == null) _results = new List<AttemptAndResult>();
    return _results;
  }

  int getCombinationLength() {
    return _combination.getValueLength();
  }

  List<int> getCombination() {
    return _combination.getOnlyIntValue();
  }
}
