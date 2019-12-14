import 'package:flutter_test/flutter_test.dart';
import 'package:note_keeper/views/note_detail.dart';

void main() {
  //setup
  //run
  //verify
  test('Empty title returns error', () {
    var result = NoteValidator.validateTitle('');
    expect(result, 'Required');
  });

  test('Non-empty title returns null', () {
    var result = NoteValidator.validateTitle('title');
    expect(result, null);
  });
}
