// coverage:ignore-file
//This file is tested elsewhere and we will move this out of this
//repo anyway

import 'dart:io';

import 'package:md/services/file_io/file_io_base.dart';

import 'package:path_provider/path_provider.dart';

class FileIO implements FileIOBase {
  late final Future<String> Function() _getStoragePath;

  FileIO({Future<String> Function()? getStoragePath}) {
    _getStoragePath = getStoragePath ??
        () async => (await getApplicationDocumentsDirectory()).path;
  }

  @override
  Future writeText(String fileName, String text) async {
    final directory = await _getStoragePath();

    final file = File("${"$directory/"}$fileName");
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
  Future deleteFile(String fileName) async {
    final directory = await _getStoragePath();
    final file = File("${"$directory/"}$fileName");

    if (!file.existsSync()) {
      return;
    }

    await file.delete();
  }
}
