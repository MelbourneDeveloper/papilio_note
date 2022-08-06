import "package:flutter/material.dart";
import "package:papilio_note/models/view_models.dart";

class Note {

  Note({required this.id, required this.title, final String? excerpt})
      : excerpt = excerpt ?? "";

  Note.fromJson(final Map<String, Object?> json)
      : this(
          id: json["id"]! as String,
          title: json["title"]! as String,
          excerpt: json["excerpt"]! as String,
        );
  String id;
  String title;
  String excerpt;

  Map<String, Object?> toJson() => {
        "id": id,
        "title": title,
        "excerpt": excerpt,
      };
}

class Settings {

  Settings.fromJson(final Map<String, Object?> json)
      : this(isDarkMode: json["isDarkMode"]! as bool);
  Settings({this.isDarkMode = false});
  bool isDarkMode;

  Map<String, Object?> toJson() => {
        "isDarkMode": isDarkMode,
      };
}

class PersistedModelWrapper extends ChangeNotifier {
  PersistedModel _model = PersistedModel();

  PersistedModel get model => _model;

  set model(final PersistedModel value) {
    _model = value;
    notifyListeners();
  }
}

class PersistedModel {

  PersistedModel({final Settings? settings, final List<Note>? notes})
      : settings = settings ?? Settings(),
        _notesById = {for (var note in notes ?? <Note>[]) note.id: note};

  PersistedModel.fromJson(final Map<String, Object?> json)
      : this(
          settings:
              Settings.fromJson(json["settings"]! as Map<String, Object?>),
          notes: (json["notes"]! as List<dynamic>)
              .map((final e) =>
                  e is Map<String, Object?> ? Note.fromJson(e) : e as Note)
              .toList(),
        );
  final Settings settings;

  final Map<String, Note> _notesById;

  //TODO: Make immutable
  List<Note> get notes => _notesById.values.toList();

  Note? get(final String id) => _notesById[id];

  void replace(final Note note) {
    if (_notesById.containsKey(note.id)) {
      //ignore: avoid-ignoring-return-values
      _notesById.remove(note.id);
    }
    //ignore: avoid-ignoring-return-values
    _notesById.putIfAbsent(note.id, () => note);
  }

  Map<String, Object?> toJson() => {
        "settings": settings.toJson(),
        "notes": _notesById.values.toList(),
      };
}

extension PersistedModelExtensions on PersistedModel {
  NotesViewModel toNotesViewModel() => NotesViewModel(
        _notesById.values
            .map((final e) => NoteListItemViewModel(
                  id: e.id,
                  title: e.title,
                  excerpt: e.excerpt,
                ))
            .toList(),
        false,
      );
}
