import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

updateUserTs() {
  // We need the userId to access the document
  final userId = FirebaseAuth.instance.currentUser?.uid;
  FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .update({"userActivityTs": DateTime.now()});
}

Future<QuerySnapshot> getUserInfo(String username) async {
  return await FirebaseFirestore.instance
      .collection("users")
      .where("username", isEqualTo: username)
      .get();
}
