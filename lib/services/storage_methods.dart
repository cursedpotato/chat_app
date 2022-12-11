import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_compress/video_compress.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadFileToStorage(String filePath, String id,
      [bool isVideo = false]) async {
    // creating location to our firebase storage
    File file = File(filePath);
    Reference reference = _storage.ref().child('multimedia').child(id);
    UploadTask uploadFile = reference.putFile(file);

    TaskSnapshot snapshot = await uploadFile;
    String downloadUrl = await snapshot.ref.getDownloadURL().then((value) {
      reference.updateMetadata(SettableMetadata(contentType: "image"));

      if (isVideo) {
        reference.updateMetadata(SettableMetadata(contentType: "video/mp4"));
      }

      return value;
    });

    return downloadUrl;
  }

  Future<String> uploadThumbnail(File videoFile, String id) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      videoFile.path,
      quality: 50, // default(100)
      position: -1, // default(-1)
    );
    Reference reference = _storage.ref().child('thumbnails').child(id);
    UploadTask uploadFile = reference.putFile(thumbnailFile);
    TaskSnapshot snapshot = await uploadFile;

    String downloadUrl = await snapshot.ref.getDownloadURL().then((value) {
      reference.updateMetadata(SettableMetadata(contentType: "image"));
      return value;
    });

    return downloadUrl;
  }
}
