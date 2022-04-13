import 'package:cloud_firestore/cloud_firestore.dart';

class BubbleMessage {
  String username;
  String idChatting;
  String avatar =
      "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg";
  bool isOnline = false;
  String latestMessage = "";
  String latestMessageTime = "";

  BubbleMessage(
      {required this.username,
      isOnline = false,
      avatar,
      required this.idChatting,
      latestMessage,
      latestMessageTime});
}
