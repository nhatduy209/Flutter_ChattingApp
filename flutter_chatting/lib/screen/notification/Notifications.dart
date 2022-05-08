import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:flutter_chatting/screen/friends/FrriendsEvent.dart';
import 'package:flutter_chatting/widget/RenderFriendItem.dart';
import 'package:provider/provider.dart';

import '../../models/ListBubbeMessageProvider.dart';
import '../../models/NotiModel.dart';
import '../../widget/RenderNotiItem.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<Noti> listNotifications = [];
  CollectionReference noti =
      FirebaseFirestore.instance.collection('notification');

  Future<dynamic> getListNoti(
      {BuildContext? context}) async {
        User profile = Provider.of<UserProfile>(context!).userProfile;
        final List<Noti> list = [];
        await noti.get().then((data) => {
          for(var noti in data.docs) {
            if (noti.data()['username'] == profile.userName) {
              list.add(Noti(userName: profile.userName, url: noti.data()['url'], from: noti.data()['from']))
            }
          },
          setState(() {
                listNotifications = list;
              })
        });
      }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getListNoti(context: context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Column(children: [
            Expanded(
              child: Container(
                  child: listNotifications.isEmpty ? Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 120),
                        child: Image.asset('assets/images/not-notification-yet.png')
                      ),
                    ]
                  ) :
                  ListView.builder(
                    // ignore: unnecessary_null_comparison
                    itemCount: listNotifications.length,
                    itemBuilder:
                        (BuildContext context, int index) {
                      return RenderNotiItem(
                            noti: listNotifications[index],
                            );
                    },
                  )),
            ),
          ],);
      });
  }
}
