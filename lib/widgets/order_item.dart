import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderItem extends StatefulWidget {
  final Order _order;

  OrderItem(this._order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: ListTile(
          title: Text('${widget._order.amount}'),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget._order.datetime)),
        ),
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var prod = widget._order.products[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          prod.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        '${prod.quantity}x \$${prod.price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Divider()
                    ],
                  );
                },
                itemCount: widget._order.products.length),
          ),
        ],
      ),
    );
  }
}
