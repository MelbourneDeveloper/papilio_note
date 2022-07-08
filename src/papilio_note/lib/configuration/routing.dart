import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:md/configuration/pages.dart';

import 'package:md/models/note_route_path.dart';
import 'package:md/models/view_models.dart';
import 'package:md/utils/constants.dart';
import 'package:papilio/page_args.dart';
import 'package:papilio/papilio_router_delegate.dart';
import 'package:papilio/papilio_routing_configuration.dart';

///Configures routing in the app and handles navigation
PapilioRoutingConfiguration<AppRouteInfo> routingConfig(
        IocContainer container) =>
    PapilioRoutingConfiguration(
        onInit: (delegate, container) =>
            delegate.navigate<AppViewModel<NotesViewModel>>(notesKey),
        onSetNewRoutePath: (delegate, configuration) async => onSetNewRoutePath,
        buildRoutes: (delegateBuilder) => delegateBuilder
          ..addNotesPage(container)
          ..addNotePage(container)
          ..addSettingsPage(container),
        currentRouteConfiguration: (page) => page.name == notesKey.value
            ? const AppRouteInfo(RouteLocation.notes)
            : page.name == settingsKey.value
                ? const AppRouteInfo(RouteLocation.settings)
                : AppRouteInfo(RouteLocation.note,
                    noteId: (page.arguments! as PageArgs).arguments! as String),
        parseRouteInformation: parseRouteInformation,
        restoreRouteInformation: (appRouteInfo) =>
            //Note: we can serialize state here
            //and deserialize it in parseRouteInformation
            appRouteInfo.routeLocation == RouteLocation.note
                ? RouteInformation(
                    location: '${newNoteKey.value}/${appRouteInfo.noteId}',
                  )
                : appRouteInfo.routeLocation == RouteLocation.settings
                    ? RouteInformation(location: settingsKey.value)
                    : RouteInformation(location: notesKey.value));

void onSetNewRoutePath(AppRouteInfo configuration,
        PapilioRouterDelegate<AppRouteInfo> delegate) =>
    configuration.routeLocation == RouteLocation.note
        ? delegate.navigate<AppViewModel<NoteViewModel>>(newNoteKey,
            arguments: configuration.noteId)
        : configuration.routeLocation == RouteLocation.notes
            ? delegate.navigate<AppViewModel<NotesViewModel>>(notesKey)
            : delegate.navigate<AppViewModel<SettingsViewModel>>(settingsKey);

///Converts a Url string in to [AppRouteInfo]
Future<AppRouteInfo> parseRouteInformation(
    RouteInformation routeInformation) async {
  if (routeInformation.location == null || routeInformation.location == '/') {
    return defaultRouteInfo;
  }

  final uri = Uri.parse(routeInformation.location!);

  if (uri.pathSegments.isEmpty) {
    return defaultRouteInfo;
  }

  final routeName = '/${uri.pathSegments.first}';

  if (routeName == notesKey.value) {
    return defaultRouteInfo;
  }

  if (routeName == settingsKey.value) {
    return const AppRouteInfo(
      RouteLocation.settings,
    );
  }

  if (routeName == newNoteKey.value) {
    if (uri.pathSegments.length < 2 || uri.pathSegments[1] == '') {
      //The url was the note page without an id so boot the user
      //back to the default page.
      return defaultRouteInfo;
    }

    return AppRouteInfo(
      RouteLocation.note,
      noteId: uri.pathSegments[1],
    );
  }

  //Some unknown url so boot the user back to the default page.
  return defaultRouteInfo;
}
