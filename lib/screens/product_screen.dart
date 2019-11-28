import 'package:demo_ecommerce/models/product.dart';
import 'package:demo_ecommerce/providers/cart_provider.dart';
import 'package:demo_ecommerce/providers/comments_provider.dart';
import 'package:demo_ecommerce/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = "/product";
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var _scrollController = ScrollController();
  var _isLoading = false;
  var _isLoadingMore = false;
  var _isInit = true;
  int _args;
  Product _product;

  @override
  void initState() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) _getMoreData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _args = ModalRoute.of(context).settings.arguments as int;
        _product = Provider.of<ProductsProvider>(context, listen: false)
            .getProductByIndex(_args);
        _isLoading = true;
      });
      Provider.of<CommentsProvider>(context, listen: false)
          .getCommentsByProductId(_product.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print(error);
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getMoreData() async {
    try {
      setState(() {
        _isLoadingMore = true;
      });
      await Provider.of<CommentsProvider>(context, listen: false)
          .getCommentsByProductId(_product.id);
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: <Widget>[
            Text(
              _product.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              _product.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, _) => IconButton(
                    disabledColor: Colors.grey,
                    color: Theme.of(context).primaryColor,
                    onPressed: cartProvider.cart.length == 0
                        ? () {
                            cartProvider.addToCart(_product);
                          }
                        : cartProvider.cart.indexWhere((cartItem) =>
                                    cartItem.product == _product) ==
                                -1
                            ? () {
                                cartProvider.addToCart(_product);
                              }
                            : null,
                    icon: Icon(
                      Icons.add_shopping_cart,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<CommentsProvider>(
                    builder: (context, commentProvider, _) =>
                        commentProvider.comments.length == 0
                            ? Center(
                                child: Text("No data"),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: commentProvider.comments.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          commentProvider.comments[index].name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          commentProvider.comments[index].body,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                  ),
            if (_isLoadingMore)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
