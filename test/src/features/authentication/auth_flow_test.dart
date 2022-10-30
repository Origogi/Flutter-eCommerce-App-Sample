import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets("Sign in and Sign out flow", (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindAllProductCards();
  });
}