import 'package:demo_ecommerce/models/product.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final Product _product;
  int quantity;

  CartItem({@required Product product, @required this.quantity})
      : _product = product;

  Product get product => _product;
}
