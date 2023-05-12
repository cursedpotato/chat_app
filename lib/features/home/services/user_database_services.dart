import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getChatteInfo(String username) async {
  return await FirebaseFirestore.instance
      .collection("users")
      .where("username", isEqualTo: username)
      .get();
}
