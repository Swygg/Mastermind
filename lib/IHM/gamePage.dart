import 'package:flutter/material.dart';
import 'package:mastermind/BLL/EngineManager.dart';
import 'package:mastermind/BLL/ScoresManager.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/BO/Options.dart';
import 'package:mastermind/BO/Score.dart';
import 'package:mastermind/Data/DataManager.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  EngineManager engine;
  bool _cheatIsOn = false;
  bool _showGoodAnswer = false;
  final DataManager _dataManager = DataManager.getInstance();
  Options _options;
  List<int> _actualProposal = [];

  final double _widthPossibilities = 50.0;
  final double _heihgtPossibilities = 50.0;
  final double _widthProposal = 40.0;
  final double _heihgtProposal = 40.0;
  final double _widthPreviousAnswers = 20.0;
  final double _heightPreviousAnswer = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _startNewGame,
              color: Colors.white,
              iconSize: 30,
            ),
            IconButton(
              icon: Icon(Icons.panorama_fish_eye),
              onPressed: _changeCheat,
              color: Colors.white,
              iconSize: 30,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getWidgets()),
          ),
        ));
  }

  List<Widget> _getWidgets() {
    var widgets = List<Widget>();
    if (engine != null) {
      //Show token to guess
      widgets.add(_showAnswer());
      widgets.add(Divider());
      widgets.add(_showPreviousAnswers());
      widgets.add(Divider());
      widgets.add(_showActuelProposal());
      widgets.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RaisedButton(
            onPressed: _proposalClear,
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            elevation: 8,
          ),
          RaisedButton(
            onPressed: _actualProposal.length == engine.getCombinationLength()
                ? _proposalAccept
                : null,
            child: Text(
              'Accept',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            elevation: 8,
          ),
        ]),
      );
      widgets.add(Divider());
      //Show  possibilities
      widgets.add(Text("Please make your choice : "));
      widgets.add(_showPossibilities());
    } else {
      widgets.add(Text("Loading..."));
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _firstStart();
  }

  void _firstStart() async {
    _dataManager.loadDataOptions().then((value) => {
          _options = value,
          engine = EngineManager.getInstance(),
          _startNewGame(),
          setState(() {})
        });
  }

  Widget _showActuelProposal() {
    var r = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Actual proposal : "),
      ],
    );
    for (int i = 0; i < _actualProposal.length; i++) {
      r.children.add(
        Image.asset(
          'assets/pictures/${_options.getColors()[_actualProposal[i]]}.png',
          fit: BoxFit.cover,
          width: _widthProposal,
          height: _heihgtProposal,
        ),
      );
    }
    for (int i = 0; i < 4 - _actualProposal.length; i++) {
      r.children.add(
        Image.asset(
          'assets/pictures/Unknown.png',
          fit: BoxFit.cover,
          width: _widthProposal,
          height: _heihgtProposal,
        ),
      );
    }
    return r;
  }

  void _proposalAddProposal(int value) {
    if (_actualProposal.length < engine.getCombinationLength()) {
      _actualProposal.add(value);
    }
    setState(() {});
  }

  void _proposalClear() {
    _actualProposal = List<int>();
    setState(() {});
  }

  void _proposalAccept() {
    var result = engine.compare(_actualProposal);
    switch (result.eResult) {
      case EResult.PlayerWin:
        _showVictoryMessage();
        _maybeAddScore();
        break;
      case EResult.PlayerLose:
        _showGoodAnswer = true;
        _showFailedMessage();
        break;
      default:
        break;
    }
    _proposalClear();
  }

  Widget _showAnswer() {
    if (!_showGoodAnswer) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/pictures/Unknown.png"),
          Image.asset("assets/pictures/Unknown.png"),
          Image.asset("assets/pictures/Unknown.png"),
          Image.asset("assets/pictures/Unknown.png"),
          Text(_cheatIsOn
              ? "${engine.getCombination()[0]}-${engine.getCombination()[1]}-${engine.getCombination()[2]}-${engine.getCombination()[3]}"
              : ""),
        ],
      );
    } else {
      var r = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      );
      for (int i = 0; i < engine.getCombination().length; i++) {
        r.children.add(Image.asset(
            "assets/pictures/${_options.getColors()[engine.getCombination()[i]]}.png"));
      }
      return r;
    }
  }

  Widget _showPossibilities() {
    var colors = new Map<int, String>();
    int tempo = 0;
    for (var key in _options.getColors()) {
      colors[tempo] = key;
      tempo++;
    }

    int iNbColorsOnFirstLine = 6;
    if (colors.length > 6) {
      iNbColorsOnFirstLine = (colors.length / 2).round();
    }

    var row1 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (var i = 0; i < iNbColorsOnFirstLine; i++) {
      row1.children.add(
        GestureDetector(
          onTap: () {
            _proposalAddProposal(i);
          },
          child: Image.asset(
            'assets/pictures/${colors[i]}.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        ),
      );
    }

    var row2 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (var i = iNbColorsOnFirstLine; i < colors.length; i++) {
      row2.children.add(
        GestureDetector(
          onTap: () {
            _proposalAddProposal(i);
          },
          child: Image.asset(
            'assets/pictures/${colors[i]}.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        row1,
        row2,
      ],
    );
  }

  Widget _showPreviousAnswers() {
    var col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    var lastResults = engine.getLastAttemptsAndResults();
    if (lastResults != null) {
      const double _topMarginSize = 1;

      for (int i = 11; i >= 0; i--) {
        var r = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Attempt ${(i + 1).toString().padLeft(2, '0')} - "),
          ],
        );

        if (i >= lastResults.length) {
          for (int j = 0; j < 4; j++) {
            r.children.add(
              Image.asset(
                'assets/pictures/Unknown.png',
                fit: BoxFit.cover,
                width: _widthPreviousAnswers,
                height: _heightPreviousAnswer,
              ),
            );
            r.children.add(Text(" "));
          }
        } else {
          for (var indexToken = 0;
              indexToken < engine.getCombinationLength();
              indexToken++) {
            r.children.add(
              Image.asset(
                'assets/pictures/${_options.getColors()[lastResults[i].combination[indexToken]]}.png',
                fit: BoxFit.cover,
                width: _widthPreviousAnswers,
                height: _heightPreviousAnswer,
              ),
            );
            r.children.add(Text(" "));
          }
          r.children
              .add(Text("OK : ${lastResults[i].result.nbTokensInRightPlace}"));
          r.children.add(Text(" - "));
          r.children
              .add(Text("NOK : ${lastResults[i].result.nbTokensInBadPlace}"));
        }
        col.children.add(Container(
            margin: const EdgeInsets.only(top: _topMarginSize), child: r));
      }
    }
    return col;
  }

  void _startNewGame() {
    engine.generateNewCombination(_options);
    _proposalClear();
  }

  void _changeCheat() {
    _cheatIsOn = !_cheatIsOn;
    setState(() {});
  }

  void _showVictoryMessage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Victory"),
            content: Text("Well done !"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  void _showFailedMessage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Failed"),
            content: Text("Sorry, you lose"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  void _maybeAddScore() {
    ScoresManager scoresManager = ScoresManager.getInstance();

    var difference = engine.end.difference(engine.start);
    var totalSeconds = difference.inSeconds;
    var minutes = (totalSeconds / 60).round();
    var seconds = totalSeconds % 60;
    var formatDate = engine.end.day.toString() + "/" + engine.end.month.toString() + "/" +engine.end.year.toString();

    Score score = Score(engine.getLastAttemptsAndResults().length, seconds,
        minutes, formatDate);

        scoresManager.addNewScore(score);
  }
}
