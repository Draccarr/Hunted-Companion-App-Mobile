import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SaveAndLoad {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeText(String _text) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$_text');
  } //end writeText

  Future<String> readText() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (_e) {
      // If encountering an error, return 0.
      return 'An exception occurred while reading the save file: ' + _e;
    }
  }
} //end SaveAndLoad class
