// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/models/Message.dart';
import 'package:flutter_chatting/widget/RenderMessage.dart';
import 'package:image_picker/image_picker.dart';
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
  String id;
  String userChatting;
  String username = "";
  late List<Message> listMessages;
  bool isInitListMessage = true;
  final ScrollController _controller = ScrollController();
  bool isRead = false;
  List<File> listImage = <File>[];
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

    if (listImage.isEmpty) {
      messages.doc(idChatting).collection('listmessage').add({
        'message': message,
        'Time': DateTime.now(),
        'id': '$idMess-$username'
      });

      setState(() => {
            listMessages.insert(
                0,
                Message(
                    id: "idMess_$username",
                    content: message,
                    time: DateTime.now()))
          });
    } else {
      var listImageUrl = await uploadImageToFirebase(listImage);
      listImageUrl.forEach((element) {
        if (listImageUrl.isNotEmpty) {
          messages.doc(idChatting).collection('listmessage').add({
            'message': element,
            'Time': DateTime.now(),
            'id': '$idMess-$username'
          });
          setState(() => {
                listMessages.insert(
                    0,
                    Message(
                        id: "idMess_$username",
                        content: element,
                        time: DateTime.now()))
              });
        }
      });
      setState(() => {listImage: []});
    }
  }

  Future<dynamic> getListMessage({idChatting = String}) async {
    // Get data from docs and convert map to List

    var data = await FirebaseFirestore.instance
        .collection('message')
        .doc(idChatting)
        .collection('listmessage')
        .orderBy('Time', descending: true);

    if (listMessages.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var getUsername = prefs.getString('username');
      username = prefs.getString('username');

      await data.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          var messageInstance = new Message(id: "", content: "");
          doc.data().forEach((key, value) {
            if (key == 'message') {
              messageInstance.setContent = value;
            } else if (key == 'Time') {
              var timestamp = value as Timestamp;
              var dt =
                  DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000);
              messageInstance.setTime = dt;
            } else {
              messageInstance.setId = value;
            }
          });
          listMessages.add(messageInstance);
        }
      });
      isInitListMessage = false;
      //setState(() => {listMessages: listMessages.reversed});
    }
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        listImage.add(File(pickedFile.path));
      });
    }
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        listImage.add(File(pickedFile.path));
      });
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

// handle when partner sending message
  void _onEventsSnapshot(QuerySnapshot snapshot) {
    print('EVENT --- change $username');
    if (isInitListMessage == false) {
      snapshot.docChanges?.forEach(
        (docChange) {
          // If you need to do something for each document change, do it here.
          var messageInstance = new Message(id: "", content: "");
          docChange.doc.data().forEach((key, value) {
            if (key == 'message') {
              messageInstance.setContent = value;
            } else if (key == 'Time') {
              var timestamp = value as Timestamp;
              var dt =
                  DateTime.fromMillisecondsSinceEpoch(value.seconds * 1000);
              print("TIME $dt");
            } else {
              messageInstance.setId = value;
            }
          });
          if (messageInstance.id.contains(username) == false) {
            //listMessages.reversed.toList().add(messageInstance);
            setState(() => {listMessages.insert(0, messageInstance)});
          }
        },
      );
    }
  }

  Widget build(BuildContext context) {
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
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    alignment: Alignment.bottomRight,
                    child: Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 120.0),
                            height: 550.0,
                            child: ListView(
                              reverse: true,
                              shrinkWrap: true,
                              controller: _controller,
                              children: [
                                ...listMessages.map(
                                  (e) => e.id.contains(username)
                                      ? RenderMessage(
                                          message: e,
                                          renderOnTheLeft: true,
                                          listMessage:
                                              listMessages.reversed.toList(),
                                        )
                                      : RenderMessage(
                                          message: e,
                                          renderOnTheLeft: false,
                                          listMessage:
                                              listMessages.reversed.toList(),
                                        ),
                                ),
                              ],
                            )),
                        Positioned(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width - 120,
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
                                        size: 30.0),
                                    color: Colors.blue,
                                    onPressed: () => {
                                      sendMessage(message.text, id),
                                      _controller.animateTo(
                                        0.0,
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 500),
                                      )
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.collections,
                                        size: 30.0),
                                    color: Colors.blue,
                                    onPressed: () => {_getFromGallery()},
                                  ),
                                ]),
                                listImage.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 5.0),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            ...listImage.map((e) => Container(
                                                margin: const EdgeInsets.only(
                                                    right: 7),
                                                child: InkWell(
                                                  onTap: () => {
                                                    setState(() =>
                                                        {listImage.remove(e)})
                                                  },
                                                  child: Image.file(
                                                    e,
                                                  ),
                                                )))
                                          ],
                                        ))
                                    : Container()
                              ],
                            ),
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
