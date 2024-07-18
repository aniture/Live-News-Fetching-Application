
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cs442_mp6/main.dart';

void main() {
  testWidgets('App should start and display news', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);

    expect(find.text('News'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Channel'), findsOneWidget);
  });

  testWidgets('Tap on an item in the drawer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    await tester.tap(find.text('Country')); // Change this based on your drawer items
    await tester.pumpAndSettle();

    expect(find.text('Selected Country'), findsOneWidget);
  });

  testWidgets('Search for news', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Flutter News');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search Results'), findsOneWidget);
  });
}
