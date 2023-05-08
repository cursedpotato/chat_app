import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class AuthDatabaseService {
  static Future<Either<Exception, bool>> addUserInfoToDB(
    String userId,
    Map<String, dynamic> userInfoMap,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .set(userInfoMap);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
