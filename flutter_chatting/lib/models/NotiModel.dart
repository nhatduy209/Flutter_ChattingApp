import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class Noti {
  String userName;
  String url;
  String from;
  Noti(
      {
      required this.userName,
      required this.url,
      required this.from});

  Noti.fromJson(Map<String, dynamic> json)
      : userName = json['username'],
        url = json['url'],
        from = json['from'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'url': url,
        'from': from,
      };

  set setUserName(String _userName) {
    userName = _userName;
  }

  String get getUserName => userName;

  set setFrom(String _from) {
    from = _from;
  }

  String get getFrom => from;

  set setUrl(String _url) {
    url = _url;
  }

  String get getUrl => url;
}
