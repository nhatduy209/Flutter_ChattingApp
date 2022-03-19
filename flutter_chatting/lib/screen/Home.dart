import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Message.dart';
import '../models/User.dart';
import 'Chating.dart';

class HomeRouteState extends StatefulWidget {
  HomeRouteState({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => HomeRoute();
}

class HomeRoute extends State<HomeRouteState> {
  var userChatting = FirebaseFirestore.instance.collection('message');
  late List<User> listUsers = [];

  HomeRoute();

  String getUserChatting({idChatting = String, username = String}) {
    if (idChatting.toString().indexOf(username) == 0) {
      return idChatting.toString().substring(username.toString().length + 1);
    } else {
      return idChatting.toString().substring(0, username.toString().length + 2);
    }
  }

  Future<dynamic> getLisUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getUsername = prefs.getString('username');

    // Get data from docs and convert map to List
    if (listUsers.isEmpty) {
      await userChatting.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          String newUserChatting =
              getUserChatting(idChatting: doc.id, username: getUsername);
          listUsers.add(User(username: newUserChatting, idChatting: doc.id));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getLisUsers(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              backgroundColor: Colors.deepPurple[100],
              body: Stack(children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 33.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.reorder, size: 30.0),
                              onPressed: () => {}),
                          const Text(
                            'Chatty',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          IconButton(
                              icon: const Icon(Icons.camera_alt, size: 30.0),
                              onPressed: () => {}),
                        ])),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                            top: 100.0,
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: ComponentButton(
                            text: 'Chats',
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 100.0),
                          child: ComponentButton(
                            text: 'Status',
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                            top: 100.0,
                            left: 30.0,
                            right: 30.0,
                          ),
                          child: ComponentButton(
                            text: 'Calls',
                          ))
                    ]),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.only(top: 200.0),
                          child: ListView(
                            children: [
                              ...listUsers.map(
                                (e) => TextButton(
                                    onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Chatting(
                                                    listMessages: const [],
                                                    id: e.idChatting,
                                                    userChatting: e.username,
                                                  )),
                                        ),
                                    child: UserOnline(
                                        username: e.username,
                                        avatar:
                                            "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                              ),
                            ],
                          )),
                    )
                  ],
                )
              ]));
        });
  }
}

class ComponentButton extends StatefulWidget {
  @override
  final bool isPress;

  @override
  final String
      text; // <--- generates the error, "Field doesn't override an inherited getter or setter"
  ComponentButton({required String text, bool isPress = false})
      : this.text = text,
        this.isPress = isPress;

  ComponentButtonState createState() => new ComponentButtonState(text, isPress);
}

class ComponentButtonState extends State<ComponentButton> {
  ComponentButtonState(this.text, this.isPress);
  final String text;
  bool isPress = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: (isPress
              ? MaterialStateProperty.all<Color>(Colors.greenAccent)
              : MaterialStateProperty.all<Color>(Colors.transparent))),
      onPressed: () {
        setState(() => isPress = true);
      },
      child: Text(text,
          style: const TextStyle(fontSize: 20.0, color: Colors.white)),
    );
  }
}
