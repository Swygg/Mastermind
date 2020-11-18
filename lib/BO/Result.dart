import 'package:mastermind/BO/EResult.dart';

class Result {
  EResult _eResult;
  int _nbTokensInRightPlace;
  int _nbTokensInBadPlace;

  EResult get eResult => _eResult;
  int get nbTokensInRightPlace => _nbTokensInRightPlace;
  int get nbTokensInBadPlace => _nbTokensInBadPlace;

  Result(EResult eResult, int nbTokensInRightPlace, int nbTokensInBadPlace) {
    _eResult = eResult;
    _nbTokensInRightPlace = nbTokensInRightPlace;
    _nbTokensInBadPlace = nbTokensInBadPlace;
  }
}
