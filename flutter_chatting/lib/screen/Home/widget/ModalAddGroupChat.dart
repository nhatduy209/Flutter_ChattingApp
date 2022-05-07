import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/ListGroupChat.dart';
import 'package:flutter_chatting/models/UserModel.dart';
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
  List<dynamic> listFriends = [];

  //List<Map<String, bool>> listCheck = [];
  Future<void> getListFriends(ListGroupChat listCheckBoxs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var currentUser = prefs.getString('username');

    CollectionReference account =
        FirebaseFirestore.instance.collection('account');

    account.get().then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        User user = User.fromJson(doc.data());

        if (currentUser == user.userName) {
          List<Map<String, bool>> listCheckBox = [];
          for (var element in user.listFriends) {
            listCheckBox.add({'$element': false});
          }
          setState(() => {
                listFriends = user.listFriends,
                listCheckBoxs.listCheck = listCheckBox
              });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var listCheckBox = Provider.of<ListGroupChat>(context);
    listFriends.isEmpty
        ? getListFriends(listCheckBox)
        : print('LENGHT : ' + listFriends.length.toString());

    return listFriends.isNotEmpty
        ? ListView.builder(
            itemCount: listFriends.length,
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
                          backgroundImage: NetworkImage(
                              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Fblank-avatar&psig=AOvVaw3VFHw0I-PbgMeYBBSY7dDd&ust=1652014205254000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCPj-5c-2zfcCFQAAAAAdAAAAABAR'),
                        )),
                    Text(listFriends[index],
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
