import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_apps/widgets/product-item.dart';
import 'package:shop_apps/providers/products-provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  ProductGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
//          id: products[i].id,
//          title: products[i].title,
//          url: products[i].imageUrl,
            ),
      ),
      itemCount: products.length,
    );
  }
}
