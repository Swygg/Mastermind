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

  void addNewScore(Score score) {
    loadScore().then((value) => {
          if (_scores.length < nbMaxScore) {_scores.add(score), saveScore()}
        });
  }

  Future<void> clearScores() async {
    _scores.clear();
    await _dataManager.clearDataScores();
  }

  Future<void> loadScore() async {
    _scores = await _dataManager.loadDataScores();
  }

  void saveScore() {
    _dataManager.saveDataScores(_scores);
  }
}
