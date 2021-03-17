import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final Cart cart;
  final String productId;

  CartItem(this.productId, this.cart);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Dismissible(
      key: ValueKey(cart.id),
      background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          )),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the item form the cart?'),
                actions: [
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            });
      },
      onDismissed: (direction) {
        cartProvider.deleteAllItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text('\$${cart.price}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor))
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.remove_circle, size: 20),
                  onPressed: () => cartProvider.deleteItem(productId)),
              Text('${cart.quantity}'),
              IconButton(
                  icon: Icon(Icons.add_circle, size: 20),
                  onPressed: () =>
                      cartProvider.addItem(productId, cart.price, cart.title))
            ],
          )
        ]),
      ),
    );
  }
}
