import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_mart/widgets/learning_banner.dart';

void main() {
  testWidgets('Hero carousel shows photos and responds to swipes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.4)),
          child: child!,
        ),
        home: const Scaffold(body: LearningBanner()),
      ),
    );

    expect(find.text('Big stories for\nlittle readers'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('Build, create\nand imagine'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
