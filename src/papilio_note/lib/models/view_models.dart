import 'package:flutter/material.dart';
import 'package:papilio/bloc.dart';
import 'package:papilio_note/models/data_model.dart';
import 'package:papilio_note/utils/constants.dart';

abstract class HasPageKey {
  Key get pageKey;
  const HasPageKey();
}

//View Models

@immutable
class AppViewModel<T extends HasPageKey> {
  const AppViewModel(this.title, this.pageViewModel);
  final String title;
  final T pageViewModel;

  static const AppViewModel<NotesViewModel> emptyNotesViewModel =
      AppViewModel<NotesViewModel>('Papilio Note', NotesViewModel.empty);

  static const emptySettingsViewModel = AppViewModel<SettingsViewModel>(
    'Papilio Note Settings',
    SettingsViewModel(false),
  );

  AppViewModel<T> copyWith({String? title, T? pageViewModel}) {
    return AppViewModel<T>(
      title ?? this.title,
      pageViewModel ?? this.pageViewModel,
    );
  }
}

@immutable
class NoteViewModel extends HasPageKey {
  final String id;
  final String title;
  final String body;
  final bool isLoading;
  NoteViewModel(this.id, {String? title, String? body, bool? isLoading})
      : title = title ?? emptyTitle,
        body = body ?? '',
        isLoading = isLoading ?? true;

  static const emptyTitle = 'Untitled';

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
  final String title;
  final String excerpt;
  final String id;
  const NoteListItemViewModel({
    required this.title,
    required this.excerpt,
    required this.id,
  });
}

@immutable
class NotesViewModel extends HasPageKey {
  //TODO: use immutable lists
  final List<NoteListItemViewModel> notes;
  final bool isLoading;
  const NotesViewModel(this.notes, this.isLoading);

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
  final bool isDarkMode;
  const SettingsViewModel(this.isDarkMode);

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
  final String body;
  ModifyBodyEvent(this.body);
}

@immutable
class ModifyNoteTitle extends BlocEvent {
  final String noteTitle;
  ModifyNoteTitle(this.noteTitle);
}

@immutable
class NavigateToNoteEvent extends BlocEvent {
  final String noteId;
  NavigateToNoteEvent(this.noteId);
}

class NewNoteEvent extends BlocEvent {}

@immutable
class SetTheme extends BlocEvent {
  final bool isDarkMode;
  const SetTheme(this.isDarkMode);
}

@immutable
class LoadSettingsEvent extends BlocEvent {
  const LoadSettingsEvent();
}

@immutable
class Dummy extends BlocEvent {}
