import 'dart:convert';

import 'package:demo_ecommerce/config/config.dart';
import 'package:demo_ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _products;
  int _start = 0;
  int _limit = 20;
  var _hasMore = true;
  var _isfetching = false;

  List<Product> get products => _products;

  Future<void> getProducts() async {
    final url = "${Config.baseUrl}/posts?_start=$_start&_limit=$_limit";
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

      final products = responseJson.map(
        (product) => Product(
          id: product["id"],
          userId: product["userId"],
          body: product["body"],
          title: product["title"],
        ),
      );

      (_start == 0)
          ? _products = products.toList()
          : _products.addAll(products);
      _start += _limit;
      _isfetching = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product getProductByIndex(int index) => _products[index];
}
