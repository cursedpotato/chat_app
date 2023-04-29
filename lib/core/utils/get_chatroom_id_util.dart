getChatRoomIdByUsernames(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    // ignore: unnecessary_string_escapes
    return "$b\_$a";
  } else {
    // ignore: unnecessary_string_escapes
    return "$a\_$b";
  }
}
