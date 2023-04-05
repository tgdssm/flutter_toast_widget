import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_widget/src/toast_widget.dart';

void main() {
  Future click(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key("test_key")));
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  testWidgets('flutter toast widget test', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Container(
                  height: 500,
                  width: 500,
                  alignment: Alignment.center,
                  child: MaterialButton(
                    key: const Key("test_key"),
                    onPressed: () {
                      ToastWidget.show(context: context, message: "Test");
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    await click(widgetTester);
    expect(find.byType(Text), findsOneWidget);
    await widgetTester.pump(const Duration(seconds: 2));
    await widgetTester.pump();
    expect(find.byType(Text), findsNWidgets(0));
  });
}
