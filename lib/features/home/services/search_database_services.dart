import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDatabaseService {
  static Future<QuerySnapshot<Map<String, dynamic>>> getUserByName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: query)
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserByUserName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .get();
  }
}
