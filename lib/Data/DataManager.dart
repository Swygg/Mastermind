import 'package:mastermind/BLL/ScoresManager.dart';
import 'package:mastermind/BO/Options.dart';
import 'package:mastermind/BO/Score.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  // ignore: unused_element
  DataManager._() {
    _options = new Options();
  }

  static DataManager _instance;
  static DataManager getInstance() {
    if (_instance == null) _instance = DataManager._();
    return _instance;
  }

  Options _options;

  void saveDataOptions(Options options) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _options = options;
    for (var key in options.colors.keys) {
      prefs.setBool(key, options.colors[key]);
    }
    prefs.setBool("repeatColor", options.allowRepetitivColor);
  }

  Future<Options> loadDataOptions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var key in _options.colors.keys) {
      if (prefs.getBool(key) != null) {
        _options.colors[key] = prefs.getBool(key);
      } else {
        _options.colors[key] = true;
      }
    }

    if (prefs.getBool("repeatColor") != null) {
      _options.allowRepetitivColor = prefs.getBool("repeatColor");
    } else {
      _options.allowRepetitivColor = true;
    }

    return _options;
  }

  void saveDataScores(List<Score> scores) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < scores.length; i++) {
      var list = List<String>();
      list.add(scores[i].nbAttempt.toString());
      list.add(scores[i].nbSeconds.toString());
      list.add(scores[i].nbMinutes.toString());
      list.add(scores[i].date);
      prefs.setStringList("Score" + i.toString(), list);
    }
  }

  Future<List<Score>> loadDataScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var scores = new List<Score>();
    for (int i = 0; i < ScoresManager.nbMaxScore; i++) {
      if (prefs.getStringList("Score" + i.toString()) != null) {
        var tempo = prefs.getStringList("Score" + i.toString());
        var nbAttempt = int.parse(tempo[0]);
        var nbSeconds = int.parse(tempo[1]);
        var nbMinutes = int.parse(tempo[2]);
        var dateString = tempo[3];
        var score = Score(nbAttempt, nbSeconds, nbMinutes, dateString);
        scores.add(score);
      }
    }
    return scores;
  }

  Future<void> clearDataScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ScoresManager.nbMaxScore; i++) {
      if (prefs.getStringList("Score" + i.toString()) != null) {
        await prefs.remove("Score" + i.toString());
      }
    }
  }
}
