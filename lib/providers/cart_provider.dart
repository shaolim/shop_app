import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values
        .map((e) => e.price * e.quantity)
        .fold(0, (value, element) => value + element);
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => Cart(
              id: existingValue.id,
              title: existingValue.title,
              quantity: existingValue.quantity + 1,
              price: existingValue.price));
    } else {
      _items.putIfAbsent(productId,
          () => Cart(id: Uuid().v4(), title: title, quantity: 1, price: price));
    }
    notifyListeners();
  }

  void deleteAllItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void deleteItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      _items.removeWhere((key, value) => key == productId);
    } else {
      _items.update(
          productId,
          (existingValue) => Cart(
              id: existingValue.id,
              title: existingValue.title,
              quantity: existingValue.quantity - 1,
              price: existingValue.price));
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
