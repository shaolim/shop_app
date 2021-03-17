import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../providers/auth_provider.dart';
import '../screens/order_screen.dart';
import '../routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hellow'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.payment),
            title: Text('Order'),
            onTap: () {
              // Navigator.of(context).pushReplacementNamed(Routes.order);
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => OrderScreen()));
            }),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(Routes.userProducts),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');

            Provider.of<AuthProvider>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
