import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/main.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future logout(
    String username, ListUserModel listUsers, BuildContext context) async {
  QuerySnapshot accounts = await FirebaseFirestore.instance
      .collection('account')
      .where('username', isEqualTo: username)
      .get();

  accounts.docs[0].reference.update({'isOnline': false});
  listUsers.removeAll();
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const MyHomePage(
              title: '',
            )),
  );
}