import 'package:flutter/foundation.dart';

class User {
  final int _id;
  final String _userName;

  User({@required int id, @required String userName})
      : _id = id,
        _userName = userName;

  int get id => _id;
  String get userName => _userName;
}
