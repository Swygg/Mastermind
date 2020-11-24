import 'package:flutter/material.dart';
import 'package:mastermind/BLL/EngineManager.dart';
import 'package:mastermind/BO/EResult.dart';
import 'package:mastermind/BO/Options.dart';
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
                mainAxisAlignment: MainAxisAlignment.center, children: getWidgets()),
          ),
        ));
  }

  List<Widget> getWidgets() {
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
    }
    else
    {
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
    _dataManager.loadValues().then((value) => {
          _options = value,
          engine = EngineManager.getInstance(),
          _startNewGame(),
          setState(() {})
        });
  }

  Widget _showActuelProposal() {
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
          'assets/pictures/${_options.getColors()[_actualProposal[i]]}.png',
          fit: BoxFit.cover,
          width: _widthPossibilities,
          height: _heihgtPossibilities,
        ),
      );
    }
    for (int i = 0; i < 4 - _actualProposal.length; i++) {
      r.children.add(
        Image.asset(
          'assets/pictures/Unknown.png',
          fit: BoxFit.cover,
          width: _widthPossibilities,
          height: _heihgtPossibilities,
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
    final double _widthPossibilities = 50.0;
    final double _heihgtPossibilities = 50.0;

    var colors = new Map<int, String>();
    int a = 0;
    for (var key in _options.getColors()) {
      colors[a] = key;
      a++;
    }

    var row1 = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );
    for (var i = 0; i < 6; i++) {
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
    for (var i = 6; i < colors.length; i++) {
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
      final double _widthPossibilities = 20.0;
      final double _heihgtPossibilities = 20.0;
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
                width: _widthPossibilities,
                height: _heihgtPossibilities,
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
}
