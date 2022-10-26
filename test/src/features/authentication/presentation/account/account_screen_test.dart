import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AccountScreen())));

    final finder = find.text('Logout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();

    final dialogTitle = find.text("Are you sure?");
    expect(dialogTitle, findsOneWidget);

    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
    expect(dialogTitle, findsNothing);
  });
}
