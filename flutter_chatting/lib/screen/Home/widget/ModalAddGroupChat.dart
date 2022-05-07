import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalAddGroupChat extends StatelessWidget {
  const ModalAddGroupChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin:
              const EdgeInsets.only(top: 50, bottom: 50, left: 25, right: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('New group chat'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Add'),
                ),
              ]),
              const SizedBox(height: 500, child: ListFriends())
            ],
          ),
        ));
  }
}

class ListFriends extends StatefulWidget {
  const ListFriends({Key? key}) : super(key: key);

  @override
  @override
  State<StatefulWidget> createState() => ListFriendsState();
}

class ListFriendsState extends State<ListFriends> {
  List<dynamic> listFriends = [];
  Future<void> getListFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var currentUser = prefs.getString('username');

    CollectionReference account =
        FirebaseFirestore.instance.collection('account');

    account.get().then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        User user = User.fromJson(doc.data());

        if (currentUser == user.userName) {
          setState(() => {listFriends = user.listFriends});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    listFriends.isEmpty
        ? getListFriends()
        : print('LENGHT : ' + listFriends.length.toString());

    return listFriends.isNotEmpty
        ? ListView.builder(
            itemCount: listFriends.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                // decoration: const BoxDecoration(
                //     border: Border(
                //   bottom: BorderSide(
                //     color: Colors.black,
                //     width: 0.5,
                //   ),
                // )),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 16, left: 12),
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/id/237/200/300'),
                        )),
                    Text(listFriends[index],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const CheckBox(),
                  ],
                ),
              );
            })
        : const Center(
            child: Text('You don`t have any friends, find your friends now'));
  }
}

class CheckBox extends StatefulWidget {
  const CheckBox({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  bool? isCheck = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Checkbox(
      checkColor: Color.fromARGB(255, 18, 234, 129),
      activeColor: Colors.white,
      value: isCheck,
      onChanged: (bool? value) {
        setState(() => {isCheck = value});
      },
    );
  }
}
