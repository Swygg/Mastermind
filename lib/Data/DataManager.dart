import 'package:mastermind/BO/Options.dart';
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

  void saveValues(Options options) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _options = options;
    for (var key in options.colors.keys) {
      prefs.setBool(key, options.colors[key]);
    }
    prefs.setBool("repeatColor", options.allowRepetitivColor);
  }

  Future<Options> loadValues() async {
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
}
