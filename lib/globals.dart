import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

extension CustomGetters on DocumentSnapshot {
  int getInt(key) {
    return data().toString().contains(key) ? get(key) : 0;
  }

  String getString(key) {
    return data().toString().contains(key) ? get(key) : '';
  }

  List getList(key) {
    return data().toString().contains(key) ? get(key) : [];
  } 

  Timestamp getTimeStamp(key) {
    return data().toString().contains(key) ? get(key) : Timestamp(0, 0);
  }

  DateTime getDateFromTs(key) {
    return data().toString().contains(key)
        ? (get(key) as Timestamp).toDate()
        : DateTime(0);
  }
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size _prevSize = Size.zero;
  @override
  void performLayout() {
    super.performLayout();
    Size newSize = child!.size;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}

class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget(
      {Key? key, required this.onChange, required Widget child})
      : super(key: key, child: child);
  final void Function(Size size) onChange;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      MeasureSizeRenderObject(onChange);
}
