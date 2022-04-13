import 'dart:collection';

import 'package:flutter/material.dart';

import 'BubleMessageModel.dart';

class ListUserModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<BubbleMessage> _listUser = [];

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
    notifyListeners();
  }
}
