import 'package:flutter/material.dart';
import 'package:mastermind/Tools/IhmNames.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
            Text("Mastermind"),
            Text("(By Vincent)"),
            RaisedButton(
              onPressed: openGameIHM,
              child: Text(
                'Start New game',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              elevation: 8,
            ),
            RaisedButton(
              onPressed: null,
              child: Text(
                'Resume last game',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              elevation: 8,
            ),
            RaisedButton(
              onPressed: openOptionsIHM,
              child: Text(
                'Options',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              elevation: 8,
            ),
            RaisedButton(
              onPressed: openScoresIHM,
              child: Text(
                'Scores',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              elevation: 8,
            ),
          ],
        ),
      ),
    );
  }

  void openGameIHM() {
    Navigator.pushNamed(context, IHMNames.ihm_GamePage_Name);
  }

  void openOptionsIHM() {
    Navigator.pushNamed(context, IHMNames.ihm_OptionsPage_Name);
  }

  void openScoresIHM() {
    Navigator.pushNamed(context, IHMNames.ihm_ScoresPage_Name);
  }
}
