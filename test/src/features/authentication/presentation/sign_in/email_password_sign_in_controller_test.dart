import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock.dart';


void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';

  group('submit', () {
    test('''
     Given fromType is signIn
     when signInWithEmailAndPassword succeeds
     Then return true
    ''', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);

      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>()),
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncData<void>(null))
          ]));

      // run
      final result = await controller.submit(testEmail, testPassword);

      // verify
      expect(result, true);
    }, timeout: const Timeout(Duration(milliseconds: 300)));

    test('''
     Given fromType is signIn
     when signInWithEmailAndPassword fail
     Then return false
     And state is AsyncError
    ''', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenThrow(exception);
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);

      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>()),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.signIn);
              expect(state.value.hasError, true);
              return true;
            })
          ]));

      // run
      final result = await controller.submit(testEmail, testPassword);

      // verify
      expect(result, false);
    }, timeout: const Timeout(Duration(milliseconds: 300)));

    test('''
     Given fromType is register
     when createUserWithEmailAndPassword succeeds
     Then return true
    ''', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(() => authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);

      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>()),
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncData<void>(null))
          ]));

      // run
      final result = await controller.submit(testEmail, testPassword);

      // verify
      expect(result, true);
    }, timeout: const Timeout(Duration(milliseconds: 300)));

    test('''
     Given fromType is register
     when createUserWithEmailAndPassword fail
     Then return false
     And state is AsyncError
    ''', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(() => authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenThrow(exception);
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);

      // expect later
      expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>()),
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value.hasError, true);
              return true;
            })
          ]));

      // run
      final result = await controller.submit(testEmail, testPassword);

      // verify
      expect(result, false);
    }, timeout: const Timeout(Duration(milliseconds: 300)));
  });

  group('updateFormType', () {
    test('''
    Given formType is signIn
    when called with register
    Then state.formType is register''', () {
      // setup
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.signIn,
          authRepository: authRepository);
      // run
      controller.updateFormType(EmailPasswordSignInFormType.register);

      expect(
          controller.debugState,
          EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null)));
    });

    test('''
    Given formType is register
    when called with signIn
    Then state.formType is signIn''', () {
      // setup
      final authRepository = MockAuthRepository();
      final controller = EmailPasswordSignInController(
          formType: EmailPasswordSignInFormType.register,
          authRepository: authRepository);
      // run
      controller.updateFormType(EmailPasswordSignInFormType.signIn);

      expect(
          controller.debugState,
          EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null)));
    });
  });
}
