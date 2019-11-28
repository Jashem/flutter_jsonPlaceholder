import 'dart:convert';

import 'package:demo_ecommerce/config/config.dart';
import 'package:demo_ecommerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  User _user;

  User get user => _user;

  bool get isAuth {
    return user != null;
  }

  Future<void> login(int id) async {
    final url = "${Config.baseUrl}/users/$id";

    try {
      final response = await http.get(url);
      final responseJson = json.decode(response.body) as Map<String, dynamic>;
      if (responseJson.isEmpty) {
        throw {"message": "User id does not exist!"};
      }
      _user = User(id: responseJson["id"], userName: responseJson["username"]);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
