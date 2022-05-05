import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatting/models/UserModel.dart';

class UserProfile extends ChangeNotifier {
  final User _userProfile =
      User(id: '', userName: '', email: '', age: '', phoneNumber: '', url: '', listFriend: [], token: '');
  User get userProfile {
    return _userProfile;
  }

  void setProfile(User user) async {
    print('provider');
    print(user.listFriend);
    _userProfile.id = user.id;
    _userProfile.age = user.age;
    _userProfile.userName = user.userName;
    _userProfile.email = user.email;
    _userProfile.phoneNumber = user.phoneNumber;
    _userProfile.listFriend = user.listFriend;
    _userProfile.password = user.password;
    _userProfile.url = user.url;
    notifyListeners();
  }
}
