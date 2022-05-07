// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter_chatting/common/API.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/models/MessageModel.dart';
import 'package:flutter_chatting/widget/RenderMessage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
      {Key? key,
      required List<Message> listMessages,
      bool isRead = false,
      required id,
      username,
      required userChatting})
      : this.listMessages = listMessages,
        this.isRead = isRead,
        this.id = id,
        this.userChatting = userChatting,
        super(key: key);

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
  late String tokenDevice;
  resetMessage() {
    message.text = '';
  }

  CollectionReference messages =
      FirebaseFirestore.instance.collection('message');

  CollectionReference account =
      FirebaseFirestore.instance.collection('account');

  Future sendMessage(message, idChatting) async {
    print('GET TOKEN ----' + idChatting);
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

      await pushNotification(tokenDevice, username, message);

      resetMessage();
    } else {
      var listImageUrl = await uploadImageToFirebase(listImage);
      listImageUrl.forEach((element) async {
        if (listImageUrl.isNotEmpty) {
          messages.doc(idChatting).collection('listmessage').add({
            'message': element,
            'Time': DateTime.now(),
            'id': '$idMess-$username'
          });

          await pushNotification(
            tokenDevice,
            username,
            message,
          );
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
      setState(() => {listImage.clear()});
    }
  }

  Future<dynamic> getListMessage(
      {idChatting = String, BuildContext? context}) async {
    // Get data from docs and convert map to List
    var listUsers = Provider.of<ListUserModel>(context!);
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
      listUsers.changeLatestMessage(userChatting, listMessages[0].content,
          listMessages[0].time.toString()); // get latest message
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
    account.get().then((QuerySnapshot querySnapshot) {
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      var exist =
          allData.where((item) => item['username'] == userChatting).first;
      var user = User.fromJson(exist);
      tokenDevice = user.token;
    });

    var data = FirebaseFirestore.instance
        .collection('message')
        .doc(id)
        .collection('listmessage');

    listeningMessageChange =
        data.snapshots().listen((snapshot) => _onEventsSnapshot(snapshot));
    super.initState();
  }

// handle when partner sending message, ListUserModel listUsers
  void _onEventsSnapshot(QuerySnapshot snapshot) {
    if (isInitListMessage == false) {
      // update latest message

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
            setState(() => {listMessages.insert(0, messageInstance)});
            // listUsers.changeLatestMessage(userChatting, messageInstance.content,
            //     messageInstance.time.toString());
          }
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getListMessage(idChatting: id, context: context),
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
                                      enabled: listImage.isEmpty,
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
