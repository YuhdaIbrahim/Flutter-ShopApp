import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_apps/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop_apps/models/http-exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    const url = 'https://shop-apps-c1734.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loaderData = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loaderData.add(Product(
          id: prodId,
          price: prodData['price'],
          title: prodData['title'],
          imageUrl: prodData['imageUrl'],
          desc: prodData['desc'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loaderData;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-apps-c1734.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'desc': product.desc,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        desc: product.desc,
        imageUrl: product.imageUrl,
        title: product.title,
        price: product.price,
      );
      _items.add(newProduct);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product products) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = 'https://shop-apps-c1734.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': products.title,
            'desc': products.desc,
            'price': products.price,
            'isFavorite': products.isFavorite,
            'imageUrl': products.imageUrl,
          }));
      _items[productIndex] = products;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-apps-c1734.firebaseio.com/products/$id.json';
    final existingProductionIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductionIndex];
    _items.removeAt(existingProductionIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductionIndex, existingProduct);
      notifyListeners();
      throw HttpException('Failed. Check the URL connection!');
    }
    existingProduct = null;
  }
}
