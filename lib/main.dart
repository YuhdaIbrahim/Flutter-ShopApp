import 'package:flutter/material.dart';
import 'screens/product-overview-screen.dart';
import 'screens/product-detail-screen.dart';
import 'providers/products-provider.dart';
import 'package:provider/provider.dart';
import 'providers/cart.dart';
import 'screens/cart-screen.dart';
import 'providers/orders.dart';
import 'screens/order-screen.dart';
import 'screens/user-product-screen.dart';
import 'screens/edit-product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserScreen.routeName: (ctx) => UserScreen(),
          EditScreen.routeName: (ctx) => EditScreen(),
        },
      ),
    );
  }
}
