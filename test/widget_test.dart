import 'package:flutter_test/flutter_test.dart';
import 'package:home_gardening_dairy/main.dart';

void main() {
  testWidgets('garden dashboard and navigation are available', (tester) async {
    await tester.pumpWidget(const GardenDiaryApp());

    expect(find.text('Good morning,\ngarden friend 🌱'), findsOneWidget);
    expect(find.text('Today in your garden'), findsOneWidget);

    await tester.tap(find.text('Plants').last);
    await tester.pumpAndSettle();
    expect(find.text('Your little jungle'), findsOneWidget);
    expect(find.text('Sweet basil'), findsOneWidget);
  });
}
