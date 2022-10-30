import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Robot {
  final WidgetTester tester;

  Robot(this.tester);

  Future<void> pumpMyApp() async {
    final productRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    await tester.pumpWidget(ProviderScope(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      productRepositoryProvider.overrideWithValue(productRepository)
    ], child: const MyApp()));

    await tester.pumpAndSettle();
  }

  void expectFindAllProductCards() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }
}
