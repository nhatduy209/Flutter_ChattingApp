import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/screen/friends/FrriendsEvent.dart';
import 'package:flutter_chatting/widget/RenderFriendItem.dart';

import '../../widget/RenderNewFriendItem.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({Key? key}) : super(key: key);

  @override
  AddFriendsState createState() => AddFriendsState();
}

class AddFriendsState extends State<AddFriends> {
  TextEditingController username = TextEditingController();
  bool isSearch = false;
  List<User> listUsers = [];
  @override
  Widget build(BuildContext context) {
    var accounts = FirebaseFirestore.instance.collection('account');
    if(username.text.isNotEmpty & isSearch == true) {
      print(isSearch);
      print(username.text);
      List<User> listFilted = [];
      accounts.get().then(
        (QuerySnapshot querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            if (doc.data()['username'].toString().contains(username.text)) {
              listFilted.add(User(
                  id: doc.id,
                  userName: doc.data()['username'],
                  email: doc.data()['email'],
                  age: doc.data()['age'],
                  phoneNumber: doc.data()['phoneNumber'],
                  listFriend: [],
                  url: doc.data()['url'],
                  token: ''));
            }
          }
          print(listFilted);
          setState(() {
            listUsers = listFilted;
            isSearch = !isSearch;
          });
        }
      );
    } else if(username.text.isEmpty) {
      setState(() {
            listUsers = [];
          });
    }
    return Scaffold(
        body: Align(
        child: Column(
      children: [
        Row(
          children: [
            Container(
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(top: 32.0),
                      child: TextButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Icon(Icons.arrow_back,
                            color: Colors.black38, size: 24.0),
                      )),
            // Container(
            //   margin: EdgeInsets.only(top: 32, left: MediaQuery.of(context).size.width * 0.2),
            //   alignment: Alignment.centerLeft,
            //   child: const Text('New Friends', style: TextStyle(fontSize: 24),),
            // ),
          ],
        ),
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
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
                        hintText: 'Find new friends...', border: InputBorder.none),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(top: 12, right: 24),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.black26,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      setState(() {
                          isSearch = true;
                        });
                    },
                    child: const Icon(Icons.search),
                  ),
                )
          ],
        ),
        listUsers.isNotEmpty ?
        Expanded(
          child: Container(
              child: ListView.builder(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 3,
                // ),
                itemCount: listUsers.length,
                itemBuilder:
                    (BuildContext context, int index) {
                  return RenderNewFriendItem(
                    added: false,
                    user: listUsers[index],
                  );
                },
              )),
        ) : Container(
          child: Text('Type username to find'),
        ),
      ],
    ))
    );
  }
}
