// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/Message.dart';

class Chatting extends StatefulWidget {
  @override
  final bool isRead;

  @override
  final List<Message>
      listMessages; // <--- generates the error, "Field doesn't override an inherited getter or setter"

  Chatting({required List<Message> listMessages, bool isRead = false})
      : this.listMessages = listMessages,
        this.isRead = isRead;

  @override
  ChattingState createState() => ChattingState(listMessages, isRead);
}

class ChattingState extends State<Chatting> {
  ChattingState(this.listMessages, this.isRead);
  final List<Message> listMessages;
  bool isRead = false;

  CollectionReference messages =
      FirebaseFirestore.instance.collection('message');

  Future<Null> getListMessage() {
    return messages.get().then((QuerySnapshot querySnapshot) {
      print('DOCS----');
      for (var doc in querySnapshot.docs) {
        print(' EACH DOCS----');
        print(doc.data());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getListMessage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partners'),
      ),
      body: Align(
          child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
              alignment: Alignment.bottomRight,
              height: 600.0,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 80.0),
                    height: 500.0,
                    child: ListView(children: [
                      ...listMessages.map((e) => e.id.contains("nhatduy209")
                          ? Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.indigo[50],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  e.content,
                                  textAlign: TextAlign.right,
                                ),
                              ))
                          : Container(
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(e.content,
                                      textAlign: TextAlign.left))))
                    ]),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Type somthing...',
                        ),
                      ),
                    ),
                    bottom: 0,
                  ),
                ],
              ))),
    );
  }
}
