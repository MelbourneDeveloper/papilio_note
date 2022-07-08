import 'package:uuid/uuid.dart';

typedef NewId = String Function();

String newId() => const Uuid().v4().toString();