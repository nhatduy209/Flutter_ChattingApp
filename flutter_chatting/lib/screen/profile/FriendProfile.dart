import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/firebase.dart';

class FriendProfileScreen extends StatefulWidget {
  FriendProfileScreen({Key? key}) : super(key: key);

  @override
  State<FriendProfileScreen> createState() => FriendProfileState();
}

class FriendProfileState extends State<FriendProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                  Container(
                    child: Stack(
                      children: [
                        ClipRRect(
                            child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 189, 0, 255),
                              borderRadius: BorderRadius.circular(180)),
                          width: 200.0,
                          height: 200.0,
                        )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Container(
                                width: 240.0,
                                height: 240.0,
                                color: Color.fromARGB(100, 189, 0, 255))),
                        Container(
                            child: Container(
                          margin: const EdgeInsets.all(40),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: Image.network(
                              'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740',
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60, bottom: 10),
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
                    child: const Text(
                      'Nhat Duy Tran',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'nhatduy209@gmail.com',
                      style: TextStyle(fontSize: 24, color: Colors.black12),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      '0999878887',
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
                      // Container(
                      // margin: const EdgeInsets.only(top: 120.0),
                      // width: MediaQuery.of(context).size.width * 0.6,
                      // height: 50,
                      // child: ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     primary: Color.fromARGB(255, 215, 144, 241), // background
                      //     onPrimary: Colors.white, // foreground
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(50)),
                      //   ),
                      //   onPressed: () {  },
                      //   child: Text('Unfriend', style: TextStyle(fontSize: 20, color: Colors.black54),),
                      // )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 158, 0, 216), // background
                              onPrimary: Colors.white, // foreground
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {},
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
}
