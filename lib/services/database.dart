import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoTodb(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  getUserByUsername (String username) {
    FirebaseFirestore.instance.collection("users").where('username', isEqualTo: username );
  }
}
