import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadFileToStorage(String filePath, String id,
      [isVideo = false]) async {
    // creating location to our firebase storage
    File file = File(filePath);
    Reference reference = _storage.ref().child('multimedia').child(id);
    UploadTask uploadFile = reference.putFile(file);

    if (isVideo) {
      reference.updateMetadata(SettableMetadata(contentType: "video/mp4"));
    }

    reference.updateMetadata(SettableMetadata(contentType: "image"));

    TaskSnapshot snapshot = await uploadFile;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
