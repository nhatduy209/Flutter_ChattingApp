// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Chatting extends StatefulWidget {
  @override
  final bool isRead;

  @override
  final String userChatting;

  @override
  String id;

  @override
  List<Message>
      listMessages; // <--- generates the error, "Field doesn't override an inherited getter or setter"

  Chatting(
      {required List<Message> listMessages,
      bool isRead = false,
      required id,
      username,
      required userChatting})
      : this.listMessages = listMessages,
        this.isRead = isRead,
        this.id = id,
        this.userChatting = userChatting;

  @override
  ChattingState createState() =>
      ChattingState(listMessages = [], isRead, id, userChatting);
}

class ChattingState extends State<Chatting> {
  late Iterable<Message> listMessagesState = [];
  String id;
  String userChatting;
  String username = "";
  late List<Message> listMessages;
  bool isInitListMessage = true;
  final ScrollController _controller = ScrollController();
  bool isRead = false;
  late StreamSubscription<QuerySnapshot> listeningMessageChange;
  ChattingState(this.listMessages, this.isRead, this.id, this.userChatting);
  final message = TextEditingController();

  CollectionReference messages =
      FirebaseFirestore.instance.collection('message');

  Future sendMessage(message, idChatting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');

    var genID = new Uuid();
    var idMess = genID.v1();
    messages.doc(idChatting).collection('listmessage').add({
      'message': message,
      'Time': DateTime.now(),
      'id': '$idMess-$username'
    });
  }

  Future<dynamic> getListMessage({idChatting = String}) async {
    // Get data from docs and convert map to List

    var data = await FirebaseFirestore.instance
        .collection('message')
        .doc(idChatting)
        .collection('listmessage')
        .orderBy('Time', descending: true);

    if (listMessages.isEmpty || listMessagesState.isEmpty) {
      print("LENGTH");
      print(listMessages.length);
      print(listMessagesState.length);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var getUsername = prefs.getString('username');
      username = prefs.getString('username');

      await data.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          var messageInstance = new Message(id: "", content: "");
          doc.data().forEach((key, value) => {
                if (key == 'message')
                  {messageInstance.setContent = value}
                else if (key == 'id')
                  {messageInstance.setId = value}
              });

          listMessages.insert(0, messageInstance);
        }
      });
      listMessagesState = listMessages.reversed;
      isInitListMessage = false;
    }
  }

  @override
  void initState() {
    var data = FirebaseFirestore.instance
        .collection('message')
        .doc(id)
        .collection('listmessage');
    listeningMessageChange =
        data.snapshots().listen((snapshot) => _onEventsSnapshot(snapshot));
    super.initState();
  }

  void _onEventsSnapshot(QuerySnapshot snapshot) {
    print('EVENT --- change $username');
    if (isInitListMessage == false) {
      snapshot.docChanges?.forEach(
        (docChange) {
          // If you need to do something for each document change, do it here.
          var messageInstance = new Message(id: "", content: "");
          docChange.doc.data().forEach((key, value) => {
                if (key == 'message')
                  {messageInstance.setContent = value}
                else if (key == 'id')
                  {messageInstance.setId = value},
              });
          if (messageInstance.id.contains(username) == false) {
            listMessages.add(messageInstance);
            setState(() => {listMessagesState: listMessages});
          }
        },
      );
    }
  }

  Widget build(BuildContext context) {
    print('USERNAME -- $username');
    return FutureBuilder<dynamic>(
      future: getListMessage(idChatting: id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(userChatting),
            ),
            body: Align(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 30.0),
                    alignment: Alignment.bottomRight,
                    height: 600.0,
                    child: Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 80.0),
                            height: 500.0,
                            child: ListView(
                              reverse: true,
                              shrinkWrap: true,
                              controller: _controller,
                              children: [
                                ...listMessagesState.map((e) => e.id
                                        .contains(username)
                                    ? Container(
                                        width: 200,
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 100),
                                        decoration: BoxDecoration(
                                          color: Colors.indigo[50],
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            e.content,
                                            textAlign: TextAlign.right,
                                          ),
                                        ))
                                    : Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 100),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(e.content,
                                                textAlign: TextAlign.left))))
                              ],
                            )),
                        Positioned(
                            child: Row(children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 60,
                                width: MediaQuery.of(context).size.width - 70,
                                child: TextFormField(
                                  controller: message,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Type somthing...',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_right,
                                    size: 40.0),
                                color: Colors.blue,
                                onPressed: () => {
                                  sendMessage(message.text, id),
                                  listMessages.add(Message(
                                      id: "idMess_$username",
                                      content: message.text)),
                                  setState(
                                    () => {listMessagesState: listMessages},
                                  ),
                                  _controller.animateTo(
                                    0.0,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 300),
                                  )
                                },
                              ),
                            ]),
                            bottom: 0),
                      ],
                    ))),
          );
        }
        // snapshot.data  :- get your object which is pass from your downloadData() function
      },
    );
  }
}