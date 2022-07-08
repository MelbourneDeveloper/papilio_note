import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';

import 'package:md/models/data_model.dart';
import 'package:md/models/note_route_path.dart';
import 'package:md/models/view_models.dart';
import 'package:md/pages/note.dart' as notey;
import 'package:md/pages/notes.dart';
import 'package:md/pages/settings.dart';
import 'package:md/services/file_io/file_io_base.dart';

import 'package:md/utils/constants.dart';
import 'package:md/utils/misc.dart';
import 'package:md/widgets/app_scaffold.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';
import 'package:papilio/container_extensions.dart';
import 'package:papilio/papilio_router_delegate.dart';
import 'package:papilio/papilio_router_delegate_builder.dart';

extension RouterPages on PapilioRouterDelegateBuilder<AppRouteInfo> {
  void addNotesPage(IocContainer container) =>
      addPage<AppViewModel<NotesViewModel>>(
          initialEvent: LoadNotesEvent(),
          container: container,
          name: notesKey.value,
          initialState: (arguments) => AppViewModel.emptyNotesViewModel,
          pageBody: (c) =>
              pageBody<NotesViewModel>(container, const Notes(), c),
          buildBloc: (blocBuilder, container) => blocBuilder
            ..addSyncHandler<NavigateToNoteEvent>((state, event) {
              container.navigate<AppViewModel<NoteViewModel>, AppRouteInfo>(
                  newNoteKey,
                  arguments: event.noteId);
              return state;
            })
            ..addSyncHandler<NewNoteEvent>((state, event) {
              container.navigate<AppViewModel<NoteViewModel>, AppRouteInfo>(
                  newNoteKey,
                  arguments: container.get<NewId>()());

              return state;
            })
            ..addHandler<LoadNotesEvent>(
                (getState, event, updateState, pageScope) async {
              final appViewModel = getState();

              updateState(appViewModel.copyWith(
                  pageViewModel:
                      appViewModel.pageViewModel.copyWith(isLoading: true)));

              final persistedModel = await load(container);

              container.get<PersistedModelWrapper>().model = persistedModel;

              return getState()
                  .copyWith(pageViewModel: persistedModel.toNotesViewModel());
            }));

  void addSettingsPage(IocContainer container) => addPage<
          AppViewModel<SettingsViewModel>>(
      initialEvent: const LoadSettingsEvent(),
      container: container,
      name: settingsKey.value,
      initialState: (arguments) => AppViewModel.emptySettingsViewModel,
      pageBody: (context) =>
          pageBody<SettingsViewModel>(container, const SettingsPage(), context),
      buildBloc: (blocBuilder, container) => blocBuilder
        ..addHandler<SetTheme>((getState, event, updateState, pageScope) async {
          final appViewModel = getState();

          final persistedModel = await load(container);

          persistedModel.settings.isDarkMode = event.isDarkMode;

          //This triggers setState so that the theme changes
          container.get<PersistedModelWrapper>().model = persistedModel;

          await save(persistedModel, container);

          return getState().copyWith(
              pageViewModel: appViewModel.pageViewModel
                  .copyWith(isDarkMode: event.isDarkMode));
        })
        ..addHandler<LoadSettingsEvent>(
            (getState, event, updateState, pageScope) async {
          final appViewModel = getState();

          final persistedModel = await load(container);

          return getState().copyWith(
              pageViewModel: appViewModel.pageViewModel
                  .copyWith(isDarkMode: persistedModel.settings.isDarkMode));
        }));

  void addNotePage(IocContainer container) => addPage<
          AppViewModel<NoteViewModel>>(
      container: container,
      name: newNoteKey.value,
      initialEvent: LoadNoteEvent(),
      initialState: (arguments) => AppViewModel(
            NoteViewModel.emptyTitle,
            NoteViewModel(container.get<NewId>()()),
          ).copyWith(
              pageViewModel: NoteViewModel(container.get<NewId>()())
                  .copyWith(id: arguments! as String)),
      pageBody: (c) =>
          pageBody<NoteViewModel>(container, const notey.Note(), c),
      buildBloc: (blocBuilder, container) => blocBuilder
        ..addHandler<LoadNoteEvent>(
            (getState, event, updateState, pageScope) async {
          var appViewModel = getState();

          final md =
              (await getMd(container, appViewModel.pageViewModel.id)) ?? '';

          final persistedModel = await load(container);

          appViewModel = getState();

          var note = persistedModel.get(appViewModel.pageViewModel.id);

          note ??= appViewModel.pageViewModel.toNote();

          return appViewModel.copyWith(
              title: note.title,
              pageViewModel: appViewModel.pageViewModel
                  .copyWith(isLoading: false, title: note.title, body: md));
        })
        ..addSyncHandler<ModifyBodyEvent>((state, event) => state.copyWith(
            pageViewModel: state.pageViewModel.copyWith(body: event.body)))
        ..addHandler<ModifyNoteTitle>(
            (getState, event, update, pageScope) async {
          final state = getState();
          final model = await load(container);

          model.replace(state.pageViewModel.toNote()..title = event.noteTitle);

          await save(model, container);
          return getState();
        })
        ..addHandler<ModifyBodyEvent>(
            (getstate, event, update, pageScope) async {
          final state = getstate();
          await saveMd(container, state.pageViewModel.id, event.body);
          final persistedModel = await load(container);

          persistedModel.replace(state.pageViewModel.toNote()
            ..excerpt =
                event.body.substring(0, min(event.body.length, excerptLength)));

          await save(persistedModel, container);

          return getstate();
        })
        ..addSyncHandler<ModifyNoteTitle>((state, event) => state.copyWith(
            title: event.noteTitle,
            pageViewModel:
                state.pageViewModel.copyWith(title: event.noteTitle))));
}

AppScaffold<T> pageBody<T>(
        IocContainer container, Widget body, BuildContext context) =>
    AppScaffold<T>(
        navigationDrawerState: container.get(),
        menuMode: container.get<NavigationDrawerState>().menuMode(context),
        onHamburgerPressed: (c) =>
            container.get<NavigationDrawerState>().toggle(c),
        onMenuItemSelected: (c, key) => onMenuItemSelected(container, c, key!),
        body: body);

void onMenuItemSelected(IocContainer container, BuildContext context,
    ValueKey<String> selectedMenuItemKey) {
  final niceRouterDelegate =
      container.get<PapilioRouterDelegate<AppRouteInfo>>();
  if (selectedMenuItemKey == newNoteKey) {
    niceRouterDelegate.navigate<AppViewModel<NoteViewModel>>(
        selectedMenuItemKey,
        arguments: container.get<NewId>()());
  } else if (selectedMenuItemKey == notesKey) {
    niceRouterDelegate
        .navigate<AppViewModel<NotesViewModel>>(selectedMenuItemKey);
  } else if (selectedMenuItemKey == backKey) {
    niceRouterDelegate.pop();
  } else if (selectedMenuItemKey == settingsKey) {
    niceRouterDelegate
        .navigate<AppViewModel<SettingsViewModel>>(selectedMenuItemKey);
  }
}

Future<void> save(PersistedModel persistedModel, IocContainer ic) => ic
    .get<FileIOBase>()
    .writeText(dataFilename, jsonEncode(persistedModel.toJson()));

Future<PersistedModel> load(IocContainer ic) async {
  final json = await ic.get<FileIOBase>().readText(dataFilename);

  final persistedModel = json != null
      ? PersistedModel.fromJson(jsonDecode(json))
      : PersistedModel();

  return persistedModel;
}

Future<String?> getMd(IocContainer ic, String id) =>
    ic.get<FileIOBase>().readText('$id.md');

Future saveMd(IocContainer ic, String id, String md) =>
    ic.get<FileIOBase>().writeText('$id.md', md);