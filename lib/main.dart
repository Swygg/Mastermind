import 'package:flutter/material.dart';
import 'package:mastermind/IHM/gamePage.dart';
import 'package:mastermind/IHM/optionsPage.dart';
import 'package:mastermind/IHM/menuPage.dart';
import 'package:mastermind/IHM/scoresPage.dart';
import 'package:mastermind/Tools/IhmNames.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mastermind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MenuPage(title: 'Mastermind'),
      routes: <String, WidgetBuilder>{
        IHMNames.ihm_GamePage_Name: (BuildContext context) => GamePage(title: 'Let''s play !'),
        IHMNames.ihm_OptionsPage_Name: (BuildContext context) => OptionsPage(title: 'Options'),
        IHMNames.ihm_ScoresPage_Name: (BuildContext context) => ScoresPage(title: 'Scores'),
      },
    );
  }
}
