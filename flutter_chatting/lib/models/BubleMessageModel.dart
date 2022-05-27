import 'package:cloud_firestore/cloud_firestore.dart';

class BubbleMessage {
  String username;
  String idChatting;
  String avatar = "";
  bool isOnline = false;
  String latestMessage = "";
  String latestMessageTime = "";

  BubbleMessage(
      {required this.username,
      isOnline = false,
      required this.avatar,
      required this.idChatting,
      latestMessage,
      latestMessageTime});
}
