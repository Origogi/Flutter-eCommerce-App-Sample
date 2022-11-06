import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockLocalCartRepository localCartRepository;
  late MockRemoteCartRepository remoteCartRepository;

  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
  });

  CartService makeCartService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository)
    ]);
    addTearDown(container.dispose);
    return container.read(cartServiceProvider);
  }

  group('setItem', () {
    test('null user, writes item to local cart', () async {
      // setup
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart)
          .thenAnswer((_) => Future.value(const Cart()));
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
            (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.setItem(const Item(productId: '123', quantity: 1));
      // verify
      verify(
            () => localCartRepository.setCart(expectedCart),
      ).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, writes item to remote cart', () async {
      // setup
      const testUser = AppUser(uid: 'abc');
      const expectedCart = Cart({'123': 1});
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid))
          .thenAnswer((_) => Future.value(const Cart()));
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer(
            (_) => Future.value(),
      );
      final cartService = makeCartService();
      // run
      await cartService.setItem(const Item(productId: '123', quantity: 1));
      // verify
      verify(
            () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });

  group('cartTotalProvider', () {
    ProviderContainer makeProviderContainer({
      required Stream<Cart> cart,
      required Stream<List<Product>> products,
    }) {
      final container = ProviderContainer(overrides: [
        cartProvider.overrideWithProvider(StreamProvider((ref) => cart)),
        productListStreamProvider
            .overrideWithProvider(StreamProvider.autoDispose((ref) => products))
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('loading cart', () async {
      final container = makeProviderContainer(
          cart: Stream.value(const Cart()),
          products: Stream.value(kTestProducts));

      final total = container.read(cartTotalProvider);
      expect(total, 0);
    });

    test('empty cart', () async {
      final container = makeProviderContainer(
          cart: Stream.value(const Cart()),
          products: Stream.value(kTestProducts));

      final total = container.read(cartTotalProvider);
      expectLater(total, 0);
    });

    test('one product with quantity 5', () async {
      const productId = '1';
      const quantity = 1;
      final container = makeProviderContainer(
          cart: Stream.value(const Cart({productId: quantity})),
          products: Stream.value(kTestProducts));

      await container.read(cartProvider.future);
      await container.read(productListStreamProvider.future);

      final total = container.read(cartTotalProvider);

      final product =
      kTestProducts.firstWhere((element) => element.id == productId);

      final expectResult = product.price * quantity;

      expect(total, expectResult);
    });
  });

}
