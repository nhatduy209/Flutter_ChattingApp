import 'dart:collection';
import 'dart:ffi';

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
  late List<Post> _listPersonalPost = [];
  late String editedPostId = '';

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Post> get getListPosts =>
      UnmodifiableListView(_listPost);

  UnmodifiableListView<Post> get getListPersonalPosts =>
      UnmodifiableListView(_listPersonalPost);

  /// The current total price of all items (assuming all items cost $42).
  int get totalPost => _listPost.length;

  void add(Post Post) {
    _listPost.add(Post);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void setEditedPostId(String id) {
    editedPostId = id;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addPersonalPost(Post Post) {
    _listPersonalPost.add(Post);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool checkExistPersonalPost(Post post) {
    var count = _listPersonalPost
        .where((element) => element.content == post.content)
        .toList();

    if (count.isNotEmpty) {
      return true;
    } else {
      return false;
    }
    // This call tells the widgets that are listening to this model to rebuild.
  }

  void removePersonalPost(Post post) async {
    await FirebaseFirestore.instance
        .collection('post')
        .get()
        .then((querySnapshot) => {
              for (var doc in querySnapshot.docs)
                if (doc['content'] == post.content) {doc.reference.delete()}
            });

    _listPersonalPost.removeWhere((element) => element.content == post.content);

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void insert(Post Post) {
    _listPost.insert(0, Post);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void reloadPost() {
    _listPost.clear();
    _listPersonalPost.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool checkExist(Post post) {
    var count =
        _listPost.where((element) => element.content == post.content).toList();

    if (count.isNotEmpty) {
      return true;
    } else {
      return false;
    }
    // This call tells the widgets that are listening to this model to rebuild.
  }

  void addComment(CommentModel comment, int index) {
    _listPost[index].comments.add(comment);
  }
}
