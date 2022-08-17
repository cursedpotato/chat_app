import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const khighlightColor = Color(0xFF087949);
const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

String? email = FirebaseAuth.instance.currentUser?.email;
<<<<<<< HEAD
String? chatterUsername = email!.substring(0, email?.indexOf('@'));
=======
String chatterUsername = email!.substring(0, email!.indexOf('@'));
>>>>>>> 854697bfc246f0c6e8eb179171e1a48a6b8860e0
