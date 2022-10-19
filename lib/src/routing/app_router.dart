import 'package:ecommerce_app/src/features/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final goRouter =
    GoRouter(debugLogDiagnostics: true, initialLocation: '/', routes: [
  GoRoute(
      path: '/',
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
            path: 'cart',
            builder: (context, state) => const ShoppingCartScreen(),
            pageBuilder: (context, state) =>  MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const ShoppingCartScreen()
            )),
      ]),
]);
