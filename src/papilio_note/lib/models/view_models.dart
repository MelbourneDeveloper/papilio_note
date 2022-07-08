import 'package:flutter/material.dart';
import 'package:md/models/data_model.dart';
import 'package:md/utils/constants.dart';
import 'package:papilio/bloc.dart';

//View Models

@immutable
class AppViewModel<T> {
  const AppViewModel(this.title, this.pageViewModel, {this.selectedPageKey});
  final String title;
  final T pageViewModel;
  final Key? selectedPageKey;

  static const AppViewModel<NotesViewModel> emptyNotesViewModel =
      AppViewModel<NotesViewModel>('Papilio Note', NotesViewModel.empty,
          selectedPageKey: notesKey);

  static const emptySettingsViewModel = AppViewModel<SettingsViewModel>(
      'Papilio Note Settings', SettingsViewModel(false),
      selectedPageKey: settingsKey);

  AppViewModel<T> copyWith({String? title, T? pageViewModel}) {
    return AppViewModel<T>(
        title ?? this.title, pageViewModel ?? this.pageViewModel,
        selectedPageKey: selectedPageKey);
  }
}

@immutable
class NoteViewModel {
  final String id;
  final String title;
  final String body;
  final bool isLoading;
  NoteViewModel(this.id, {String? title, String? body, bool? isLoading})
      : title = title ?? emptyTitle,
        body = body ?? '',
        isLoading = isLoading ?? true;

  static const emptyTitle = 'Untitled';

  NoteViewModel copyWith(
          {String? id, String? title, String? body, bool? isLoading}) =>
      NoteViewModel(id ?? this.id,
          title: title ?? this.title,
          body: body ?? this.body,
          isLoading: isLoading ?? this.isLoading);
}

@immutable
class NoteListItemViewModel {
  final String title;
  final String excerpt;
  final String id;
  const NoteListItemViewModel(
      {required this.title, required this.excerpt, required this.id});
}

@immutable
class NotesViewModel {
  //TODO: use immutable lists
  final List<NoteListItemViewModel> notes;
  final bool isLoading;
  const NotesViewModel(this.notes, this.isLoading);

  static const NotesViewModel empty = NotesViewModel([], true);

  NotesViewModel copyWith(
          {List<NoteListItemViewModel>? notes, bool? isLoading}) =>
      NotesViewModel(notes ?? this.notes, isLoading ?? this.isLoading);
}

@immutable
class SettingsViewModel {
  final bool isDarkMode;
  const SettingsViewModel(this.isDarkMode);

  SettingsViewModel copyWith({bool? isDarkMode}) =>
      SettingsViewModel(isDarkMode ?? this.isDarkMode);
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
