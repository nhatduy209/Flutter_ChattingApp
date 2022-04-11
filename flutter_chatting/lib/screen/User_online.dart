import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserOnline extends StatefulWidget {
  @override
  bool isOnline;

  @override
  final String
      username; // <--- generates the error, "Field doesn't override an inherited getter or setter"

  @override
  final String avatar;

  @override
  final String latestMessage;

  UserOnline(
      {required String username,
      required bool isOnline,
      required String avatar,
      required String latestMessage})
      : this.username = username,
        this.isOnline = isOnline,
        this.avatar = avatar,
        this.latestMessage = latestMessage;

  @override
  UserOnlineState createState() => UserOnlineState();
}

class UserOnlineState extends State<UserOnline> {
  // UserOnlineState(this.username, this.isOnline, this.avatar);
  late StreamSubscription<QuerySnapshot> listeningMessageChange;
  // final String username;
  // bool isOnline = false;
  // String avatar;

  Future checkUserOnline() async {
    var data = await FirebaseFirestore.instance
        .collection('account')
        .where('username', isEqualTo: widget.username)
        .get();

    var isUserOnline = data.docs.firstWhere((element) {
      if (element['isOnline'] == true) {
        if (widget.isOnline == false) {
          setState(() => {widget.isOnline = true});
        }
      }
      return true;
    });
  }

  @override
  void initState() {
    checkUserOnline();
    var data = FirebaseFirestore.instance
        .collection('account')
        .where('username', isEqualTo: widget.username);
    listeningMessageChange =
        data.snapshots().listen((snapshot) => _onEventsSnapshot(snapshot));
    super.initState();
  }

  void _onEventsSnapshot(QuerySnapshot snapshot) {
    snapshot.docChanges?.forEach(
      (docChange) {
        print("On change ${docChange}");
        // If you need to do something for each document change, do it here.
        docChange.doc.data().forEach((key, value) {
          if (key == 'isOnline' && widget.isOnline != value) {
            setState(() => {widget.isOnline = value});
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkUserOnline();
    print("HELLO ---  ${widget.username}");
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                widget.avatar,
                height: 65.0,
                width: 65.0,
              ),
            ),
            Column(
              children: [
                Text(widget.username, textAlign: TextAlign.start),
                Text(
                  widget.latestMessage.isNotEmpty ? widget.latestMessage : "",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                    width: 10.0,
                    height: 10.0,
                    color:
                        widget.isOnline == true ? Colors.green : Colors.grey)),
          ],
        ));
  }
}
