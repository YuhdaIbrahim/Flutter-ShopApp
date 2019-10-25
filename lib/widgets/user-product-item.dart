import 'package:flutter/material.dart';
import 'package:shop_apps/screens/edit-product.dart';
import 'package:provider/provider.dart';
import 'package:shop_apps/providers/products-provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    this.title,
    this.imageUrl,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final scafold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scafold.showSnackBar(SnackBar(
                    content: Text('Deleting Failed'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
