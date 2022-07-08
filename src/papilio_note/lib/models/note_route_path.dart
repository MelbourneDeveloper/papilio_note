import 'package:flutter/foundation.dart';

@immutable
class AppRouteInfo {
  final RouteLocation routeLocation;
  final String? noteId;
  const AppRouteInfo(this.routeLocation, {this.noteId});
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
