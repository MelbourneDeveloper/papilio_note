import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:mockito/mockito.dart';
import 'package:papilio/papilio_router_delegate.dart';
import 'package:papilio/papilio_routing_configuration.dart';
import 'package:papilio_note/configuration/routing.dart';
import 'package:papilio_note/main.dart';
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

  ///This tests the onSetNewRoutePath directly
  test('Test onSetNewRoutePath', () async {
    final mockDelegate = MockPapilioRouterDelegate();
    await onSetNewRoutePath(
        mockDelegate,
        const AppRouteInfo(
          RouteLocation.notes,
        ));
    verify(mockDelegate.navigate<AppViewModel<NotesViewModel>>(notesKey))
        .called(1);
    await onSetNewRoutePath(
      mockDelegate,
      const AppRouteInfo(RouteLocation.settings),
    );
    verify(mockDelegate.navigate<AppViewModel<SettingsViewModel>>(settingsKey))
        .called(1);
    await onSetNewRoutePath(
        mockDelegate,
        const AppRouteInfo(
          RouteLocation.note,
          noteId: "123",
        ));
    verify(mockDelegate.navigate<AppViewModel<NoteViewModel>>(newNoteKey,
            arguments: "123"))
        .called(1);
  });

  ///This tests that the function on PapilioRoutingConfiguration correctly calls
  ///onSetNewRoutePath
  ///Regression for https://github.com/MelbourneDeveloper/papilio_note/issues/1
  test('Test Composition Correctly Wires Up onSetNewRoutePath', () async {
    final mockDelegate = MockPapilioRouterDelegate();

    final builder = compose(allowOverrides: true);

    builder.addSingleton<PapilioRouterDelegate<AppRouteInfo>>(
        (container) => mockDelegate);

    final container = builder.toContainer();
    final config = container.get<PapilioRoutingConfiguration<AppRouteInfo>>();
    await config.onSetNewRoutePath!(
        mockDelegate, const AppRouteInfo(RouteLocation.notes));

    verify(mockDelegate.navigate<AppViewModel<NotesViewModel>>(notesKey))
        .called(1);
  });
}
