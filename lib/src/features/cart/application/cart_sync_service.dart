import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartSyncService {
  final Ref ref;

  CartSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider, (prev, next) {
      final previousUser = prev?.value;
      final user = next.value;

      if (previousUser == null && user != null) {
        debugPrint('signed in ; ${user.uid}');
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();

      if (localCart.items.isNotEmpty) {
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemToAdd = await _getLocalItemsToAdd(localCart, remoteCart);
        final updatedRemoteCart = remoteCart.addItems(localItemToAdd);
        await remoteCartRepository.setCart(uid, updatedRemoteCart);
        await localCartRepository.setCart(const Cart());
      }
    } catch (e) {
      // TODO : Handle error and/or rethrow
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(
      Cart localCart, Cart remoteCart) async {
    final productRepository = ref.read(productRepositoryProvider);
    final products = await productRepository.fetchProductsList();
    final localItemsToAdd = <Item>[];

    for (final localItem in localCart.items.entries) {
      final productId = localItem.key;
      final localQuantity = localItem.value;

      final remoteQuantity = remoteCart.items[productId] ?? 0;
      final product = products.firstWhere((product) => product.id == productId);
      final cappedLocalQuantity =
          min(localQuantity + remoteQuantity, product.availableQuantity);

      if (cappedLocalQuantity > 0) {
        localItemsToAdd
            .add(Item(productId: productId, quantity: cappedLocalQuantity));
      }
    }

    return localItemsToAdd;
  }
}

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
