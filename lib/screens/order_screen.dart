import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Order')),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured'));
            } else {
              return Consumer<OrderProvider>(
                builder: (context, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, index) {
                      return OrderItem(orderData.orders[index]);
                    },
                    itemCount: orderData.orders.length),
              );
            }
          }
        },
      ),
    );
  }
}
