import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/NotiModel.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
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
  CollectionReference notifications = FirebaseFirestore.instance.collection('notification');
  CollectionReference messages =  FirebaseFirestore.instance.collection('message');
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
    var listFriends = [];
    var ortherFriends = [];
    accounts.get().then((snapshot) => {
      for (DocumentSnapshot ds in snapshot.docs){
        if (ds.data()['username'] == profile.userName) {
          listFriends.addAll(ds.data()['listFriend']),
          listFriends.add(noti.from),
          update(ds, profile, listFriends)
          .then((value) async => await notifications.get().then((snapshot) => {
            for (DocumentSnapshot ds in snapshot.docs){
              if (ds.data()['username'] == noti.userName) {
                ds.reference.delete().then((value) async => 
                await createConversation(noti.from + '_' + profile.userName))
              }
            }
          })
          ),
        }
        else if (ds.data()['username'] == noti.from) {
          ortherFriends.addAll(ds.data()['listFriend']),
          ortherFriends.add(profile.userName),
          update(ds, User(
                id: ds.id,
                userName: ds.data()['username'],
                email: ds.data()['email'],
                age: ds.data()['age'],
                phoneNumber: ds.data()['phoneNumber'],
                listFriend: [],
                url: ds.data()['url'],
                password: ds.data()['password'],
                token: ds.data()['token']), ortherFriends)
          .then((value) => {
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
  Future createConversation(String name) async {
    var genID = new Uuid();
    var idMess = genID.v1();
    messages.doc(name).set(
      {'name': name}
    );
    messages.doc(name).collection('listmessage').add({
      'message': "Let us secure you together. Let's send each other's first messages",
      'Time': DateTime.now(),
      'id': '$idMess-${noti.from}'
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FriendProfileScreen(
                  //       isAdded: false,
                  //       userName: noti.userName,
                  //     )),
                  // )
                },
          child: Container(
            // decoration: BoxDecoration(
            //   border: Border
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    noti.url == '' ?
                    'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740' :
                    noti.url.toString(),
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
                ),
                Container(
                  alignment: Alignment.center,
                        height: 80,
                        width: MediaQuery.of(context).size.width - 160,
                        child: Text(noti.from + ' sent an invitation to you', style: TextStyle(fontWeight: FontWeight.bold))
                      ),
                GestureDetector(
                  onTap: () => {
                    accept(context)
                  },
                  child: Container(
                        width: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 198, 247, 222),
                          borderRadius: BorderRadius.all(Radius.circular(20),
                        ),),
                        child: const Text('Accept')
                      )
                )
              ]
            ),
          )
        );
  }
}
