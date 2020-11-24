import 'package:flutter/material.dart';
import 'package:mastermind/BO/Options.dart';
import 'package:mastermind/Data/DataManager.dart';

class OptionsPage extends StatefulWidget {
  OptionsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  final DataManager _dataManager = DataManager.getInstance();
  Options _options;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _getColumn(),
      ),
    );
  }

  void initState() {
    super.initState();
    _loadOptions();
  }

  Widget _getColumn() {
    if (_options != null) {
      var col = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Allow color repetition : "),
              Checkbox(
                activeColor: Colors.green,
                value: _options.allowRepetitivColor,
                onChanged: (value) {
                  _options.allowRepetitivColor = !_options.allowRepetitivColor;
                  setState(() {});
                },
              ),
            ],
          ),
          Text("Please select the colors you want in the game (minimum 6) : "),
        ],
      );

      for (var val in _options.colors.keys) {
        col.children.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/pictures/$val.png"),
            Checkbox(
              activeColor: Colors.green,
              value: _options.colors[val],
              onChanged: (value) {
                _changeColorsOptionsValue(val, value);
              },
            ),
          ],
        ));
      }
      col.children.add(
        RaisedButton(
          onPressed: _isButtonClickable() ? _saveOptions : null,
          child: Text(
            'Save options',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          elevation: 8,
        ),
      );
      return SingleChildScrollView(child: col);
    }
    else
      return Text("Loading...");
  }

  void _changeColorsOptionsValue(String key, bool val) {
    if (_options.colors.keys.contains(key)) {
      _options.colors[key] = val;
    }
    setState(() {});
  }

  bool _isButtonClickable() {
    int nbAcceptedColors = 0;
    for (var key in _options.colors.keys) {
      if (_options.colors[key]) {
        nbAcceptedColors++;
      }
    }
    return nbAcceptedColors >= 6;
  }

  void _loadOptions() async {
    _options = await _dataManager.loadValues();

    setState(() {});
  }

  void _saveOptions() {
    if (_isButtonClickable()) {
      _dataManager.saveValues(_options);
      Navigator.of(context).pop();
    } else {
      _showErrorDialog();
    }
  }

  Future<void> _showErrorDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Information"),
            content: Text("You must select at least 6 colors."),
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
