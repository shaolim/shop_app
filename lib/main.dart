import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './routes.dart';
import './screens/screens.dart';
import './providers/providers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ListenableProxyProvider<AuthProvider, ProductsProvider>(
            create: (_) => ProductsProvider(null, null),
            update: (_, auth, previous) => ProductsProvider(auth.token,
                auth.userId, previous == null ? [] : previous.items)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ListenableProxyProvider<AuthProvider, OrderProvider>(
            create: (_) => OrderProvider(null, null),
            update: (_, auth, previous) => OrderProvider(auth.token,
                auth.userId, previous == null ? [] : previous.orders)),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            Routes.auth: (_) => AuthScreen(),
            Routes.cart: (_) => CartScreen(),
            Routes.editProduct: (_) => EditProductScreen(),
            Routes.productOverview: (_) => ProductsOverviewScreen(),
            Routes.order: (_) => OrderScreen(),
            Routes.productDetail: (_) => ProductDetailScreen(),
            Routes.userProducts: (_) => UserProductsScreen(),
          },
        ),
      ),
    );
  }
}
