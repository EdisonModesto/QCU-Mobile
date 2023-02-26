

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudService{
  Future<String> addItemImage(fileName,File file) async {
    var ref = await FirebaseStorage.instance.ref("uploads/$fileName").putFile(file);
    print("IM GERE");
    return await ref.ref.getDownloadURL();

  }
}