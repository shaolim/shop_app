import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [];
  final String token;
  final String userId;

  ProductsProvider(this.token, this.userId, [this._items = const []]);

  List<ProductProvider> get items {
    return [..._items];
  }

  List<ProductProvider> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  ProductProvider findById(String id) =>
      _items.firstWhere((element) => element.id == id);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    if (token == null) {
      return;
    }

    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-shop-app-7d28d.firebaseio.com/products.json?auth=$token&$filterString';
    final response = await http.get(url);
    final products = json.decode(response.body) as Map<String, dynamic>;
    if (products == null) {
      return;
    }

    final favoriteProductUrl =
        'https://flutter-shop-app-7d28d.firebaseio.com/userFavorites/$userId.json?auth=$token';
    final favoriteProductResponse = await http.get(favoriteProductUrl);
    final favoriteProducts =
        json.decode(favoriteProductResponse.body) as Map<String, dynamic>;

    final List<ProductProvider> loadedProduct = [];
    products.forEach((prodId, prodData) {
      loadedProduct.add(ProductProvider(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: favoriteProducts[prodId] ?? false));
    });
    _items = loadedProduct;
    notifyListeners();
  }

  Future<void> addProduct(ProductProvider product) async {
    if (token == null) {
      return;
    }

    final url =
        'https://flutter-shop-app-7d28d.firebaseio.com/products.json?auth=$token';

    var response = await http.post(url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        }));

    final newProduct = ProductProvider(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name']);

    _items.add(newProduct);

    notifyListeners();
  }

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    if (token == null) {
      return;
    }

    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      var url =
          'https://flutter-shop-app-7d28d.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl
          }));

      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    if (token == null) {
      return;
    }

    var url =
        'https://flutter-shop-app-7d28d.firebaseio.com/products/$id.json?auth=$token';
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
