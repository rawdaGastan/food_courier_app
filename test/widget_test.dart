import 'package:flutter_test/flutter_test.dart';

import 'package:foodCourier/main.dart';

void main() {
  testWidgets('Food courier build test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FoodCourier());
  });
}
