


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // adding image to firebase storage
  Future<String> uploadFileToStorage(String filePath) async {
    // creating location to our firebase storage
    File file = File(filePath);
    Reference ref =
        _storage.ref().child('multimedia').child(_auth.currentUser!.uid);
    UploadTask uploadFile = ref.putFile(file);
   
    TaskSnapshot snapshot = await uploadFile;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}