@Timeout(Duration(milliseconds: 300))
import 'package:ecommerce_app/src/features/authentication/presentation/account_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock.dart';


void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  group('AccountScreenController', () {
    test('initial state is AsyncValue', () {

      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });
  });

  test('signOut success', () async {
    // setup
    when(authRepository.signOut).thenAnswer((_) => Future.value());

    // expect later
    expectLater(controller.stream,
        emitsInOrder(const [AsyncLoading<void>(), AsyncData<void>(null)]));
    // run
    await controller.signOut();
    // verify
    verify(authRepository.signOut).called(1);
    expect(controller.debugState, const AsyncData<void>(null));
  });

  test('signOut failure', () async {
    // setup
    final exception = Exception('network failed');
    when(authRepository.signOut).thenThrow(exception);

    // expect later
    expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          })
        ]));
    // run
    await controller.signOut();
    // verify
    verify(authRepository.signOut).called(1);
    expect(controller.debugState.hasError, true);
    expect(controller.debugState, isA<AsyncError>());
  });
}
