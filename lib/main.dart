import 'package:demo_ecommerce/providers/auth_provider.dart';
import 'package:demo_ecommerce/providers/cart_provider.dart';
import 'package:demo_ecommerce/providers/comments_provider.dart';
import 'package:demo_ecommerce/providers/products_provider.dart';
import 'package:demo_ecommerce/screens/cart_screen.dart';
import 'package:demo_ecommerce/screens/checkedout_screen.dart';
import 'package:demo_ecommerce/screens/home_screen.dart';
import 'package:demo_ecommerce/screens/login_screen.dart';
import 'package:demo_ecommerce/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CommentsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth ? HomeScreen() : LoginScreen(),
          routes: {
            ProductScreen.routeName: (context) => ProductScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            CheckedoutScreen.routeName: (context) => CheckedoutScreen(),
          },
        ),
      ),
    );
  }
}
