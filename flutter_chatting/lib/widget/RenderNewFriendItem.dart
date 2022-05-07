import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/MessageModel.dart';
import '../models/UserModel.dart';
import '../models/UserProfileProvider.dart';
import '../screen/profile/FriendProfile.dart';
class RenderNewFriendItem extends StatelessWidget {
  User user;
  bool added;
  RenderNewFriendItem({
    required bool added,
    required User user
  })  : this.user = user, this.added = added;
  bool checkFriend(BuildContext context) {
    List<User> listFriends = Provider.of<UserProfile>(context).userProfile.listFriend;
      return listFriends.where((element) => element.userName == user.userName).isNotEmpty;
    }
  bool checkProfile(BuildContext context) {
    User profile = Provider.of<UserProfile>(context).userProfile;
    return profile.userName == user.userName;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 10,
            //     offset: Offset(2, 4), // Shadow position
            //   ),
            // ],
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.network(
                  user.url == '' ?
                  'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740' :
                  user.url.toString(),
                  height: 80.0,
                  width: 80.0,
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendProfileScreen(
                        isAdded: false,
                        userName: user.userName,
                      )),
                  )
                },
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(user.userName, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(user.email == '' ? '--' :  user.email, style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                  ],
                ), 
              ),
              !checkProfile(context) ? GestureDetector(
                onTap: () => {
                  //
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: checkFriend(context) ? Color.fromARGB(255, 198, 247, 222) : Color.fromARGB(255, 197, 199, 198),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: checkFriend(context) ? Icon(Icons.check, color: Color.fromARGB(255, 7, 209, 98),)
                      : Icon(Icons.add, color: Colors.white,)
                    )
                  ],
                ), 
              ) : Container(),
            ]
          ),
        );
  }
}
