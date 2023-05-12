import 'package:chat_app/features/home/models/chatroom_model.dart';

String chatroomImageUtil(ChatroomModel chatroomModel) {
  late String chatroomImage;
  // if its a group chat we return the chatroom image
  if (chatroomModel.usersInfo.length > 2) {
    chatroomImage = chatroomModel.chatroomImage;
  } else {
    // if its a one to one chat we return the chattee image
    chatroomImage = chatroomModel.usersInfo[0].profilePic;
  }

  return chatroomImage;
}
