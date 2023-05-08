import '../routes/strings.dart';

getChatRoomIdByUsernames(String b) {
  if (chatterUsername!.substring(0, 1).codeUnitAt(0) >
      b.substring(0, 1).codeUnitAt(0)) {
    return "${b}_$chatterUsername";
  } else {
    return "${chatterUsername}_$b";
  }
}
