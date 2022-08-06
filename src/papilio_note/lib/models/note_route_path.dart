import "package:flutter/foundation.dart";

@immutable
class AppRouteInfo {
  const AppRouteInfo(this.routeLocation, {this.noteId});
  final RouteLocation routeLocation;
  final String? noteId;
  @override
  bool operator ==(Object other) =>
      other is AppRouteInfo &&
      other.runtimeType == runtimeType &&
      other.routeLocation == routeLocation &&
      other.noteId == noteId;

  @override
  int get hashCode =>
      '${routeLocation.toString()}${noteId?.toString()}'.hashCode;
}

enum RouteLocation { notes, note, settings }
