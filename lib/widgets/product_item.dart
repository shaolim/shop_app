import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import '../models/http_exception.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.productDetail, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: CachedNetworkImageProvider(product.imageUrl),
                fit: BoxFit.fill,
              ),
            )),
        footer: GridTileBar(
          title: Text(product.title, textAlign: TextAlign.center),
          backgroundColor: Colors.black54,
          leading: Consumer<ProductProvider>(
              builder: (_, prod, child) => IconButton(
                  icon: Icon(
                      prod.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () async {
                    try {
                      prod.toggleFavorite(authData.token, authData.userId);
                    } on HttpException catch (error) {
                      scaffold.showSnackBar(SnackBar(
                          content: Text(error.message,
                              textAlign: TextAlign.center)));
                    }
                  },
                  color: Theme.of(context).accentColor)),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Yay! Snackbar'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => cart.deleteItem(product.id),
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
