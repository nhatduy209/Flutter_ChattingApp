import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/NotiModel.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:provider/provider.dart';
import '../models/UserProfileProvider.dart';
import '../screen/profile/FriendProfile.dart';

class RenderNotiItem extends StatelessWidget {
  Noti noti;
  RenderNotiItem({
    required Noti noti
  })  : this.noti = noti;
  bool checkProfile(BuildContext context) {
    return false;
  }
  CollectionReference accounts = FirebaseFirestore.instance.collection('account');
  Future update(DocumentSnapshot ds, User profile, var listFriends) async {
    ds.reference.set({
              'username': profile.userName,
              'email': profile.email,
              'age': profile.age,
              'phoneNumber':
                  profile.phoneNumber,
              'password': profile.password,
              'listFriend': listFriends,
              'url': profile.url
            });
  }
  Future accept(BuildContext context) async {
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;
    var listFriends = profile.listFriend.map((e) => e.userName).toList();
      var lFriend = [];
      accounts.get().then((snapshot) => {
        for (DocumentSnapshot ds in snapshot.docs){
          if (ds.data()['username'] == profile.userName) {
            listFriends.add(noti.userName),
            update(ds, profile, listFriends),
          }
          else if (ds.data()['username'] == noti.userName) {
            // lFriend = ds.data()['listFriend'].toList(),
            lFriend.add(profile.userName),
            update(ds, User(
                  id: ds.id,
                  userName: ds.data()['username'],
                  email: ds.data()['email'],
                  age: ds.data()['age'],
                  phoneNumber: ds.data()['phoneNumber'],
                  listFriend: [],
                  url: ds.data()['url'],
                  password: ds.data()['password'],
                  token: ds.data()['token']), lFriend).then((value) => {
              profile.listFriend.add(User(
                  id: ds.id,
                  userName: ds.data()['username'],
                  email: ds.data()['email'],
                  age: ds.data()['age'],
                  phoneNumber: ds.data()['phoneNumber'],
                  listFriend: [],
                  url: ds.data()['url'],
                  password: ds.data()['password'],
                  token: ds.data()['token'])),
              Provider.of<UserProfile>(context, listen: false).setProfile(profile)})
            .catchError((error) => print(error))
          }
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendProfileScreen(
                        isAdded: false,
                        userName: noti.userName,
                      )),
                  )
                },
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.network(
                  noti.url == '' ?
                  'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740' :
                  noti.url.toString(),
                  height: 80.0,
                  width: 80.0,
                ),
              ),
              ),
              Container(
                alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                      height: 80,
                      child: Text(noti.userName + ' sent an invitation to you', style: TextStyle(fontWeight: FontWeight.bold))
                    ),
              GestureDetector(
                onTap: () => {
                  accept(context)
                },
                child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 198, 247, 222),
                        borderRadius: BorderRadius.all(Radius.circular(12),
                      ),),
                      child: const Text('Accept')
                    )
              )
            ]
          ),
        );
  }
}
