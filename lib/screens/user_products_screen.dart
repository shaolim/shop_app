import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../routes.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.editProduct);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, dataSnapshot) =>
            dataSnapshot.connectionState == ConnectionState.waiting
                ? Center(child: const CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, products, child) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final product = products.items[index];
                            return Column(
                              children: [
                                UserProductItem(
                                  id: product.id,
                                  title: product.title,
                                  imageUrl: product.imageUrl,
                                ),
                                const Divider()
                              ],
                            );
                          },
                          itemCount: products.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
