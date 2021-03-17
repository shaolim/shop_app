import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.4),
                padding: EdgeInsets.only(right: 16, top: 4, bottom: 4),
                child: Text(
                  product.title,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              background: Hero(
                tag: product.id,
                child: Image(
                  image: CachedNetworkImageProvider(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: Text(
                        product.description,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 800),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
