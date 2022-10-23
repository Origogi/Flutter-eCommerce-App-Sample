import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeProductRepository', () {
    test('getProductList returns global list', () {
      final productRepository = FakeProductsRepository.instance;

      expect(productRepository.getProductsList(), kTestProducts);
    });

    test('getProduct(1) return first item', () {
      final productRepository = FakeProductsRepository.instance;
      expect(productRepository.getProduct('1'), kTestProducts[0]);
    });

    test('getProduct(100) return null', () {
      final productRepository = FakeProductsRepository.instance;
      expect(productRepository.getProduct('100'), null);
    });

    test('fetchProductList returns global list', () async {
      final productRepository = FakeProductsRepository.instance;
      expect(await productRepository.fetchProductsList(), kTestProducts);
    });

    test('watchProductList emits global list', () async {
      final productRepository = FakeProductsRepository.instance;
      expect(productRepository.watchProductList(), emits(kTestProducts));
    });

    test('watchProduct(1) emit first item', () {
      final productRepository = FakeProductsRepository.instance;
      expect(productRepository.watchProduct('1'), emits(kTestProducts[0]));
    });

    test('watchProduct(100) emit null', () {
      final productRepository = FakeProductsRepository.instance;
      expect(productRepository.watchProduct('100'), emits(null));
    });
  });
}
