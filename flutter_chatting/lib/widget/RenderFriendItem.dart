import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import '../screen/profile/FriendProfile.dart';

class RenderFriendItem extends StatelessWidget {
  User user;
  bool added;
  RenderFriendItem({
    required bool added,
    required User user
  })  : this.user = user, this.added = added;
  @override
  Widget build(BuildContext context) {
    print('item');
    print(user.url);
    // TODO: implement build
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendProfileScreen(
              isAdded: added,
              userName: user.userName,
            )),
          )
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(2, 4), // Shadow position
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: 
                Image.network(
                  user.url.isEmpty ?
                  'https://img.freepik.com/free-vector/call-center-concept-with-woman_23-2147939060.jpg?t=st=1651334914~exp=1651335514~hmac=ab8b01b29bfdb4432294983ff7202b6921371e9ba8cce2bc7014ce4cf5b9c77e&w=826'
                  : user.url.toString(),
                  height: 60.0,
                  width: 60.0,
                ),
              ),
              Text('Admin', style: TextStyle(fontWeight: FontWeight.bold),)
            ]
          ),
        )
      )
    );
  }
}
