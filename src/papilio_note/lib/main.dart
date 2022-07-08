import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';
import 'package:papilio/container_extensions.dart';
import 'package:papilio_note/configuration/routing.dart';
import 'package:papilio_note/models/data_model.dart';
import 'package:papilio_note/models/note_route_path.dart';
import 'package:papilio_note/services/file_io/file_io_base.dart';
import 'package:papilio_note/services/file_io/file_io_selector.dart';
import 'package:papilio_note/utils/misc.dart';
import 'package:papilio_note/widgets/app_root.dart';

// coverage:ignore-start
void main() {
  runApp(AppRoot(compose(allowOverrides: true).toContainer()));
}
// coverage:ignore-end

IocContainerBuilder compose({bool allowOverrides = false}) =>
    IocContainerBuilder(allowOverrides: allowOverrides)
      ..addRouting<AppRouteInfo>(routingConfig)
      ..addSingleton((container) => NavigationDrawerState())
      ..addSingleton<FileIOBase>((container) => FileIO())
      ..addSingleton((container) => PersistedModelWrapper())
      ..addSingleton<NewId>((container) => newId);
