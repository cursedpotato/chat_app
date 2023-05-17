import 'package:chat_app/features/auth/models/auth_model.dart';
import 'package:chat_app/features/auth/services/database_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthSignInModel>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<AuthSignInModel> {
  late Future<Either<Exception, User>> authMethod;

  AuthNotifier()
      : super(const AuthSignInModel(
          isAsyncCall: false,
          isSigningIn: Right(false),
        ));

  Future<void> signIn() {
    state = state.copyWith(isAsyncCall: true, isSigningIn: const Right(false));
    return authMethod.then((value) {
      value.fold(
        (l) => _returnException(l),
        (r) => _addUserToDb(r),
      );
    });
  }

  Future _addUserToDb(User userDetails) async {
    Map<String, dynamic> userInfoMap =
        AuthSignInModel.createUserInfoMap(userDetails);
    String userId = userDetails.uid;
    final result =
        await AuthDatabaseService.addUserInfoToDB(userId, userInfoMap);

    result.fold(
      (l) => _returnException(l),
      (r) => _toggleIsSigningIn(),
    );
  }

  void _returnException(Exception e) {
    state = state.copyWith(isAsyncCall: false, isSigningIn: Left(e));
  }

  void _toggleIsSigningIn() {
    state = state.copyWith(isAsyncCall: false, isSigningIn: const Right(true));
  }
}
