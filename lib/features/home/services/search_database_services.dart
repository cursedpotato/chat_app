import 'package:cloud_firestore/cloud_firestore.dart';

class SearchDatabaseService {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: query)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUserName(
      String query) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .get();
  }
}
