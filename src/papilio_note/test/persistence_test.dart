import 'package:flutter_test/flutter_test.dart';
import 'package:md/models/data_model.dart';
import 'package:md/utils/misc.dart';

void main() {
  test('Test persistence', () async {
    final expectedPersistedModel = PersistedModel(
        notes: [Note(id: 'asd', title: 'asds', excerpt: 'adads')]);
    final jsonMap = expectedPersistedModel.toJson();
    final actualPersistedModel = PersistedModel.fromJson(jsonMap);
    expect(actualPersistedModel.settings.isDarkMode,
        expectedPersistedModel.settings.isDarkMode);
    expect(
        actualPersistedModel.notes[0].id, expectedPersistedModel.notes[0].id);
    expect(
        actualPersistedModel.notes.length, expectedPersistedModel.notes.length);
  });

  test('Test Randomness', () => expect(newId(), isNot(equals(newId()))));
}
