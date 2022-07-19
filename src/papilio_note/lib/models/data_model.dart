import 'package:flutter/material.dart';
import 'package:papilio_note/models/view_models.dart';

class Note {
  String id;
  String title;
  String excerpt;

  Note({required this.id, required this.title, String? excerpt})
      : excerpt = excerpt ?? '';

  Note.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          title: json['title']! as String,
          excerpt: json['excerpt']! as String,
        );

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'excerpt': excerpt,
      };
}

class Settings {
  bool isDarkMode;
  Settings({this.isDarkMode = false});

  Settings.fromJson(Map<String, Object?> json)
      : this(isDarkMode: json['isDarkMode']! as bool);

  Map<String, Object?> toJson() => {
        'isDarkMode': isDarkMode,
      };
}

class PersistedModelWrapper extends ChangeNotifier {
  PersistedModel _model = PersistedModel();

  PersistedModel get model => _model;

  set model(PersistedModel value) {
    _model = value;
    notifyListeners();
  }
}

class PersistedModel {
  final Settings settings;

  late final Map<String, Note> _notesById;

  PersistedModel({Settings? settings, List<Note>? notes})
      : settings = settings ?? Settings() {
    _notesById = {for (var note in notes ?? <Note>[]) note.id: note};
  }

  //TODO: Make immutable
  List<Note> get notes => _notesById.values.toList();

  Note? get(String id) => _notesById[id];

  void replace(Note note) {
    if (_notesById.containsKey(note.id)) {
      _notesById.remove(note.id);
    }
    _notesById.putIfAbsent(note.id, () => note);
  }

  PersistedModel.fromJson(Map<String, Object?> json)
      : this(
            settings:
                Settings.fromJson(json['settings']! as Map<String, Object?>),
            notes: (json['notes']! as List<dynamic>)
                .map((e) =>
                    e is Map<String, Object?> ? Note.fromJson(e) : e as Note)
                .toList());

  Map<String, Object?> toJson() => {
        'settings': settings.toJson(),
        'notes': _notesById.values.toList(),
      };
}

extension PersistedModelExtensions on PersistedModel {
  NotesViewModel toNotesViewModel() => NotesViewModel(
        _notesById.values
            .map((e) => NoteListItemViewModel(
                  id: e.id,
                  title: e.title,
                  excerpt: e.excerpt,
                ))
            .toList(),
        false,
      );
}
