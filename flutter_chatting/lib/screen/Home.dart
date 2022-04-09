import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/main.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Message.dart';
import '../models/User.dart';
import 'Chating.dart';
import 'settings/Settings.dart';

class HomeRouteState extends StatefulWidget {
  HomeRouteState({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => HomeRoute();
}

class HomeRoute extends State<HomeRouteState> {
  var userChatting = FirebaseFirestore.instance.collection('message');
  late List<User> listUsers = [];
  String getUsername = "";
  int selectedTab = 0;
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
    getUsername = prefs.getString('username');

    // Get data from docs and convert map to List
    if (listUsers.isEmpty) {
      await userChatting.get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (doc.id.contains(getUsername)) {
            String newUserChatting =
                getUserChatting(idChatting: doc.id, username: getUsername);
            listUsers.add(User(username: newUserChatting, idChatting: doc.id));
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: getLisUsers(),
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
                                child: ListView(
                                  children: [
                                    ...listUsers.map(
                                      (e) => TextButton(
                                          onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chatting(
                                                          listMessages: const [],
                                                          id: e.idChatting,
                                                          userChatting:
                                                              e.username,
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
                    ])
                  : selectedTab == 1
                      ? Container()
                      : const SettingsApp());
        });
  }
}
