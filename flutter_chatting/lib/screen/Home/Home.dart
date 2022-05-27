import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/assets/component/Flushbar.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:flutter_chatting/main.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:flutter_chatting/screen/Home/HomeEvent.dart';
import 'package:flutter_chatting/screen/Home/widget/BubbleMessageSlide.dart';
import 'package:flutter_chatting/screen/Home/widget/ModalAddGroupChat.dart';
import 'package:flutter_chatting/screen/Home/widget/ModalCreatePost.dart';
import 'package:flutter_chatting/screen/Home/widget/SearchText.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:flutter_chatting/screen/friends/AddFriend.dart';
import 'package:flutter_chatting/screen/friends/Friends.dart';
import 'package:flutter_chatting/screen/news-feed/NewsFeed.dart';
import 'package:flutter_chatting/widget/RenderOnlineUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/MessageModel.dart';
import '../../models/BubleMessageModel.dart';
import '../../models/UserModel.dart';
import '../../models/UserProfileProvider.dart';
import '../chatting/Chating.dart';
import '../notification/Notifications.dart';
import '../settings/Settings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    List<User> listUserOnline = [
      User(
          id: '',
          userName: '',
          email: '',
          age: '',
          phoneNumber: '',
          listFriend: [],
          url: '',
          token: '')
    ];
    List<User> listFriends =
        Provider.of<UserProfile>(context).userProfile.listFriend;
    listUserOnline.addAll(listFriends);
    double marginSearch = isSearch == true ? 150.0 : 100.0;
    ListPostProvider listPostProvider = Provider.of<ListPostProvider>(context);

    return FutureBuilder<dynamic>(
        future: listUsers.getAllUsers(isSearch),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              floatingActionButton: SpeedDial(
                icon: Icons.add,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                      child: const Icon(Icons.person_add_alt),
                      backgroundColor: Colors.deepPurple[100],
                      onTap: () => {
                            showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return ModalAddGroupChat();
                              },
                            )
                          }),
                  SpeedDialChild(
                    child: const Icon(Icons.feed),
                    backgroundColor: Colors.blue,
                    onTap: () => {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const ModalCreatePost();
                        },
                      )
                    },
                  ),
                ],
              ),
              bottomNavigationBar: Stack(
                children: [
                  // Container(
                  //   height: 70,
                  //   color: Colors.blueGrey[200],
                  //   margin: EdgeInsets.only(top: 10),
                  // ),
                  Container(
                    // margin: EdgeInsets.only(top: 24),
                    child: BottomNavigationBar(
                      selectedFontSize: 0,
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black26,
                      elevation: 0,
                      currentIndex: selectedTab,
                      onTap: onChangeSelectedTab,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          backgroundColor: Colors.blueGrey[50],
                          icon: selectedTab == 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 6, left: 4, right: 4),
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(199, 165, 137, 241),
                                      borderRadius: BorderRadius.circular(180)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.description,
                                          size: 16,
                                        ),
                                        Text('New Posts',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                )
                              : Container(child: Icon(Icons.description)),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: Colors.blueGrey[50],
                          icon: selectedTab == 1
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 6, left: 4, right: 4),
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(199, 165, 137, 241),
                                      borderRadius: BorderRadius.circular(180)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.message,
                                          size: 16,
                                        ),
                                        Text('Messages',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                )
                              : Container(child: Icon(Icons.message)),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: Colors.blueGrey[50],
                          icon: selectedTab == 2
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 6, left: 4, right: 4),
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(198, 100, 206, 238),
                                      borderRadius: BorderRadius.circular(180)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.person_add,
                                          size: 16,
                                        ),
                                        Text('Friends',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                )
                              : Container(child: Icon(Icons.person_add)),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: Colors.blueGrey[50],
                          icon: selectedTab == 3
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 6, left: 4, right: 4),
                                  margin: EdgeInsets.only(left: 2, right: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(198, 100, 206, 238),
                                      borderRadius: BorderRadius.circular(180)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.notifications,
                                          size: 16,
                                        ),
                                        Text(
                                          'Notifications',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ]),
                                )
                              : Container(child: Icon(Icons.notifications)),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          backgroundColor: Colors.blueGrey[50],
                          icon: selectedTab == 4
                              ? Container(
                                  padding: EdgeInsets.only(
                                      top: 6, bottom: 6, left: 4, right: 4),
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(198, 100, 206, 238),
                                      borderRadius: BorderRadius.circular(180)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(
                                          Icons.settings,
                                          size: 16,
                                        ),
                                        Text('Settings',
                                            style: TextStyle(fontSize: 12))
                                      ]),
                                )
                              : Container(child: Icon(Icons.settings)),
                          label: '',
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // backgroundColor: Colors.deepPurpleAccent,
              body: selectedTab == 0
                  ? const NewsFeed()
                  : selectedTab == 1
                      ? Stack(children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(top: 28.0),
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
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
                                                getUsername,
                                                listUsers,
                                                listPostProvider,
                                                context)),
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
                                                  setState(() =>
                                                      {isSearch = !isSearch}),
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
                                    padding: const EdgeInsets.only(top: 6),
                                    color: Colors.black12,
                                    child: listUserOnline.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: listUserOnline.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return index == 0
                                                  ? Stack(children: [
                                                      GestureDetector(
                                                          onTap: () => {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AddFriends()),
                                                                )
                                                              },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    6),
                                                            width: 60.0,
                                                            height: 60.0,
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(60))),
                                                            child: const Icon(
                                                              Icons.person_add,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ))
                                                    ])
                                                  : RenderOnlineUser(
                                                      user:
                                                          listUserOnline[index],
                                                    );
                                            },
                                            scrollDirection: Axis.horizontal,
                                          )
                                        : Container()),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: marginSearch + 80),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40)),
                                      color: Colors.white,
                                    ),
                                    child: listUsers.getListUsers.isNotEmpty
                                        ? ListView.builder(
                                            itemCount:
                                                listUsers.getListUsers.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return SlideBar(
                                                TextButton(
                                                    onPressed:
                                                        () => Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Chatting(
                                                                            listMessages: const [],
                                                                            id: listUsers.getListUsers[index].idChatting,
                                                                            userChatting:
                                                                                listUsers.getListUsers[index].username,
                                                                          )),
                                                            ),
                                                    child: UserOnline(
                                                      username: listUsers
                                                          .getListUsers[index]
                                                          .username,
                                                      avatar:
                                                          "https://thumbs.dreamstime.com/b/male-avatar-icon-flat-style-male-user-icon-cartoon-man-avatar-hipster-vector-stock-91462914.jpg",
                                                      isOnline: false,
                                                      latestMessage: listUsers
                                                          .getListUsers[index]
                                                          .latestMessage,
                                                      latestMessageTime:
                                                          listUsers
                                                              .getListUsers[
                                                                  index]
                                                              .latestMessageTime,
                                                    )),
                                                listUsers.getListUsers[index],
                                              );
                                            },
                                          )
                                        : Container()),
                              ),
                            ],
                          )
                        ])
                      : selectedTab == 2
                          ? const Friends()
                          : selectedTab == 3
                              ? const NotificationScreen()
                              : const SettingsApp());
        });
  }
}
