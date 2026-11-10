import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_gardening_dairy/main.dart';

void main() {
  testWidgets('garden dashboard and navigation are available', (tester) async {
    await tester.pumpWidget(const GardenDiaryApp());

    expect(find.text('Good morning,\ngarden friend 🌱'), findsOneWidget);
    expect(find.text('Today in your garden'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Garden reminders'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plants').last);
    await tester.pumpAndSettle();
    expect(find.text('Your little jungle'), findsOneWidget);
    expect(find.text('Sweet basil'), findsOneWidget);
    await tester.tap(find.text('Sweet basil').last);
    await tester.pumpAndSettle();
    expect(find.text('About this plant'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Diary'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('First tiny tomato!'));
    await tester.pumpAndSettle();
    expect(find.text('Edit diary entry'), findsOneWidget);
  });
}
