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

// Firebase related user vars
String? email = FirebaseAuth.instance.currentUser?.email;
String? chatterUsername = email!.substring(0, email?.indexOf('@'));
String? profilePicUrl = FirebaseAuth.instance.currentUser?.photoURL;
const String noImage =
        'https://secure.gravatar.com/avatar/ef9463e636b415ee041791a6a3764104?s=250&d=mm&r=g';

getChatRoomIdByUsernames(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    // ignore: unnecessary_string_escapes
    return "$b\_$a";
  } else {
    // ignore: unnecessary_string_escapes
    return "$a\_$b";
  }
}
