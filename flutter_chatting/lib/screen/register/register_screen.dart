import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}
class _SecondRouteState extends State<SecondRoute> {
  CollectionReference accounts =
        FirebaseFirestore.instance.collection('account');

  final username = TextEditingController();
  final email = TextEditingController();
  final age = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool checkNull() {
    return username.text.isNotEmpty && email.text.isNotEmpty
    && age.text.isNotEmpty && phoneNumber.text.isNotEmpty
    && password.text.isNotEmpty;
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<dynamic> signUp() async {
    var exist;
    await accounts
      .get()
      .then((QuerySnapshot querySnapshot) async {
        final allData = querySnapshot.docs
        .map((doc) => doc.data())
        .toList();
    exist = allData.where((item) =>
        item['username'] == username.text);
      });
    if (!checkNull()) {
      _showToast(context, 'Please fill all field');
      return;
    }
    if (exist.length > 0) {
      _showToast(context, 'Username existed!');
      return;
    }
    if(confirmPassword.text == password.text) {
      accounts.add({
        'username': username.text,
        'password' : password.text,
        'email': email.text,
        'phoneNumber' : phoneNumber.text,
        'age' : age.text
      }).then((value) => _showToast(context, 'Sign up successfully'))
      .then((value) => Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                ));
    } else {
      _showToast(context, 'Password confirm is not correct!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
        Container(
          child:
              const Icon(Icons.label_important, color: Colors.lightBlue, size: 150.0),
          margin: const EdgeInsets.only(top: 40.0),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
            child: const Text("Create account", style: TextStyle(fontSize: 25.0))),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.person, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: username,
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                  border: InputBorder.none
                ),
              ),
            )),
          ],
        ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.male, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: age,
                decoration: const InputDecoration(
                  hintText: 'Enter your age',
                  border: InputBorder.none
                ),
              ),
            )),
          ],
        ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.mail, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: InputBorder.none
                ),
              ),
            )),
          ],
        ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.phone, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: phoneNumber,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your phone number',
                ),
              ),
            )),
          ],
        ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.lock, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your password',
                ),
              ),
            )),
          ],
        ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black38)
              )
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.lock, color: Colors.lightBlue, size: 30.0),
            Flexible(
                child: SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Confirm your password',
                ),
              ),
            )),
          ],
        ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 60.0),
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // background
                onPrimary: Colors.white, // foreground
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () => signUp(),
              child: Text('Sign up'),
            )),
        Container(margin: const EdgeInsets.only(top: 10.0), child: Text("Or")),
        Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            width: MediaQuery.of(context).size.width * 0.6,
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
      )
    );
  }
}