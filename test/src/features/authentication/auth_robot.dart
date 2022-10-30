import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../mock.dart';

class AuthRobot {
  AuthRobot(this.tester);

  final WidgetTester tester;

  Future<void> pumpEmailPasswordSignInContents(
      {required FakeAuthRepository authRepository,
      required EmailPasswordSignInFormType formType,
      VoidCallback? onSignedIn}) {
    return tester.pumpWidget(ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
        child: MaterialApp(
            home: Scaffold(
          body: EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: onSignedIn,
          ),
        ))));
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pump();

  }

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      if (authRepository != null)
        authRepositoryProvider.overrideWithValue(authRepository)
    ], child: const MaterialApp(home: AccountScreen())));
  }

  Future<void> tapLogoutButton() async {
    final finder = find.text('Logout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text("Are you sure?");
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text("Are you sure?");

    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final finder = find.byKey(kDialogDefaultKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}