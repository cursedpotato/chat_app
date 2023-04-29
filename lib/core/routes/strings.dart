import 'package:firebase_auth/firebase_auth.dart';

String? email = FirebaseAuth.instance.currentUser?.email;
String? chatterUsername = email!.substring(0, email?.indexOf('@'));
String? profilePicUrl = FirebaseAuth.instance.currentUser?.photoURL;
const String noImage =
    'https://secure.gravatar.com/avatar/ef9463e636b415ee041791a6a3764104?s=250&d=mm&r=g';
