import 'package:flutter/material.dart';
import 'package:mastermind/BLL/ScoresManager.dart';
import 'package:mastermind/BO/Score.dart';

class ScoresPage extends StatefulWidget {
  ScoresPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  ScoresManager _scoresManager;
  List<Score> _scores = List<Score>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex : 10,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _scores.length,
                  itemBuilder: (context, index) {
                    final itemScore = _scores[index];
                    return ListTile(
                      title: Text(
                        'Score ${index + 1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                            fontSize: 20),
                      ),
                      subtitle: Text(
                        'Nb attempts : ${itemScore.nbAttempt}, Time : ${itemScore.nbMinutes.toString().padLeft(2, '0')}m${itemScore.nbSeconds.toString().padLeft(2, '0')}s, date : ${itemScore.date}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
            ),
            Flexible(
              flex : 2,
              child: RaisedButton(
                onPressed: _deleteScores,
                child: Text(
                  'Clear',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    _scoresManager = ScoresManager.getInstance();
    _loadScores();
  }

  void _loadScores() {
    _scoresManager
        .loadScore()
        .then((useless) => {_scores = _scoresManager.scores, setState(() {})});
  }

  void _deleteScores() {
    _scoresManager.clearScores().then((value) => setState(() {}));
  }
}
