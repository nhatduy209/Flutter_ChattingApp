import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

//import 'main.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final email = TextEditingController();

  void _sendRecoverPassword(context, email) async {
    var instance = FirebaseAuth.instance;
    await instance.sendPasswordResetEmail(email: email).then(
      (value) {
        // Fluttertoast.showToast(
        //     msg: "Recovery password has ben sent",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 20.0);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: <Widget>[
        Container(
          child:
              Icon(Icons.label_important, color: Colors.lightBlue, size: 150.0),
          margin: const EdgeInsets.only(top: 100.0, bottom: 100.0),
        ),
        TextField(
          controller: email,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
        ),
        ElevatedButton(
          onPressed: () => _sendRecoverPassword(context, email.text),
          child: const Text('Reset password'),
        ),
      ])),
    );
  }
}
