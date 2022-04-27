import 'package:flutter/material.dart';
import 'package:flutter_chatting/screen/profile/Profile.dart';

import '../profile/FriendProfile.dart';

class SettingsApp extends StatelessWidget {
  const SettingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(leading: Container(), actions: [
          Align(
              child: TextButton(
                  onPressed: () {},
                  child: const Text('Save',
                      style: TextStyle(fontSize: 20, color: Colors.black))))
        ]),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.network(
                      'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740',
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      border: Border.all(width: 0.5, color: Color(0xFFE8EAF6)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FriendProfileScreen()),
                          );
                        },
                        child: const ListTile(
                          leading: Icon(Icons.person, size: 35),
                          title: Text('Profile'),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {},
                        child: const ListTile(
                          leading: Icon(Icons.public, size: 35),
                          title: Text('Language'),
                          subtitle:
                              Text('English', style: TextStyle(fontSize: 13)),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ]),
                  )
                ],
              )),
        ));
  }
}
