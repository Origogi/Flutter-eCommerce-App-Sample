import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('AccountSceenController', () {
    test('initial state is AsyncValue', () {
      final authRepository = FakeAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);
          expect(controller.debugState, const AsyncData<void>(null));
    });
  });
}
