import 'package:chat_app/services/database_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../core/routes/strings.dart';
import '../../../firebase_options.dart';

class AuthMethods {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> signInWithMail(String mail, String password) async {
    // Create a new user with the email and password provided.
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: mail, password: password);
    // Sign in the user using the email and password provided.
    firebaseAuth.signInWithEmailAndPassword(email: mail, password: password);

    // Retrieve the user details from the userCredential object.
    User? userDetails = userCredential.user;

    // Register the user's authentication details and return a boolean indicating success or failure.
    return registerAuth(userDetails);
  }

  Future<bool> signInWithGoogle() async {
    // Create a new GoogleSignIn object.
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    );

    // Attempt to sign in the user with their Google account.
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    // Retrieve the authentication details for the user.
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    // Create an AuthCredential object using the Google authentication details.
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    // Sign in the user using the AuthCredential object.
    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    // Retrieve the user details from the UserCredential object.
    User? userDetails = result.user;

    // Register the user's authentication details and return a boolean indicating success or failure.
    return registerAuth(userDetails);
  }

  Future<bool> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.cancelled) return false;

    if (loginResult.status == LoginStatus.failed) return false;

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final userCredential =
        await firebaseAuth.signInWithCredential(facebookAuthCredential);

    User? userDetails = userCredential.user;

    return registerAuth(userDetails);
  }

  static Future<bool> registerAuth(User? userDetails) async {
    if (userDetails == null) return false;
    final userMap = createUserInfoMap(userDetails);
    await DatabaseMethods().addUserInfoToDB(userDetails.uid, userMap);
    return true;
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
