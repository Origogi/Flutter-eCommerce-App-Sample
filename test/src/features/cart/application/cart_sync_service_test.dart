import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;
  late MockProductRepository productRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
    productRepository = MockProductRepository();
  });

  CartSyncService makeCartSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      productRepositoryProvider.overrideWithValue(productRepository)
    ]);

    addTearDown(container.dispose);
    return container.read(cartSyncServiceProvider);
  }

  group('CartSyncService', () {
    Future<void> runCartSyncTest({
      required Map<ProductID, int> localCartItems,
      required Map<ProductID, int> remoteCartItems,
      required Map<ProductID, int> expectedRemoteCartItems,
    }) async {
      const uid = '123';
      when(authRepository.authStateChanges).thenAnswer(
          (_) => Stream.value(const AppUser(uid: uid, email: 'test@test.com')));

      when(productRepository.fetchProductsList)
          .thenAnswer((_) => Future.value(kTestProducts));
      when(localCartRepository.fetchCart)
          .thenAnswer((_) => Future.value(Cart(localCartItems)));
      when(() => remoteCartRepository.fetchCart(uid))
          .thenAnswer((_) => Future.value(Cart(remoteCartItems)));

      when(() =>
              remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems)))
          .thenAnswer((_) => Future.value());

      makeCartSyncService();
      
      await Future.delayed(const Duration());

      verify(() =>
              remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems)))
          .called(1);

      verify(() => localCartRepository.setCart(const Cart()));
    }

    test('local quantity <= available quantity', () async {
      await runCartSyncTest(
          localCartItems: {'1': 1},
          remoteCartItems: {},
          expectedRemoteCartItems: {'1': 1});
    });

    test('local quantity > available quantity', () async {
      await runCartSyncTest(
          localCartItems: {'1': 15},
          remoteCartItems: {},
          expectedRemoteCartItems: {'1': 5});
    });

    test('local + remote quantity > available quantity', () async {
      await runCartSyncTest(
          localCartItems: {'1': 4},
          remoteCartItems: {'1' : 4},
          expectedRemoteCartItems: {'1': 5});
    });

    test('multiple items', () async {
      await runCartSyncTest(
          localCartItems: {'1': 3, '2' : 1, '3' : 2},
          remoteCartItems: {'1' : 4},
          expectedRemoteCartItems: {'1': 5, '2' : 1, '3' : 2});
    });
  });
}
