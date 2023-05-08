import 'package:chat_app/core/models/chat_user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/strings.dart';

@immutable
class AuthSignInModel {
  final bool isAsyncCall;
  final Either<Exception, bool> isSigningIn;

  const AuthSignInModel({
    required this.isAsyncCall,
    required this.isSigningIn,
  });

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

  static Map<String, dynamic> createUserInfoMap(User user) {
    String? email = user.email;
    String? username = email!.substring(0, email.indexOf('@'));
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUserModel(
      image: user.photoURL ?? noImage,
      about: 'Hey there! I am using Capychat 😎',
      name: user.displayName ?? username,
      createdAt: time,
      isOnline: false,
      id: user.uid,
      lastActive: time,
      email: email,
      pushToken: '',
    );

    return chatUser.toJson();
  }
}
