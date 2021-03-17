import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import '../models/cart.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  Widget _builderEmptyCart(BuildContext context) => Center(
          child: Text(
        'You don\'t have item in cart',
        style: Theme.of(context).textTheme.headline5,
      ));

  Widget _builderCartList(Map<String, Cart> cart) {
    List<Cart> values = cart.values.toList();
    List<String> keys = cart.keys.toList();

    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, index) => CartItem(keys[index], values[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;

    return Scaffold(
        appBar: AppBar(title: Text('Your Cart')),
        body: items.isEmpty
            ? _builderEmptyCart(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Total', style: TextStyle(fontSize: 20)),
                          Spacer(),
                          Chip(
                            label: Text(
                                cartProvider.totalAmount.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6
                                        .color)),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 8),
                          OrderButton(cartProvider: cartProvider, items: items)
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  SizedBox(height: 16),
                  Expanded(child: _builderCartList(items))
                ],
              ));
  }
}

class OrderButton extends StatefulWidget {
  OrderButton({
    Key key,
    @required this.cartProvider,
    @required this.items,
  }) : super(key: key);

  final CartProvider cartProvider;
  final Map<String, Cart> items;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false).addOrder(
                  widget.items.values.toList(),
                  widget.cartProvider.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cartProvider.clear();
              Navigator.of(context).pushNamed(Routes.order);
            },
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
