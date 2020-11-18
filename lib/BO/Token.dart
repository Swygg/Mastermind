import 'dart:ui';

class Token {
  int _id;
  Picture _picture;

  int get id => _id;
  Picture get picture => _picture;

  Token(int id) {
    this._id = id;
  }
}
