import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = _showOnlyFavorites ? productsProvider.favoriteItems : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
            value: products[index], child: ProductItem());
      },
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
