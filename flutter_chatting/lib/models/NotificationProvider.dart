import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatting/models/NotiModel.dart';
import 'package:flutter_chatting/models/UserModel.dart';

class NotificationProvider extends ChangeNotifier {
  final List<Noti> _listNoti = [];
  List<Noti> get listNoti {
    return _listNoti;
  }

  void addNoti(Noti noti) {
    _listNoti.add(noti);
    notifyListeners();
  }

  void resetNoti() {
    _listNoti.clear();
    notifyListeners();
  }
}
