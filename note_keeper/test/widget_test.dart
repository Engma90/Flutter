import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_keeper/views/note_detail.dart';

Widget makeTestable(Widget widget) {
  return MaterialApp(
    home: widget,
  );
}

void main() {
  testWidgets('Empty title leads to not adding the note',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(NoteDetail(null)));
    expect(find.text('Save'), findsOneWidget);
    await tester.press(find.text('Save'));
    expect(find.text('Save'), findsOneWidget);
  });
}
