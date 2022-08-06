import "package:flutter/material.dart";
import "package:papilio/bloc.dart";
import "package:papilio_note/models/data_model.dart";
import "package:papilio_note/utils/constants.dart";

abstract class HasPageKey {
  const HasPageKey();
  Key get pageKey;
}

//View Models

@immutable
class AppViewModel<T extends HasPageKey> {
  const AppViewModel(this.title, this.pageViewModel);
  final String title;
  final T pageViewModel;

  static const AppViewModel<NotesViewModel> emptyNotesViewModel =
      AppViewModel<NotesViewModel>("Papilio Note", NotesViewModel.empty);

  static const emptySettingsViewModel = AppViewModel<SettingsViewModel>(
    "Papilio Note Settings",
    SettingsViewModel(false),
  );

  AppViewModel<T> copyWith({String? title, T? pageViewModel}) =>
      AppViewModel<T>(
        title ?? this.title,
        pageViewModel ?? this.pageViewModel,
      );
}

@immutable
class NoteViewModel extends HasPageKey {
  const NoteViewModel(this.id, {String? title, String? body, bool? isLoading})
      : title = title ?? emptyTitle,
        body = body ?? "",
        isLoading = isLoading ?? true;
  final String id;
  final String title;
  final String body;
  final bool isLoading;

  static const emptyTitle = "Untitled";

  NoteViewModel copyWith({
    String? id,
    String? title,
    String? body,
    bool? isLoading,
  }) =>
      NoteViewModel(
        id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  Key get pageKey => newNoteKey;
}

@immutable
class NoteListItemViewModel {
  const NoteListItemViewModel({
    required this.title,
    required this.excerpt,
    required this.id,
  });
  final String title;
  final String excerpt;
  final String id;
}

@immutable
class NotesViewModel extends HasPageKey {
  const NotesViewModel(this.notes, this.isLoading);
  //TODO: use immutable lists
  final List<NoteListItemViewModel> notes;
  final bool isLoading;

  static const NotesViewModel empty = NotesViewModel([], true);

  NotesViewModel copyWith({
    List<NoteListItemViewModel>? notes,
    bool? isLoading,
  }) =>
      NotesViewModel(notes ?? this.notes, isLoading ?? this.isLoading);

  @override
  Key get pageKey => notesKey;
}

@immutable
class SettingsViewModel extends HasPageKey {
  const SettingsViewModel(this.isDarkMode);
  final bool isDarkMode;

  SettingsViewModel copyWith({bool? isDarkMode}) =>
      SettingsViewModel(isDarkMode ?? this.isDarkMode);

  @override
  Key get pageKey => settingsKey;
}

extension NoteViewModelExtensions on NoteViewModel {
  Note toNote() => Note(id: id, title: title, excerpt: body);
}

//Events

@immutable
class LoadNotesEvent extends BlocEvent {}

@immutable
class LoadNoteEvent extends BlocEvent {}

@immutable
class ModifyBodyEvent extends BlocEvent {
  const ModifyBodyEvent(this.body);
  final String body;
}

@immutable
class ModifyNoteTitle extends BlocEvent {
  const ModifyNoteTitle(this.noteTitle);
  final String noteTitle;
}

@immutable
class NavigateToNoteEvent extends BlocEvent {
  const NavigateToNoteEvent(this.noteId);
  final String noteId;
}

class NewNoteEvent extends BlocEvent {}

@immutable
class SetTheme extends BlocEvent {
  const SetTheme(this.isDarkMode);
  final bool isDarkMode;
}

@immutable
class LoadSettingsEvent extends BlocEvent {
  const LoadSettingsEvent();
}

@immutable
class Dummy extends BlocEvent {}
