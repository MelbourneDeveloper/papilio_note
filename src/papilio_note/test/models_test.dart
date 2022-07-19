import 'package:flutter_test/flutter_test.dart';
import 'package:papilio_note/models/view_models.dart';

void main() {
  test('Test copyWith', () {
    final notesAppViewModel = AppViewModel.emptyNotesViewModel.copyWith();
    expect(notesAppViewModel.pageViewModel,
        equals(AppViewModel.emptyNotesViewModel.pageViewModel),);
  });
}
