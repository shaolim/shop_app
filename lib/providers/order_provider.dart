import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  final String token;
  final String userId;

  List<Order> get orders => [..._orders];

  OrderProvider(this.token, this.userId, [this._orders = const []]);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-app-7d28d.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }

    final List<Order> loadedOrders = [];
    extractedData.forEach((key, value) {
      loadedOrders.add(Order(
          id: key,
          amount: value['amount'],
          datetime: DateTime.parse(value['dateTime']),
          products: (value['products'] as List)
              .map((cart) => Cart(
                  id: cart['id'],
                  title: cart['title'],
                  quantity: cart['quantity'],
                  price: cart['price']))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cart, double total) async {
    final url =
        'https://flutter-shop-app-7d28d.firebaseio.com/orders/$userId.json?auth=$token';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cart
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price
                  })
              .toList()
        }));

    _orders.add(Order(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cart,
        datetime: DateTime.now()));

    notifyListeners();
  }
}
