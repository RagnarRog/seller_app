import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('seller app shell renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('E Commerce App Seller'))),
      ),
    );

    expect(find.text('E Commerce App Seller'), findsOneWidget);
  });
}
