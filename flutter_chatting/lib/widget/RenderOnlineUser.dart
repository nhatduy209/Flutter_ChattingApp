import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/MessageModel.dart';

class RenderOnlineUser extends StatelessWidget {
  bool isOnline;
  RenderOnlineUser({
    required bool isOnline,
  })  : this.isOnline = isOnline;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          height: 70,
          margin: EdgeInsets.all(6),
          child: Stack(
            children: [
              Container(
                  child: Container(
                // margin: const EdgeInsets.all(40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.network(
                    'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740',
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
              )),
              this.isOnline ? Container(
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
        );
  }
}
