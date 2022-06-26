
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import 'package:google_sign_in/google_sign_in.dart';

// import 'package:shared_preferences/shared_preferences.dart';


// class AuthMethods {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   getCurrentUser() async {
//     return auth.currentUser;
//   }

//   Future<String> signUpUser({
//     required String email,
//     required String password,
//     required String username,
//     required String bio,
//     required Uint8List file,
//     bool isLoading = false,
//     // required Uint8List file,
//   }) async {
//     String res = "Some error ocurred";
//     try {
//       if (email.isNotEmpty ||
//           password.isNotEmpty ||
//           username.isNotEmpty ||
//           bio.isNotEmpty ||
//           file != null) {
//         // Register user
//         UserCredential credential = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);

           

//         String photoUrl = await StorageMethods()
//             .uploadImageToStorage('profilePics', file, false);
//         UserModel user = UserModel(
//           username: username,
//           uid: credential.user!.uid,
//           email: email,
//           bio: bio,
//           photoUrl: photoUrl,
//           followers: [],
//           following: [],
//         );
//         // Add user to our database
//         _firestore.collection("users").doc(credential.user!.uid).set(user.toJson());
//         //
//         res = "success";
//       } else {}
//     } catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }

//   Future<UserCredential> signInWithGoogle(BuildContext context) async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;

//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }

//   Future signOut() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//     await auth.signOut();
//   }
// }
