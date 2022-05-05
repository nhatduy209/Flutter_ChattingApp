import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:flutter_chatting/screen/User_online.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/firebase.dart';

class FriendProfileScreen extends StatefulWidget {
  @override
  bool isAdded;

  @override
  String userName;

  FriendProfileScreen({required bool isAdded, required String userName})
  : this.userName = userName, this.isAdded = isAdded;

  @override
  State<FriendProfileScreen> createState() => FriendProfileState();
}

class FriendProfileState extends State<FriendProfileScreen> {
  User userProfile = User(id: '', userName: '', email: '', age: '', phoneNumber: '', listFriend: [], url: '', token: '');
  bool checkFriend(BuildContext context) {
    List<User> listFriends = Provider.of<UserProfile>(context).userProfile.listFriend;
    return listFriends.where((element) => element.userName == widget.userName).isNotEmpty;
  }

  Future<dynamic> getListMessage(
      {BuildContext? context}) async {
    // Get data from docs and convert map to List
    List<User> listFriends = Provider.of<UserProfile>(context!).userProfile.listFriend;
    var accounts = FirebaseFirestore.instance.collection('account');
    accounts.get().then(
        (QuerySnapshot querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            if (doc.data()['username'] == widget.userName) {
              setState(() {
                userProfile = User(
                  id: doc.id,
                  userName: doc.data()['username'],
                  email: doc.data()['email'],
                  age: doc.data()['age'],
                  phoneNumber: doc.data()['phoneNumber'],
                  listFriend: [],
                  url: doc.data()['url'],
                  token: '');
              });
              // print(User(
              //     id: doc.id,
              //     userName: doc.data()['username'],
              //     email: doc.data()['email'],
              //     age: doc.data()['age'],
              //     phoneNumber: doc.data()['phoneNumber'],
              //     listFriend: [],
              //     url: doc.data()['url']));
            }
          }
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getListMessage(context: context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // TODO: implement build
    return Scaffold(
        body: Container(
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: Image.asset('assets/images/profile-background.png')
                ),
                Column(children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                      child: TextButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Icon(Icons.arrow_back,
                            color: Colors.black38, size: 24.0),
                      )),
                  Stack(
                      children: [
                        ClipRRect(
                            child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(200, 124, 77, 255),
                              borderRadius: BorderRadius.circular(180)),
                          width: 200.0,
                          height: 200.0,
                        )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Container(
                                width: 240.0,
                                height: 240.0,
                                color: Color.fromARGB(100, 124, 77, 255))),
                        Container(
                            child: Container(
                          margin: const EdgeInsets.all(40),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              // userProfile.url != null ? userProfile.url.toString() :
                              'https://img.freepik.com/free-vector/call-center-concept-with-woman_23-2147939060.jpg?t=st=1651334914~exp=1651335514~hmac=ab8b01b29bfdb4432294983ff7202b6921371e9ba8cce2bc7014ce4cf5b9c77e&w=826',
                              height: 160.0,
                              width: 160.0,
                            ),
                          ),
                        )),
                        // Container(
                        //   margin: const EdgeInsets.only(top: 44, left: 44),
                        //   width: 40.0,
                        //   height: 40.0,
                        //   // color: Color.fromARGB(232, 10, 243, 49),
                        //   decoration: const BoxDecoration(
                        //       color: Color.fromARGB(232, 10, 243, 49),
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(40))),
                        //   child: Icon(Icons.check, size: 35),
                        // )
                      ],
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    child: const Divider(
                      height: 6,
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Colors.black12,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: Text(
                      userProfile.userName == null ? '--' : userProfile.userName.toString(),
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      userProfile.userName == null ? '--' : userProfile.userName.toString(),
                      style: TextStyle(fontSize: 24, color: Colors.black12),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      userProfile.email == null ? '--' : userProfile.email.toString(),
                      style: TextStyle(fontSize: 24, color: Colors.black12),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      userProfile.phoneNumber == null ? '--' : userProfile.phoneNumber.toString(),
                      style: TextStyle(fontSize: 24, color: Colors.black12),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 60),
                    child: const Divider(
                      height: 6,
                      thickness: 1,
                      indent: 60,
                      endIndent: 60,
                      color: Colors.black12,
                    ),
                  ),
                  Column(
                    children: [
                      checkFriend(context) ? 
                      Container(
                      // margin: const EdgeInsets.only(top: 120.0),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 224, 221, 224), // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        onPressed: () {
                          setState(() {
                          // widget.isAdded= !widget.isAdded;
                        });
                        },
                        child: Text(
                          checkFriend(context) ? 'Unfriend' : 'Cancel invitation',
                          style: TextStyle(fontSize: 20, color: Colors.black54),),
                      )) :
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 124, 77, 255), // background
                              onPrimary: Colors.white, // foreground
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {
                              setState(() {
                          // widget.isAdded= !widget.isAdded;
                        });
                            },
                            child: Text(
                              'Add friend',
                              style: TextStyle(fontSize: 20),
                            ),
                          )),
                    ],
                  )
                ]),
              ],
            ))
        )
        );
      }
    );
  }
}
