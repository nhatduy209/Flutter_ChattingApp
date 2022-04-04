import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}
class _SecondRouteState extends State<SecondRoute> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Sign up successfully'),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
    Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference accounts =
        FirebaseFirestore.instance.collection('account');
    return Scaffold(
      body: Center(
          child: Column(children: <Widget>[
        Container(
          child:
              const Icon(Icons.label_important, color: Colors.lightBlue, size: 150.0),
          margin: const EdgeInsets.only(top: 100.0),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 40.0, bottom: 30.0),
            child: const Text("Create account", style: TextStyle(fontSize: 25.0))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.person, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 40,
              width: 250,
              child: TextFormField(
                controller: username,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            )),
          ],
        ),
        Container(margin: const EdgeInsets.only(top: 20.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.lock, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 40,
              width: 250,
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your password',
                ),
              ),
            )),
          ],
        ),
        Container(margin: const EdgeInsets.only(top: 20.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(width: 30, height: 30),
            Flexible(
                child: SizedBox(
              height: 40,
              width: 250,
              child: TextFormField(
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm your password',
                ),
              ),
            )),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 30.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // background
                onPrimary: Colors.white, // foreground
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                if(confirmPassword.text == password.text) {
                  accounts.add({
                    'username': username.text,
                    'password' : password.text
                  }).then((value) => _showToast(context));
                }
              },
              child: Text('Sign up'),
            )),
        Container(margin: const EdgeInsets.only(top: 10.0), child: Text("Or")),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white, // background
                  onPrimary: Colors.white, // foreground
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  side: BorderSide(
                    width: 1.0,
                    color: Colors.black,
                  )),
              onPressed: () => {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                )
              },
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.black),
              ),
            )),
      ])),
    );
  }
}