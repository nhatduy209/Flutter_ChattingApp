import 'package:flutter/material.dart';

class ListGroupChat extends ChangeNotifier {
  List<Map<String, bool>> _listCheck = [];

  List<Map<String, bool>> get getListCheck => _listCheck;

  set listCheck(listFriends) {
    _listCheck = listFriends;
    notifyListeners();
  }

  void setCheckBox(bool? value, int index) {
    for (var i = 0; i < _listCheck.length; i++) {
      if (i == index) {
        _listCheck[index].keys.forEach((element) {
          _listCheck[index][element] = value!;
        });
      }
    }
    notifyListeners();
  }
}
