import 'package:demo_ecommerce/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckedoutScreen extends StatelessWidget {
  static const routeName = "/checkedout";

  @override
  Widget build(BuildContext context) {
    final checkedoutItems = Provider.of<CartProvider>(context).checkedoutItems;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkedout"),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
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
            checkedoutItems.length == 0
                ? Center(
                    child: Text("No Item checked"),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: checkedoutItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              checkedoutItems[index].product.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: <Widget>[
                                  Text("Quantity:"),
                                  Text(
                                    " ${checkedoutItems[index].quantity}",
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
          ],
        ),
      ),
    );
  }
}
