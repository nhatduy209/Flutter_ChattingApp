import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatting/models/UserModel.dart';

Future<User> findByUsername(String search) async {
  CollectionReference users = FirebaseFirestore.instance.collection('account');
  late User user;

  await users.get().then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      doc.data().forEach((key, value) {
        if (key == 'username' && value == search) {
          user = User.fromJson(doc.data());
          print("VALUE -- ${user.userName}");
        }
      });
      return user;
    }
  });

  if (user.userName.isNotEmpty) {
    return user;
  } else {
    return User(
        userName: "", age: '', id: '', email: '', phoneNumber: '', url: '', listFriend: []);
  }
}
