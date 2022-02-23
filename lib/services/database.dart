import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoTodb(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .snapshots();
  }
}
