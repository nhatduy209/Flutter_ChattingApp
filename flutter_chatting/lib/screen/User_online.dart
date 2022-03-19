import 'package:flutter/material.dart';

class UserOnline extends StatefulWidget {
  @override
  final bool isOnline;

  @override
  final String
      username; // <--- generates the error, "Field doesn't override an inherited getter or setter"

  @override
  final String avatar;

  UserOnline(
      {required String username, bool isOnline = false, required String avatar})
      : this.username = username,
        this.isOnline = isOnline,
        this.avatar = avatar;

  @override
  UserOnlineState createState() =>
      new UserOnlineState(username, isOnline, avatar);
}

class UserOnlineState extends State<UserOnline> {
  UserOnlineState(this.username, this.isOnline, this.avatar);
  final String username;
  bool isOnline = false;
  String avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                this.avatar,
                height: 65.0,
                width: 65.0,
              ),
            ),
            Column(
              children: [
                Text(this.username, textAlign: TextAlign.start),
                Text(
                  "Latest message render here.....",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child:
                    Container(width: 10.0, height: 10.0, color: Colors.green)),
          ],
        ));
  }
}
