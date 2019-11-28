import 'package:flutter/foundation.dart';

class Comment {
  final int _id;
  final int _postId;
  final String _name;
  final String _email;
  final String _body;

  Comment(
      {@required int id,
      @required int postId,
      @required String name,
      @required String email,
      @required String body})
      : _id = id,
        _postId = postId,
        _name = name,
        _email = email,
        _body = body;

  int get id => _id;
  int get postId => _postId;
  String get name => _name;
  String get email => _email;
  String get body => _body;
}
