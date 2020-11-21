import 'package:flutter/material.dart';
import 'package:mastermind/BLL/EngineManager.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/Tools/ColorsManager.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  EngineManager engine;
  bool _cheatIsOn = false;

  List<int> _actualProposal = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: startNewGame,
            color: Colors.white,
            iconSize: 30,
          ),
          IconButton(
            icon: Icon(Icons.panorama_fish_eye),
            onPressed: changeCheat,
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Show token to guess
            Row(
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
            ),
            Divider(),
            //Show previous answers
            showPreviousAnswers(),
            Divider(),
            //Show our actual proposal
            showActuelProposal(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              RaisedButton(
                onPressed: proposalClear,
                child: Text(
                  'Clear',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                elevation: 8,
              ),
              RaisedButton(
                onPressed:
                    _actualProposal.length == engine.getCombinationLength()
                        ? proposalAccept
                        : null,
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                elevation: 8,
              ),
            ]),
            Divider(),
            //Show  possibilities
            Text("Please make your choice : "),
            showPossibilities(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    engine = EngineManager.getInstance();
    engine.generateNewCombination();
  }

  Widget showActuelProposal() {
    var colors = ColorsManager.getColors();
    final double _widthPossibilities = 40.0;
    final double _heihgtPossibilities = 40.0;

    var r = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Actual proposal : "),
      ],
    );
    for (int i = 0; i < _actualProposal.length; i++) {
      r.children.add(
        Image.asset(
          'assets/pictures/${colors[_actualProposal[i]]}.png',
          fit: BoxFit.cover,
          width: _widthPossibilities,
          height: _heihgtPossibilities,
        ),
      );
    }
    return r;
  }

  void proposalAddProposal(int value) {
    if (_actualProposal.length < engine.getCombinationLength()) {
      _actualProposal.add(value);
    }
    setState(() {});
  }

  void proposalClear() {
    _actualProposal = List<int>();
    setState(() {});
  }

  void proposalAccept() {
    var result = engine.compare(_actualProposal);
    switch (result.eResult) {
      case EResult.PlayerWin:
        showVictoryMessage();
        break;
      case EResult.PlayerLose:
        showFailedMessage();
        break;
      default:
        break;
    }
    proposalClear();
  }

  Widget showPossibilities() {
    final double _widthPossibilities = 50.0;
    final double _heihgtPossibilities = 50.0;
    var colors = ColorsManager.getColors();
    var row1 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (var i = 0; i < 6; i++) {
      row1.children.add(
        GestureDetector(
          onTap: () {
            proposalAddProposal(i);
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
    for (var i = 6; i < 12; i++) {
      row2.children.add(
        GestureDetector(
          onTap: () {
            proposalAddProposal(i);
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

  Widget showPreviousAnswers() {
    var col = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    var lastResults = engine.getLastAttemptsAndResults();
    final double _widthPossibilities = 20.0;
    final double _heihgtPossibilities = 20.0;
    var colors = ColorsManager.getColors();
    for (int i = 11; i >= 0; i--) {
      var r = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Attempt ${i + 1} - "),
        ],
      );

      if (i >= lastResults.length) {
        r.children.add(
          Image.asset(
            'assets/pictures/Unknown.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        );
        r.children.add(
          Image.asset(
            'assets/pictures/Unknown.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        );
        r.children.add(
          Image.asset(
            'assets/pictures/Unknown.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        );
        r.children.add(
          Image.asset(
            'assets/pictures/Unknown.png',
            fit: BoxFit.cover,
            width: _widthPossibilities,
            height: _heihgtPossibilities,
          ),
        );
      } else {
        for (var indexToken = 0;
            indexToken < engine.getCombinationLength();
            indexToken++) {
          r.children.add(
            Image.asset(
              'assets/pictures/${colors[lastResults[i].combination[indexToken]]}.png',
              fit: BoxFit.cover,
              width: _widthPossibilities,
              height: _heihgtPossibilities,
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
      col.children.add(r);
    }

    return col;
  }

  void startNewGame() {
    engine.generateNewCombination();
    proposalClear();
  }

  void changeCheat() {
    _cheatIsOn = !_cheatIsOn;
    setState(() {});
  }

  void showVictoryMessage() {
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

  void showFailedMessage() {
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
}
