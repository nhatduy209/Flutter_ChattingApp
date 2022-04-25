import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/screen/friends/FrriendsEvent.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  FriendsState createState() => FriendsState();
}

class FriendsState extends State<Friends> {
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Align(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(24.0)),
            child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: username,
                // style: const TextStyle(
                //   letterSpacing: 1.5,
                // ),
                decoration: const InputDecoration(
                    hintText: 'Find your friends...', border: InputBorder.none),
              ),
            )),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            User userSearch = await findByUsername(username.text);
            print("Get data ${userSearch.userName}");
          },
          child: const Text('Click'),
        ),
      ],
    ));
  }
}
