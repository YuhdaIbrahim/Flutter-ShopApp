import 'package:flutter/cupertino.dart';
import 'package:shop_apps/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.dateTime,
    @required this.id,
    @required this.products,
    @required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-apps-c1734.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedDataOrder =
        json.decode(response.body) as Map<String, dynamic>;
    if (extractedDataOrder == null) {
      return;
    }
    extractedDataOrder.forEach((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = 'https://shop-apps-c1734.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
          dateTime: DateTime.now(),
          id: json.decode(response.body)['name'],
          products: cartProduct,
          amount: total,
        ));
    notifyListeners();
  }
}
