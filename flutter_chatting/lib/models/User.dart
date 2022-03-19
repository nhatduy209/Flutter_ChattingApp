import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String idChatting;
  String avatar =
      "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg";
  bool isOnline = false;

  User(
      {required this.username,
      isOnline = false,
      avatar,
      required this.idChatting});
}
