import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts(false)
          .then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Only favorites'),
                        value: FilterOptions.Favorites),
                    PopupMenuItem(
                        child: Text('Show All'), value: FilterOptions.All),
                  ],
              icon: Icon(Icons.more_vert)),
          Consumer<CartProvider>(
            builder: (_, cart, child) => GestureDetector(
              child: Badge(
                child: child,
                value: cart.itemCount.toString(),
              ),
              onTap: () => Navigator.of(context).pushNamed(Routes.cart),
            ),
            child: Icon(Icons.shopping_cart),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorite),
    );
  }
}
