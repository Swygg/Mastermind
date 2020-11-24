class Options {
  bool allowRepetitivColor;
  Map<String, bool> colors = {
    "White": false,
    "Yellow": true,
    "Orange": true,
    "Pink": false,
    "Red": true,
    "LightGreen": false,
    "DarkGreen": true,
    "LightBlue": false,
    "DarkBlue": true,
    "Purple": true,
    "Brown": false,
    "Black": false
  };

  Options({bool allow, Map<String, bool> map}) {
    if (allow != null) allowRepetitivColor = allow;
    if (map != null) colors = map;
  }

  List<String> getColors()
  {
    var result = List<String>();
    for(var key in colors.keys)
    {
      if(colors[key])
      {
        result.add(key);
      }
    }
    return result;
  }
}
