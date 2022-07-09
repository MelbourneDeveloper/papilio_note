import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';
import 'package:papilio/papilio_router_delegate.dart';
import 'package:papilio_note/main.dart';
import 'package:papilio_note/models/data_model.dart';
import 'package:papilio_note/models/note_route_path.dart';
import 'package:papilio_note/pages/notes.dart';
import 'package:papilio_note/services/file_io/file_io_base.dart';
import 'package:papilio_note/utils/constants.dart';
import 'package:papilio_note/utils/misc.dart';
import 'package:papilio_note/widgets/app_root.dart';

import 'app_test.mocks.dart';
import 'helpers.dart';

//flutter pub run build_runner build
@GenerateMocks([
  FileIOBase
], customMocks: [
  MockSpec<PapilioRouterDelegate<AppRouteInfo>>(
      unsupportedMembers: {#currentConfiguration})
])
void main() {
  runTestCases('Notes Screen', testNotesPage);
  runTestCases('Empty Notes Screen', testEmptyDataFile);
}

Future<void> testNotesPage(WidgetTester tester, TestCaseArgs caseArgs) async {
  final builder = compose(allowOverrides: true);
  final mockFileIO = MockFileIOBase();

  final isHamburger =
      caseArgs.displayInfo!.physicalSizeTestValue.width <= minimumMenuWidth;

  //Mock loadind the model from disk
  const noteId = '123';
  const modifiedTitle = 'AB';
  const mdFilename = '$noteId.md';
  const newId = "567";

  final originalExcerpt = markdownExample.substring(0, excerptLength);
  const modifiedBody1 = "A$markdownExample";
  const modifiedBody2 = "AA$markdownExample";

  final persistedModel = PersistedModel()
    ..replace(Note(id: noteId, title: 'dasd', excerpt: originalExcerpt));
  final originalJson = json.encode(persistedModel.toJson());

  persistedModel.notes.first.title = "A";
  final modifiedTitleJson = json.encode(persistedModel.toJson());

  persistedModel.notes.first.title = modifiedTitle;
  final modifiedTitleJson2 = json.encode(persistedModel.toJson());

  persistedModel.notes.first.excerpt =
      modifiedBody1.substring(0, excerptLength);
  final modifiedBodyJson1 = json.encode(persistedModel.toJson());

  persistedModel.notes.first.excerpt =
      modifiedBody2.substring(0, excerptLength);
  final modifiedBodyJson2 = json.encode(persistedModel.toJson());

  when(mockFileIO.readText(dataFilename))
      .thenAnswer((realInvocation) => Future.value(originalJson));

  when(mockFileIO.readText(mdFilename))
      .thenAnswer((realInvocation) => Future.value(originalExcerpt));

  when(mockFileIO.writeText(dataFilename, any))
      .thenAnswer((realInvocation) => Future.value());

  when(mockFileIO.writeText(mdFilename, any))
      .thenAnswer((realInvocation) => Future.value());

  builder
    ..addSingleton<FileIOBase>((container) => mockFileIO)
    ..addSingleton<NewId>((container) => () => newId);

  //Run the app
  await tester.pumpWidget(
    AppRoot(builder.toContainer()),
  );

  await matchesGoldenForTestCase<AppRoot>("NotesPage", 'Loading', caseArgs);

  tester.expectMenuSelection(isHamburger, notesKey);

  await tester.pumpAndSettle();

  await matchesGoldenForTestCase<AppRoot>("NotesPage", 'Loaded', caseArgs);

  //Check listview count
  final searchListView = tester.widget<ListView>(find.byKey(notesListViewKey));
  expect(searchListView.semanticChildCount, persistedModel.notes.length);

  //Click on note to open note page
  final key = getNoteButtonKey(persistedModel.notes.first.id);
  await tester.tapByKeyAndSettle(key);
  tester.expectMenuSelection(isHamburger, newNoteKey);

  await matchesGoldenForTestCase<AppRoot>("NotePage", 'Loading', caseArgs);

  await tester.pumpAndSettle();

  await matchesGoldenForTestCase<AppRoot>("NotePage", 'Loaded', caseArgs);

  //Enter text in the title field
  //Note each key stroke will fire a save
  //This is ineficient and we might need to change this to a single save
  //by putting a delay in between
  await tester.enterTextByKeyAndSettle(noteTitleKey, "A");
  await tester.enterTextByKeyAndSettle(noteTitleKey, modifiedTitle);

  verify(mockFileIO.writeText(dataFilename, modifiedTitleJson)).called(1);
  verify(mockFileIO.writeText(dataFilename, modifiedTitleJson2)).called(1);
  verifyNever(mockFileIO.writeText(mdFilename, any));

  await matchesGoldenForTestCase<AppRoot>(
      "NotePage", 'TitleModified', caseArgs);

  await tester.enterTextByKeyAndSettle(noteBodyKey, modifiedBody1);

  verify(mockFileIO.writeText(mdFilename, modifiedBody1)).called(1);
  verify(mockFileIO.writeText(dataFilename, modifiedBodyJson1)).called(1);

  await tester.enterTextByKeyAndSettle(noteBodyKey, modifiedBody2);

  verify(mockFileIO.writeText(mdFilename, modifiedBody2)).called(1);
  verify(mockFileIO.writeText(dataFilename, modifiedBodyJson2)).called(1);

  await matchesGoldenForTestCase<AppRoot>("NotePage", 'BodyModified', caseArgs);

  if (isHamburger) {
    //Check hamburger menu not open
    expect(find.byKey(drawerKey), findsNothing);

    // Open the hamburger menu
    await tester.tapByKeyAndSettle(hamburgerButtonKey);

    //Check it's open
    expect(find.byKey(drawerKey), findsOneWidget);

    await matchesGoldenForTestCase<AppRoot>("NotePage", 'MenuOpen', caseArgs);

    //Close menu
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();

    //Check it's closed again
    expect(find.byKey(drawerKey), findsNothing);

    await matchesGoldenForTestCase<AppRoot>("NotePage", 'MenuClosed', caseArgs);

    //Open it
    await tester.openHamburgerMenu();
  }

  //Navigate to the notes page from the menu
  await tester.tapByKeyAndSettle(notesKey);
  expect(find.byKey(drawerKey), findsNothing);
  tester.expectMenuSelection(isHamburger, notesKey);

  //Make sure we're not on the note page anymore
  //but we are on the notes page
  expect(find.byKey(noteTitleKey), findsNothing);
  expect(find.byKey(notesListViewKey), findsOneWidget);

  //Handle loading text from an md file with a random filename
  //This is the equivalent of deleting all files. Nothing will be loaded from
  //now on
  when(mockFileIO.readText(any)).thenAnswer((realInvocation) => Future.value());

  //Tap the new note button
  await tester.tapByKeyAndSettle(newNoteButtonKey);
  expect(find.byKey(noteTitleKey), findsOneWidget);
  tester.expectMenuSelection(isHamburger, newNoteKey);

  //Modify title of note that does not exist as a file
  await tester.enterTextByKeyAndSettle(noteTitleKey, "A");

  verify(mockFileIO.writeText(dataFilename,
          PersistedModel(notes: [Note(id: newId, title: 'A')]).toJsonString()))
      .called(1);

  if (isHamburger) {
    await tester.openHamburgerMenu();
  }

  //Tap the back button
  await tester.tapByKeyAndSettle(backKey);
  expect(find.byKey(notesListViewKey), findsOneWidget);
  tester.expectMenuSelection(isHamburger, notesKey);

  if (isHamburger) {
    await tester.openHamburgerMenu();
  }

  //Go to settings
  await tester.tapByKeyAndSettle(settingsKey);
  tester.expectMenuSelection(isHamburger, settingsKey);
  final checkBoxValue =
      tester.widget<Checkbox>(find.byKey(darkModeCheckBoxKey)).value;
  expect(checkBoxValue, false);

  await matchesGoldenForTestCase<AppRoot>(
      "SettingsPage", 'InitialState', caseArgs);

  await tester.tapByKeyAndSettle(darkModeCheckBoxKey);

  await matchesGoldenForTestCase<AppRoot>("SettingsPage", 'DarkMode', caseArgs);

  final modifiedSettingsJson =
      (PersistedModel()..settings.isDarkMode = true).toJsonString();

  verify(mockFileIO.writeText(dataFilename, modifiedSettingsJson)).called(1);

  //Mock settings where dark mode is turned on
  when(mockFileIO.readText(dataFilename)).thenAnswer((realInvocation) {
    return Future.value(modifiedSettingsJson);
  });

  if (isHamburger) {
    await tester.openHamburgerMenu();
  }

  //Navigate to the note page from the menu
  await tester.tapByKeyAndSettle(newNoteKey);
  expect(find.byKey(noteTitleKey), findsOneWidget);
  tester.expectMenuSelection(isHamburger, newNoteKey);

  await matchesGoldenForTestCase<AppRoot>("NotePage", 'DarkMode', caseArgs);
}

Future<void> testEmptyDataFile(
    WidgetTester tester, TestCaseArgs caseArgs) async {
  final builder = compose(allowOverrides: true);
  final mockFileIO = MockFileIOBase();

  when(mockFileIO.readText(any)).thenAnswer((realInvocation) => Future.value());

  builder.addSingleton<FileIOBase>((container) => mockFileIO);
  //Run the app
  await tester.pumpWidget(
    AppRoot(builder.toContainer()),
  );

  await tester.pumpAndSettle();

  await matchesGoldenForTestCase<AppRoot>("NotesPage", 'Empty', caseArgs);

  //Check listview count
  final searchListView = tester.widget<ListView>(find.byKey(notesListViewKey));
  expect(searchListView.semanticChildCount, 0);
}

extension ModelExtensions on PersistedModel {
  String toJsonString() => json.encode(toJson());
}

extension TesterExtensions2 on WidgetTester {
  void expectMenuSelection(bool isHamburger, Key key) => !isHamburger
      ? expect(
          widget<NavigationDrawerMenu>(find.byType(NavigationDrawerMenu))
              .selectedMenuKey,
          key)
      : null;

  Future<void> openHamburgerMenu() async {
    //Check hamburger menu not open
    expect(find.byKey(drawerKey), findsNothing);

    // Open the hamburger menu
    await tapByKeyAndSettle(hamburgerButtonKey);

    expect(find.byKey(drawerKey), findsOneWidget);
  }
}
