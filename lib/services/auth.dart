

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    // Creating a var for easily accesing the instance of a class
    final GoogleSignIn _googleSingIn = GoogleSignIn();
    //NOTE: Seems that this may need a try and and catch in the future
    // Accesing to a method of the class which returns a future 
    final GoogleSignInAccount? _googleSignInAccount = await _googleSingIn.signIn();
    //NOTE: It may throw null and the the type may have to refactored as such: GoogleSingInAuthentication?
    // Calling the api to give auth params  
    final GoogleSignInAuthentication googleSignInAuthentication = await _googleSignInAccount!.authentication;
    // Using those params to create a credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.idToken, 
      idToken: googleSignInAuthentication.accessToken
    );
    // Using that credential to sign in
    final UserCredential? result = await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result?.user;

    if (result == null) {
      debugPrint('This thing is null $result');     
    } else {
    }
  }
}
