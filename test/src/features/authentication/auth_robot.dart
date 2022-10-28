import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthRobot {
  AuthRobot(this.tester);

  final WidgetTester tester;

  Future<void> pumpAccountScreen() async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AccountScreen())));
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
}
