// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:papilio_note/services/file_io/file_io_base.dart';

class FileIO implements FileIOBase {
  @override
  Future<void> deleteFile(String fileName) {
    //ignore: avoid-ignoring-return-values
    html.window.localStorage.remove(fileName);

    return Future.value();
  }

  @override
  Future<String?> readText(String fileName) {
    final localStorage2 = html.window.localStorage[fileName];
    if (localStorage2 == null) {
      return Future.value();
    }

    return Future.value(localStorage2.toString());
  }

  @override
  Future writeText(String fileName, String text) {
    html.window.localStorage[fileName] = text;

    return Future.value();
  }
}
