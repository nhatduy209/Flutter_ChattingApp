import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/common/utilities.dart';
import 'package:flutter_chatting/models/PostModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BubleMessageModel.dart';

class ListPostProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  late List<Post> _listPost = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Post> get getListPosts =>
      UnmodifiableListView(_listPost);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPost => _listPost.length;

  void add(Post Post) {
    _listPost.add(Post);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addAll(List<Post> ListPost) {
    print('listPosst');
    print(ListPost.length);
    _listPost.addAll(ListPost);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
  void clear() {
    _listPost.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
