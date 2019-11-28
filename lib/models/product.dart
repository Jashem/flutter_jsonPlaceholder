import 'package:flutter/foundation.dart';

class Product {
  final int _userId;
  final int _id;
  final String _title;
  final String _body;

  Product(
      {@required int id,
      @required int userId,
      @required String title,
      @required String body})
      : _id = id,
        _userId = userId,
        _title = title,
        _body = body;

  int get id => _id;
  int get userId => _userId;
  String get title => _title;
  String get body => _body;
}
