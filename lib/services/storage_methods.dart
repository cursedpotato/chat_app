


import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  

  // adding image to firebase storage
  Future<String> uploadFileToStorage(String filePath) async {
    // creating location to our firebase storage
    File file = File(filePath);
    Reference ref =
        _storage.ref().child(filePath);
    final uploadFile = ref.putFile(file);
   
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}