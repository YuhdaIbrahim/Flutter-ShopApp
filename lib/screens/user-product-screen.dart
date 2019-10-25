import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_apps/providers/products-provider.dart';
import 'package:shop_apps/screens/edit-product.dart';
import 'package:shop_apps/widgets/app-drawer.dart';
import 'package:shop_apps/widgets/user-product-item.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/User-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your product!'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserProductItem(
                  id: productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                ),
                Divider()
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
