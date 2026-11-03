import 'package:flutter_test/flutter_test.dart';

import 'package:jojo/main.dart';

void main() {
  testWidgets('Kids education splash smoke test', (tester) async {
    await tester.pumpWidget(const JoJoLearnApp());

    expect(find.text('Kids'), findsOneWidget);
    expect(find.text('Mart'), findsOneWidget);
    expect(find.textContaining('Learn'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();
    expect(find.text('Skip'), findsOneWidget);
  });
}
