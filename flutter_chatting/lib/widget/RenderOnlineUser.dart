import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:intl/intl.dart';
import '../models/MessageModel.dart';
import '../screen/profile/FriendProfile.dart';

class RenderOnlineUser extends StatelessWidget {
  User user;
  RenderOnlineUser({
    required User user
  })  : this.user = user;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          height: 70,
          margin: EdgeInsets.all(6),
          child: GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendProfileScreen(
                  isAdded: true,
                  userName: user.userName,
                )),
              )
            },
            child: Stack(
            children: [
              Container(
                  child: Container(
                // margin: const EdgeInsets.all(40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    user.url.isEmpty ?
                    'https://img.freepik.com/free-vector/call-center-concept-with-woman_23-2147939060.jpg?t=st=1651334914~exp=1651335514~hmac=ab8b01b29bfdb4432294983ff7202b6921371e9ba8cce2bc7014ce4cf5b9c77e&w=826':
                    user.url.toString(),
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
              )),
              user.email.isNotEmpty ? Container(
                // margin: const EdgeInsets.only(top: 44, left: 44),
                width: 10.0,
                height: 10.0,
                // color: Color.fromARGB(232, 10, 243, 49),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(232, 10, 243, 49),
                    borderRadius:
                        BorderRadius.all(Radius.circular(40))),
              ) : Container()
            ],
          ),
          )
        );
  }
}
