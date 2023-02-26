import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'CloudService.dart';

class FilePickerService{
  Future<String> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var url = "";

    if (result != null) {
      File file = File(result.files.single.path!);
      //Uint8List? fileBytes = result.files.single.bytes;
      String fileName = result.files.first.name;

      // Upload file
      url = await CloudService().addItemImage(fileName, file);
    }
    return url;
  }
}