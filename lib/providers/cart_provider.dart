import 'package:demo_ecommerce/models/cart_item.dart';
import 'package:demo_ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cart = [];
  List<CartItem> _checkedoutItems = [];

  List<CartItem> get checkedoutItems => _checkedoutItems;

  List<CartItem> get cart => _cart;

  void addToCart(Product product) {
    _cart.add(
      CartItem(product: product, quantity: 1),
    );
    notifyListeners();
  }

  void addQuantity(int index) {
    _cart[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cart[index].quantity == 1) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity--;
    }
    notifyListeners();
  }

  void checkout() {
    _checkedoutItems.addAll(_cart);
    _cart = [];
    notifyListeners();
  }
}
