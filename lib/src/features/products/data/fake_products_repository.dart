import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeProductsRepository {
  FakeProductsRepository._();

  static FakeProductsRepository instance = FakeProductsRepository._();

  final _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProduct(_products, id);
  }
  
  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> fetchProductsList() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception('connection failed');
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductList() async* {
    await Future.delayed(const Duration(seconds: 2));

    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductList()
        .map((products) => _getProduct(products, id));
  }
}

final productRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository.instance;
});

final productListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProductList();
});

final productListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductsList();
});

final productProvider =
    StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final link = ref.keepAlive();

  Timer(const Duration(seconds: 10), () {
    link.close();
  });

  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.watchProduct(id);
});
