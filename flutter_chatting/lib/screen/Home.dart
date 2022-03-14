import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/screen/User_online.dart';

import '../models/Message.dart';
import 'Chating.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Stack(children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 33.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.reorder, size: 30.0),
                        onPressed: () => {}),
                    Text(
                      'Chatty',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    IconButton(
                        icon: Icon(Icons.camera_alt, size: 30.0),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    margin: const EdgeInsets.only(top: 200.0),
                    child: ListView(
                      children: [
                        TextButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Chatting(
                                            listMessages: [
                                              Message(
                                                  id: '1231d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: '12121d',
                                                  content: 'Admin nè'),
                                              Message(
                                                  id: 'nhatduy209_addadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: '121231d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: '1213131d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: 'nhatduy209_1addadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_a2ddadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add3adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add4adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_a2ddadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add3adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add4adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: '1231d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: '12121d',
                                                  content: 'Admin nè'),
                                              Message(
                                                  id: 'nhatduy209_addadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: '121231d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: '1213131d',
                                                  content: 'Hello'),
                                              Message(
                                                  id: 'nhatduy209_1addadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_a2ddadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add3adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add4adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_a2ddadadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add3adadwa',
                                                  content: 'Nhat Duy ne'),
                                              Message(
                                                  id: 'nhatduy209_add4adadwa',
                                                  content: 'Nhat Duy ne'),
                                            ],
                                          )),
                                ),
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                        TextButton(
                            onPressed: () => {},
                            child: UserOnline(
                                username: "nhatduy209",
                                avatar:
                                    "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg")),
                      ],
                    )),
              )
            ],
          )
        ]));
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
      child: Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white)),
    );
  }
}
