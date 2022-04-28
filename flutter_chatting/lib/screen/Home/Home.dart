import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:flutter_chatting/main.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/screen/Home/HomeEvent.dart';
import 'package:flutter_chatting/screen/Home/widget/BubbleMessageSlide.dart';
import 'package:flutter_chatting/screen/Home/widget/SearchText.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:flutter_chatting/screen/friends/Friends.dart';
import 'package:flutter_chatting/widget/RenderOnlineUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/MessageModel.dart';
import '../../models/BubleMessageModel.dart';
import '../chatting/Chating.dart';
import '../settings/Settings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeRouteState extends StatefulWidget {
  HomeRouteState({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => HomeRoute();
}

class HomeRoute extends State<HomeRouteState> {
  var userChatting = FirebaseFirestore.instance.collection('message');
  String getUsername = "";
  bool isSearch = false;
  int selectedTab = 0;
  List<bool> listUserOnline = [true, true, true, false, false, true, false, false];

  HomeRoute();
  var commonFunc = Utilities();

  void onChangeSelectedTab(index) async {
    setState(() => selectedTab = index);
  }

  void removeUser(BubbleMessage user, ListUserModel listUsers) {
    listUsers.removeUser(user);
  }

  @override
  Widget build(BuildContext context) {
    var listUsers = Provider.of<ListUserModel>(context);
    double marginSearch = isSearch == true ? 150.0 : 100.0;
    return FutureBuilder<dynamic>(
        future: listUsers.getAllUsers(isSearch),
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
              // backgroundColor: Colors.deepPurpleAccent,
              body: selectedTab == 0
                  ? Stack(children: <Widget>[
                      Container(
                        height: 60,
                          margin: const EdgeInsets.only(top: 28.0),
                          padding: const EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.only(
                            //           bottomLeft: Radius.circular(40),
                            //           bottomRight: Radius.circular(40)
                            //           ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                        icon: const Icon(Icons.logout,
                                            size: 30.0),
                                        onPressed: () => logout(
                                            getUsername, listUsers, context)),
                                    const Text(
                                      'Chatty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    IconButton(
                                        icon: isSearch == false
                                            ? const Icon(Icons.search,
                                                size: 30.0)
                                            : const Icon(Icons.close,
                                                size: 30.0),
                                        onPressed: () => {
                                              setState(
                                                  () => {isSearch = !isSearch}),
                                            }),
                                  ]),
                              isSearch == true ? SearchText() : Container(),
                            ],
                          )),
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(top: marginSearch),
                                child: ListView.builder(
                                  itemCount: listUserOnline.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return index == 0
                                        ? Stack(
                                          children: [Container(
                                            margin: EdgeInsets.all(6),
                                            width: 60.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                              borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(60))),
                                          child: const Icon(
                                            Icons.person_add,
                                            size: 25,
                                            color: Colors.black12,
                                          ),
                                          )]
                                        )
                                        : RenderOnlineUser(
                                            isOnline: listUserOnline[index],
                                          );
                                  },
                                  scrollDirection: Axis.horizontal,
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(top: marginSearch + 80),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                  color: Colors.white,
                                ),
                                child: ListView.builder(
                                  itemCount: listUsers.getListUsers.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SlideBar(
                                      TextButton(
                                          onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chatting(
                                                          listMessages: const [],
                                                          id: listUsers
                                                              .getListUsers[
                                                                  index]
                                                              .idChatting,
                                                          userChatting:
                                                              listUsers
                                                                  .getListUsers[
                                                                      index]
                                                                  .username,
                                                        )),
                                              ),
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
                                          )),
                                      listUsers.getListUsers[index],
                                    );
                                  },
                                )),
                          )
                        ],
                      )
                    ])
                  : selectedTab == 1
                      ? const Friends()
                      : const SettingsApp());
        });
  }
}
