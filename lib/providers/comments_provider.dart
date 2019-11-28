import 'dart:convert';

import 'package:demo_ecommerce/config/config.dart';
import 'package:demo_ecommerce/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentsProvider with ChangeNotifier {
  List<Comment> _comments;
  int _start = 0;
  int _limit = 20;
  var _hasMore = true;
  var _isfetching = false;

  List<Comment> get comments => _comments;

  Future<void> getCommentsByProductId(int productId) async {
    final url = "${Config.baseUrl}/posts/$productId/comments";

    try {
      if (!_hasMore) return;

      if (_isfetching) return;

      _isfetching = true;
      final response = await http.get(url);
      final responseJson = json.decode(response.body) as List<dynamic>;

      if (responseJson.isEmpty) {
        _hasMore = false;
        return;
      }

      final comments = responseJson.map(
        (comment) => Comment(
          id: comment["id"],
          postId: comment["postId"],
          body: comment["body"],
          email: comment["email"],
          name: comment["name"],
        ),
      );

      (_start == 0)
          ? _comments = comments.toList()
          : _comments.addAll(comments);
      _start += _limit;
      _isfetching = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
