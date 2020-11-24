class Score {
  int _nbAttemps;
  int _nbSeconds;
  int _nbMinutes;
  String _date;

  int get nbAttempt => _nbAttemps;
  int get nbSeconds => _nbSeconds;
  int get nbMinutes => _nbMinutes;
  String get date => _date;

  Score(this._nbAttemps, this._nbSeconds, this._nbMinutes, this._date);
}
