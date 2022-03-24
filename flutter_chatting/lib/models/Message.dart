import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String content;
  DateTime time = DateTime.now();
  Message({required this.id, required this.content, time = null});

  set setId(String _id) {
    id = _id;
  }

  String get getId => id;

  set setContent(String _content) {
    content = _content;
  }

  String get getContent => content;

  set setTime(DateTime _time) {
    time = _time;
  }
}
