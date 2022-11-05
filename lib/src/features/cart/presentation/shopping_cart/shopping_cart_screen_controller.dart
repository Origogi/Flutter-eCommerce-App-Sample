import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShoppingCartScreenController extends StateNotifier<AsyncValue<void>> {
  final CartService cartService;

  ShoppingCartScreenController(this.cartService) : super(const AsyncData(null));

  Future<void> updateItemQuantity(ProductID productId, int quantity) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));
    final updated = Item(productId: productId, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(updated));
  }

  Future<void> removeItemById(ProductID productId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => cartService.removeItemById(productId));
  }
}

final shoppingCartScreenControllerProvider =
    StateNotifierProvider<ShoppingCartScreenController, AsyncValue<void>>(
        (ref) {
  return ShoppingCartScreenController(ref.watch(cartServiceProvider));
});
