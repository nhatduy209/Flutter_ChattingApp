import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/ListGroupChat.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ModalAddGroupChat extends StatelessWidget {
  //const ModalAddGroupChat({Key? key}) : super(key: key);

  CollectionReference messages =
      FirebaseFirestore.instance.collection('message');

  Future<void> handleAddGroupChat(List<Map<String, bool>> getListCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var currentUser = prefs.getString('username');

    List<String> groupName = [currentUser];
    for (var index = 0; index < getListCheck.length; index++) {
      getListCheck[index].keys.forEach((element) {
        if (getListCheck[index][element] == true) {
          groupName.add(element);
        }
      });
    }
    var genID = new Uuid();
    var idMess = genID.v1();

    String groupChat = groupName.join('_');
    print('GROUP CHAT CREATE ----' + groupChat);
    messages.doc(groupChat).set({
      'name': 'Group created by ${currentUser}',
    });
    messages.doc(groupChat).collection('listmessage').add({
      'message': 'Group created by ${currentUser}',
      'Time': DateTime.now(),
      'id': '$idMess-${currentUser}'
    });
  }

  @override
  Widget build(BuildContext context) {
    var listCheckBox = Provider.of<ListGroupChat>(context);
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
                  onPressed: () {
                    handleAddGroupChat(listCheckBox.getListCheck);
                  },
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
  List<User> listFriends = [];
  //List<Map<String, bool>> listCheck = [];
  Future<void> getListFriends(
    ListGroupChat listCheckBoxs,
    List<User> listUsers,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var currentUser = prefs.getString('username');

    CollectionReference account =
        FirebaseFirestore.instance.collection('account');

    // account.get().then((QuerySnapshot querySnapshot) async {
    //   for (var doc in querySnapshot.docs) {
    //     User user = User.fromJson(doc.data());

    //     print('USER ---- ' + user.toString());

    //     if (currentUser == user.userName) {
    //       List<Map<String, bool>> listCheckBox = [];
    //       for (var element in user.listFriend) {
    //         listCheckBox.add({'${element.userName}': false});
    //       }
    //       setState(() => {
    //             listFriends = user.listFriend,
    //             listCheckBoxs.listCheck = listCheckBox
    //           });
    //     }
    //   }
    // });

    for (var element in listUsers) {
      List<Map<String, bool>> listCheckBox = [];
      for (var element in listUsers) {
        listCheckBox.add({'${element.userName}': false});
      }
      setState(() => {listCheckBoxs.listCheck = listCheckBox});
    }
  }

  @override
  Widget build(BuildContext context) {
    var listCheckBox = Provider.of<ListGroupChat>(context);
    List<User> listUsers =
        Provider.of<UserProfile>(context).userProfile.listFriend;
    if (listCheckBox.getListCheck.isEmpty) {
      getListFriends(listCheckBox, listUsers);
    }

    // listFriends.isEmpty
    //     ? getListFriends(listCheckBox)
    //     : print('LENGHT : ' + listFriends.length.toString());
    print('listUsers' + listUsers.length.toString());
    return listUsers.isNotEmpty
        ? ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 16, left: 12),
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(listUsers[index].url),
                        )),
                    Text(listUsers[index].userName,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Checkbox(
                      checkColor: Color.fromARGB(255, 18, 234, 129),
                      activeColor: Colors.white,
                      value: listCheckBox.getListCheck[index].values.first,
                      onChanged: (bool? value) {
                        listCheckBox.setCheckBox(value, index);
                      },
                    )
                  ],
                ),
              );
            })
        : const Center(
            child: Text('You don`t have any friends, find your friends now'));
  }
}
