import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:flutter_chatting/screen/friends/FrriendsEvent.dart';
import 'package:flutter_chatting/widget/RenderFriendItem.dart';
import 'package:provider/provider.dart';

import '../../models/ListBubbeMessageProvider.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  FriendsState createState() => FriendsState();
}

class FriendsState extends State<Friends> {
  List<User> listFiltedUsers = [];
  TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<User> listUsers = Provider.of<UserProfile>(context).userProfile.listFriend;
    if (username.text.isNotEmpty) {
      List<User> listFilted = [];
      for(var user in listUsers) {
        if(user.userName == username.text) {
          listFilted.add(user);
        }
      }
      setState(() {
        listFiltedUsers = listFilted;
      });
    } else {
      setState(() {
        listFiltedUsers = [];
      });
      listFiltedUsers.addAll(listUsers);
    }
    return Align(
        child: Column(
      children: [
        // Row(
        //   children: [
        //     Container(
        //               alignment: Alignment.bottomLeft,
        //               margin: const EdgeInsets.only(top: 32.0),
        //               child: TextButton(
        //                 onPressed: () => {Navigator.pop(context)},
        //                 child: const Icon(Icons.arrow_back,
        //                     color: Colors.black38, size: 24.0),
        //               )),
        //     // Container(
        //     //   margin: EdgeInsets.only(top: 32, left: MediaQuery.of(context).size.width * 0.2),
        //     //   alignment: Alignment.centerLeft,
        //     //   child: const Text('Friend', style: TextStyle(fontSize: 24),),
        //     // ),
        //   ],
        // ),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
              padding: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 241, 241),
                    borderRadius: BorderRadius.circular(24.0)),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: username,
                    // style: const TextStyle(
                    //   letterSpacing: 1.5,
                    // ),
                    decoration: const InputDecoration(
                        hintText: 'Find your friends...', border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(top: 28, right: 24),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.black26,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      List<User> listFilted = [];
                        for(var user in listUsers) {
                          if(user.userName == username.text) {
                            listFilted.add(user);
                          }
                        }
                        setState(() {
                          listFiltedUsers = listFilted;
                        });
                    },
                    child: const Icon(Icons.search),
                  ),
                )
          ],
        ),
        Expanded(
          child: Container(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                // ignore: unnecessary_null_comparison
                itemCount: listFiltedUsers.isEmpty ? 0 : listFiltedUsers.length,
                itemBuilder:
                    (BuildContext context, int index) {
                  return RenderFriendItem(
                        user: listFiltedUsers[index],
                        added: true,
                        );
                },
              )),
        ),
      ],
    ));
  }
}
