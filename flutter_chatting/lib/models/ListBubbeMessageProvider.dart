import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BubleMessageModel.dart';

class ListUserModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  late List<BubbleMessage> _listUser = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<BubbleMessage> get getListUsers =>
      UnmodifiableListView(_listUser);

  /// The current total price of all items (assuming all items cost $42).
  int get totalUser => _listUser.length;

  void add(BubbleMessage user) {
    _listUser.add(user);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void changeLatestMessage(
      String username, String latestMessage, String latestTime) {
    var updateMessage =
        _listUser.where((userUpdate) => userUpdate.username == username).first;

    updateMessage.latestMessage = latestMessage;
    updateMessage.latestMessageTime = latestTime;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeUser(BubbleMessage user) {
    _listUser
        .removeWhere((userRemoved) => userRemoved.username == user.username);

    deleteAPI('message', user.idChatting);
    notifyListeners();
  }

  void removeAll() {
    _listUser.clear();
    notifyListeners();
  }

  Future<dynamic> getAllUsers(bool isSearch) async {
    var commonFunc = Utilities();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getUsername = prefs.getString('username');

    // Get data from docs and convert map to List
    if (_listUser.isEmpty && isSearch == false) {
      await FirebaseFirestore.instance
          .collection('message')
          .get()
          .then((QuerySnapshot querySnapshot) async {
        if(_listUser.isEmpty) {
          for (var doc in querySnapshot.docs) {
            if (doc.id.contains(getUsername)) {
              String newUserChatting = commonFunc.getUserChatting(
                  idChatting: doc.id, username: getUsername);
                  var data = await FirebaseFirestore.instance
                  .collection('account')
                  .where('username', isEqualTo: newUserChatting)
                  .get();
                  print(data.docs[0].data());
              print(data.docs[0].data()['url']);
              _listUser.add(
                  BubbleMessage(username: newUserChatting, idChatting: doc.id, avatar: data.docs.length > 0 ? data.docs[0].data()['url'] : ''));
            }
          }
        }
      });
    }
    notifyListeners();
  }

  Future<dynamic> search(String username) async {
    _listUser = _listUser.where(((user) => user.username == username)).toList();
    notifyListeners();
  }
}
