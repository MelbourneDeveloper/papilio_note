// coverage:ignore-file
//This file is tested elsewhere and we will move this out of this
//repo anyway

import 'dart:io';

import 'package:papilio_note/services/file_io/file_io_base.dart';

import 'package:path_provider/path_provider.dart';

Future<String> _getPath() async =>
    (await getApplicationDocumentsDirectory()).path;

class FileIO implements FileIOBase {
  final Future<String> Function() _getStoragePath;

  FileIO({Future<String> Function()? getStoragePath})
      : _getStoragePath = getStoragePath ?? _getPath;

  @override
  Future<void> writeText(String fileName, String text) async {
    final directory = await _getStoragePath();

    final file = File("${"$directory/"}$fileName");
    //ignore: avoid-ignoring-return-values
    await file.writeAsString(text, flush: true);
  }

  @override
  Future<String?> readText(String fileName) async {
    final directory = await _getStoragePath();
    final file = File("${"$directory/"}$fileName");

    if (!file.existsSync()) {
      return null;
    }

    return file.readAsString();
  }

  @override
  Future<void> deleteFile(String fileName) async {
    final directory = await _getStoragePath();
    final file = File("${"$directory/"}$fileName");

    if (!file.existsSync()) {
      return;
    }

    //ignore: avoid-ignoring-return-values
    await file.delete();
  }
}
