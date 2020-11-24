import 'package:mastermind/BO/Score.dart';
import 'package:mastermind/Data/DataManager.dart';

class ScoresManager {
  List<Score> _scores;
  List<Score> get scores => _scores;

  static ScoresManager _instance;
  static int nbMaxScore = 10;

  static ScoresManager getInstance() {
    if (_instance == null) _instance = ScoresManager._();
    return _instance;
  }

  DataManager _dataManager;
  ScoresManager._() {
    _dataManager = DataManager.getInstance();
  }

  void addNewScore(Score score) async {
    if (_scores == null) {
      await loadScore();
    }
    _scores.add(score);
    _scores = orderList(_scores);
    saveScore();
  }

  Future<void> clearScores() async {
    _scores.clear();
    await _dataManager.clearDataScores();
  }

  Future<void> loadScore() async {
    _scores = List<Score>();
    var tempoList = await _dataManager.loadDataScores();
    _scores = orderList(tempoList);
  }

  void saveScore() {
    _dataManager.saveDataScores(_scores);
  }

  List<Score> orderList(List<Score> tempoList) {
    _scores = List<Score>();
    while (tempoList.length > 0) {
      int minAttemps = tempoList[0].nbAttempt;
      int minTime = tempoList[0].nbMinutes * 60 + tempoList[0].nbSeconds;
      int index = 0;
      for (int i = 1; i < tempoList.length; i++) {
        if (tempoList[i].nbAttempt < minAttemps ||
            (tempoList[i].nbAttempt == minAttemps &&
                tempoList[i].nbMinutes * 60 + tempoList[i].nbSeconds <
                    minTime)) {
          minAttemps = tempoList[i].nbAttempt;
          minTime = tempoList[i].nbMinutes * 60 + tempoList[i].nbSeconds;
          index = i;
        }
      }
      _scores.add(tempoList[index]);
      tempoList.removeAt(index);
      if (_scores.length >= nbMaxScore) return _scores;
    }
    return _scores;
  }
}
