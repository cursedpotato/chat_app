import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/strings.dart';

@immutable
class AuthSignInModel {
  final bool isAsyncCall;
  final Either<Exception, bool> isSigningIn;

  const AuthSignInModel({required this.isAsyncCall, required this.isSigningIn});

  // Create a copywith method to update the isSigningIn property
  AuthSignInModel copyWith({
    Either<Exception, bool> isSigningIn = const Right(false),
    bool isAsyncCall = false,
  }) {
    return AuthSignInModel(
      isAsyncCall: isAsyncCall,
      isSigningIn: isSigningIn,
    );
  }

  static Map<String, dynamic> createUserInfoMap(User userDetails) {
    String? email = userDetails.email;
    String? username = email!.substring(0, email.indexOf('@'));
    return {
      "email": userDetails.email,
      "username": username,
      "name": userDetails.displayName ?? username,
      "imgUrl": userDetails.photoURL ?? noImage,
    };
  }
}
