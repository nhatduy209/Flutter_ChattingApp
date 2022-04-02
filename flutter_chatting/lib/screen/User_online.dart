import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  late StreamSubscription<QuerySnapshot> listeningMessageChange;
  final String username;
  bool isOnline = false;
  String avatar;

  Future checkUserOnline() async {
    var data = await FirebaseFirestore.instance
        .collection('account')
        .where('username', isEqualTo: username)
        .get();

    var isUserOnline = data.docs.firstWhere((element) {
      if (element['isOnline'] == true) {
        if (isOnline == false) {
          setState(() => {isOnline = true});
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
        .where('username', isEqualTo: username);
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
          if (key == 'isOnline' && isOnline != value) {
            setState(() => {isOnline = value});
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkUserOnline();
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
                child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: isOnline == true ? Colors.green : Colors.grey)),
          ],
        ));
  }
}
