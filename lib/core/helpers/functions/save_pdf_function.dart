import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<bool> saveFileToStorage(File file) async {
  try {
    Directory? selectedDirectory;
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath != null) {
      selectedDirectory = Directory(directoryPath);
      File newFile = File('${selectedDirectory.path}/${file.path.split('@').last}');
      await newFile.writeAsBytes(await file.readAsBytes());
      if (kDebugMode) {
        print('File saved to: ${newFile.path}');

      } // Debug print statement
      return true;
        }
    return false;
  } catch (e) {
    if (kDebugMode) {
      print('Error saving file: $e');
    }
    return false;

  }
}


