import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddToCartController extends StateNotifier<AsyncValue<int>> {
  AddToCartController(this.cartService) : super(const AsyncData(1));

  final CartService cartService;

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(ProductID productId) async {
    final item = Item(productId: productId, quantity: state.value!);
    state = const AsyncLoading();
    final value = await AsyncValue.guard(() => cartService.addItem(item));

    if (value.hasError) {
      state = AsyncError(value.error!, value.stackTrace!);
    } else {
      state = const AsyncData(1);
    }
  }
}

final addToCartControllerProvider =
    StateNotifierProvider<AddToCartController, AsyncValue<int>>(
        (ref) => AddToCartController(ref.watch(cartServiceProvider)));
