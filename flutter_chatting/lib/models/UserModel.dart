import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class User {
  String id;
  String userName;
  String email;
  String age;
  String phoneNumber;
  String? password;
  String url;
  List<User> listFriend;
  String token;
  User(
      {required this.id,
      required this.userName,
      required this.email,
      required this.age,
      required this.phoneNumber,
      password,
      required this.listFriend,
      required this.url,
      required this.token});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['username'],
        email = json['email'],
        age = json['age'],
        phoneNumber = json['phoneNumber'],
        listFriend = json['listFriend'],
        url = json['url'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'age': age,
        'phoneNumber': phoneNumber,
        'listFriend': listFriend,
        'url': url,
        'token': token,
      };

  set setPassword(String _password) {
    password = _password;
  }

  String? get getPassword => password;

  set setId(String _id) {
    id = _id;
  }

  String get getId => id;

  set setUserName(String _userName) {
    userName = _userName;
  }

  String get getUserName => userName;

  set setEmail(String _email) {
    email = _email;
  }

  String get getEmail => email;

  set setAge(String _age) {
    age = _age;
  }

  String get getAge => age;

  set setPhoneNumber(String _phoneNumber) {
    phoneNumber = _phoneNumber;
  }

  String get getPhoneNumber => phoneNumber;

  List<User> get getListFriend => listFriend;

  set setListFriend(List<User> _listFriend) {
    listFriend = _listFriend;
  }
}
