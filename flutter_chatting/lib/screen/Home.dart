import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:flutter_chatting/main.dart';
import 'package:flutter_chatting/models/ListBubbeMessageModel.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MessageModel.dart';
import '../models/BubleMessageModel.dart';
import 'chatting/Chating.dart';
import 'settings/Settings.dart';

class HomeRouteState extends StatefulWidget {
  HomeRouteState({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => HomeRoute();
}

class HomeRoute extends State<HomeRouteState> {
  var userChatting = FirebaseFirestore.instance.collection('message');
  String getUsername = "";
  int selectedTab = 0;
  HomeRoute();
  var commonFunc = Utilities();
  Future<dynamic> getLisUsers(ListUserModel listUsers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getUsername = prefs.getString('username');

    // Get data from docs and convert map to List
    if (listUsers.totalUser == 0) {
      await userChatting.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc.id.contains(getUsername)) {
            String newUserChatting = commonFunc.getUserChatting(
                idChatting: doc.id, username: getUsername);
            listUsers.add(
                BubbleMessage(username: newUserChatting, idChatting: doc.id));
          }
        }
      });
    }
  }

  Future logout(String username) async {
    QuerySnapshot accounts = await FirebaseFirestore.instance
        .collection('account')
        .where('username', isEqualTo: username)
        .get();

    accounts.docs[0].reference.update({'isOnline': false});

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: '',
              )),
    );
  }

  // get selected tab
  void onChangeSelectedTab(index) async {
    setState(() => selectedTab = index);
  }

  void removeUser(BubbleMessage user, ListUserModel listUsers) {
    listUsers.removeUser(user);
  }

  @override
  Widget build(BuildContext context) {
    var listUsers = Provider.of<ListUserModel>(context);
    return FutureBuilder<dynamic>(
        future: getLisUsers(listUsers),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.black,
                currentIndex: selectedTab,
                onTap: onChangeSelectedTab,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_add),
                    label: 'Find friends',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
              backgroundColor: Colors.deepPurple[100],
              body: selectedTab == 0
                  ? Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 33.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                    icon: const Icon(Icons.logout, size: 30.0),
                                    onPressed: () => logout(getUsername)),
                                const Text(
                                  'Chatty',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        size: 30.0),
                                    onPressed: () => {}),
                              ])),
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
                                margin: const EdgeInsets.only(top: 100.0),
                                child: ListView.builder(
                                  itemCount: listUsers.getListUsers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TextButton(
                                        onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Chatting(
                                                        listMessages: const [],
                                                        id: listUsers
                                                            .getListUsers[index]
                                                            .idChatting,
                                                        userChatting: listUsers
                                                            .getListUsers[index]
                                                            .username,
                                                      )),
                                            ),
                                        onLongPress: () => removeUser(
                                            listUsers.getListUsers[index],
                                            listUsers),
                                        child: UserOnline(
                                          username: listUsers
                                              .getListUsers[index].username,
                                          avatar:
                                              "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg",
                                          isOnline: false,
                                          latestMessage: listUsers
                                              .getListUsers[index]
                                              .latestMessage,
                                          latestMessageTime: listUsers
                                              .getListUsers[index]
                                              .latestMessageTime,
                                        ));
                                  },
                                )),
                          )
                        ],
                      )
                    ])
                  : selectedTab == 1
                      ? Container()
                      : const SettingsApp());
        });
  }
}
