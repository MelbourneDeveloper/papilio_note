import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:papilio_note/configuration/routing.dart';
import 'package:papilio_note/models/note_route_path.dart';
import 'package:papilio_note/models/view_models.dart';
import 'package:papilio_note/utils/constants.dart';

import 'app_test.mocks.dart';

class RouteTestCase {
  final String? location;
  final AppRouteInfo appRouteInfo;

  const RouteTestCase(this.location, this.appRouteInfo);
}

const routeTestCases = [
  RouteTestCase(null, AppRouteInfo(RouteLocation.notes)),
  RouteTestCase("", AppRouteInfo(RouteLocation.notes)),
  RouteTestCase("dfafasd", AppRouteInfo(RouteLocation.notes)),
  RouteTestCase("/", AppRouteInfo(RouteLocation.notes)),
  RouteTestCase("/notes", AppRouteInfo(RouteLocation.notes)),
  RouteTestCase("/note/123", AppRouteInfo(RouteLocation.note, noteId: "123")),
  RouteTestCase(
      "/note/settings", AppRouteInfo(RouteLocation.note, noteId: "settings")),
  RouteTestCase("/settings", AppRouteInfo(RouteLocation.settings)),
  RouteTestCase("/settings/", AppRouteInfo(RouteLocation.settings)),
  RouteTestCase("/note/", AppRouteInfo(RouteLocation.notes)),
];

void main() {
  test('Test Url Parsing', () async {
    routeTestCases.forEach((element) async {
      final actual = await parseRouteInformation(
          RouteInformation(location: element.location));
      expect(actual, element.appRouteInfo);
      expect(actual.hashCode, element.appRouteInfo.hashCode);
    });
  });

  test('Test onSetNewRoutePath', () async {
    final mockDelegate = MockPapilioRouterDelegate();
    onSetNewRoutePath(const AppRouteInfo(RouteLocation.notes), mockDelegate);
    verify(mockDelegate.navigate<AppViewModel<NotesViewModel>>(notesKey))
        .called(1);
    onSetNewRoutePath(const AppRouteInfo(RouteLocation.settings), mockDelegate);
    verify(mockDelegate.navigate<AppViewModel<SettingsViewModel>>(settingsKey))
        .called(1);
    onSetNewRoutePath(
        const AppRouteInfo(RouteLocation.note, noteId: "123"), mockDelegate);
    verify(mockDelegate.navigate<AppViewModel<NoteViewModel>>(newNoteKey,
            arguments: "123"))
        .called(1);
  });
}
