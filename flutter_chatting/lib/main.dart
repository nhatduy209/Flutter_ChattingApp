import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:flutter_chatting/register_screen.dart';
import 'package:flutter_chatting/screen/Home/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatting/screen/forgot_password/ForgotPassword.dart';
import 'package:flutter_chatting/widget/LoadingCircle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ListUserModel()),
      ChangeNotifierProvider(create: (context) => UserProfile()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chatting app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool isPressLogin = false;
  CollectionReference accounts =
      FirebaseFirestore.instance.collection('account');
  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      body: Center(
        child: isPressLogin == true
            ? const LoadingCircle()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.label_important,
                    color: Colors.lightBlue,
                    size: 150.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                      controller: username,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0),
                    child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your password'),
                        controller: password),
                  ),
                  Container(
                      child: TextButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SecondRoute()),
                              ),
                          child: Text(
                            "Register account",
                            textAlign: TextAlign.end,
                          ))),
                  Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 300,
                      child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurpleAccent),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                          onPressed: () => accounts
                                  .get()
                                  .then((QuerySnapshot querySnapshot) async {
                                setState(() {
                                  isPressLogin = true;
                                });
                                final listUser = [];
                                final allData = [];
                                for (var doc in querySnapshot.docs) {
                                    allData.add(doc.data());
                                    if (doc.data()['username'] == username.text) {
                                      listUser.add(User(id: doc.id, userName: doc.data()['username'], email: doc.data()['email'], age: doc.data()['age'], phoneNumber: doc.data()['phoneNumber'], password: doc.data()['password'], url: doc.data()['url']));
                                    }
                                  }
                                var exist = allData.where((item) =>
                                    item['username'] == username.text &&
                                    item['password'] == password.text);

                                if (exist.length > 0 &&
                                    username.text.isNotEmpty &&
                                    password.text.isNotEmpty) {
                                  makeOnline(username.text);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  // Set
                                  prefs.setString('username', username.text);
                                  print(exist.toList()[0]);
                                  print(listUser[0].id);
                                  userProfile.setProfile(listUser[0]);

                                  Fluttertoast.showToast(
                                      msg: "Login successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green[500],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  setState(() => isPressLogin = false);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeRouteState(
                                              title: 'Home',
                                            )),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Login fail",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 20.0);
                                  setState(() => isPressLogin = false);
                                }
                              }),
                          child:
                              Text('Sign in', style: TextStyle(fontSize: 25)))),
                  Container(
                      child: TextButton(
                          onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()),
                              ),
                          child: const Text(
                            "Forgot password",
                            textAlign: TextAlign.end,
                          ))),
                ],
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
