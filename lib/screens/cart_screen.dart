import 'package:demo_ecommerce/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  void _showShnakBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message),
      duration: Duration(seconds: 1),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Items",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              cartProvider.cart.length == 0
                  ? Center(
                      child: Text("No Item added"),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.cart.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                cartProvider.cart[index].product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: <Widget>[
                                    Text("Quantity:"),
                                    Spacer(),
                                    InkWell(
                                      onTap: () =>
                                          cartProvider.decrementQuantity(index),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        "${cartProvider.cart[index].quantity}",
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          cartProvider.addQuantity(index),
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              if (cartProvider.cart.length != 0)
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        cartProvider.checkout();
                        _showShnakBar("Successfuly checkedout!", context);
                      },
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
