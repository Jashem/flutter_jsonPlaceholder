import 'package:demo_ecommerce/providers/products_provider.dart';
import 'package:demo_ecommerce/screens/cart_screen.dart';
import 'package:demo_ecommerce/screens/checkedout_screen.dart';
import 'package:demo_ecommerce/screens/product_screen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _isLoadingMore = false;

  ScrollController _scrollController = ScrollController();

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
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .getProducts()
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
      await Provider.of<ProductsProvider>(context, listen: false).getProducts();
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _handleProductTap(int index) {
    Navigator.of(context).pushNamed(ProductScreen.routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<ProductsProvider>(context).products;
    final appBar = AppBar(
      title: Text("Home"),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CheckedoutScreen.routeName);
        },
        icon: Icon(
          Icons.details,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          children: <Widget>[
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : products.length == 0
                    ? Center(
                        child: Text("No data"),
                      )
                    : Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => _handleProductTap(index),
                              child: Card(
                                child: ListTile(
                                  title: Text(products[index].title),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            );
                          },
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
