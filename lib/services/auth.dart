
import 'package:chat_app/pages/chats/chat_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';


import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../helperfunctions/sharedpref_helper.dart';

class AuthMethods {
  Future<UserCredential> signInWithMail(String mail, String password) async{
  
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: mail,
    password: password
  );
  return userCredential;

  }


  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails?.email);
      SharedPreferenceHelper().saveUserId(userDetails?.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails?.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails?.displayName);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails?.photoURL);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails?.email,
        "username": userDetails?.email!.replaceAll("@gmail.com", ""),
        "name": userDetails?.displayName,
        "imgUrl": userDetails?.photoURL
      };

      DatabaseMethods()
          .addUserInfoToDB(userDetails!.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      });
    }
  }


  

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
}
