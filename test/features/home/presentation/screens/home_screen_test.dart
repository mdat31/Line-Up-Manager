import 'package:flutter_test/flutter_test.dart';

import 'package:marozi/app.dart';

void main() {
  testWidgets('app starts on the home screen', (tester) async {
    await tester.pumpWidget(const MaroziApp());

    expect(find.text('Marozi'), findsOneWidget);
  });
}
