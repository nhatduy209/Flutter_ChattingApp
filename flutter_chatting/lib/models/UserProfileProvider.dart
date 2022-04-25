import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatting/models/UserModel.dart';

class UserProfile extends ChangeNotifier {
  final User _userProfile =
      User(id: '', userName: '', email: '', age: '', phoneNumber: '', url: '');
  User get userProfile {
    return _userProfile;
  }

  void setProfile(dynamic user) async {
    userProfile.id = user.id;
    userProfile.age = user.age;
    userProfile.userName = user.userName;
    userProfile.email = user.email;
    userProfile.phoneNumber = user.phoneNumber;
    userProfile.password = user.password;
    userProfile.url = user.url;
    notifyListeners();
  }
}
