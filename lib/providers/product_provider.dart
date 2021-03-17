import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void _setFavValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  void toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !oldStatus;
    notifyListeners();

    var url =
        'https://flutter-shop-app-7d28d.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw HttpException('Could not delete product.');
    }
  }
}
