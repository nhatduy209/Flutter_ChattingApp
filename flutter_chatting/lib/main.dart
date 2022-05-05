import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:flutter_chatting/screen/Home/Home.dart';
import 'package:flutter_chatting/screen/register/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatting/screen/forgot_password/ForgotPassword.dart';
import 'package:flutter_chatting/widget/LoadingCircle.dart';
import 'package:fluttertoast/fluttertoast.dart' as toastfliutter;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

import 'assets/component/Flushbar.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  showSimpleNotification(
    Text(message.notification!.title!),
    trailing: const Icon(
      Icons.mark_chat_unread,
      color: Color.fromARGB(255, 114, 178, 230),
    ),
    subtitle: Text(message.notification!.body),
    background: Colors.cyan.shade700,
    duration: Duration(seconds: 2),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? token = await messaging.getToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // For displaying the notification as an overlay
      showSimpleNotification(
        Text(message.notification!.title!),
        trailing: const Icon(
          Icons.mark_chat_unread,
          color: Color.fromARGB(255, 114, 178, 230),
        ),
        subtitle: Text(message.notification!.body),
        background: Colors.cyan.shade700,
        duration: Duration(seconds: 2),
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(
      (message) => _firebaseMessagingBackgroundHandler(message));

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
    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Chatting app'),
    ));
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

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> handleLogin(UserProfile userProfile) async {
    accounts.get().then((QuerySnapshot querySnapshot) async {
      setState(() {
        isPressLogin = true;
      });
      final listUser = [];
      final allData = [];
      for (var doc in querySnapshot.docs) {
        allData.add(doc.data());
        if (doc.data()['username'] == username.text) {
          listUser.add(User(
              id: doc.id,
              userName: doc.data()['username'],
              email: doc.data()['email'],
              age: doc.data()['age'],
              phoneNumber: doc.data()['phoneNumber'],
              password: doc.data()['password'],
              url: doc.data()['url'],
              token: ''));
        }
      }
      var exist = allData.where((item) =>
          item['username'] == username.text &&
          item['password'] == password.text);

      if (exist.isNotEmpty &&
          username.text.isNotEmpty &&
          password.text.isNotEmpty) {
        String? token = await messaging.getToken();
        makeOnline(username.text, token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // Set
        prefs.setString('username', username.text);
        print(exist.toList()[0]);
        print(listUser[0].id);
        userProfile.setProfile(listUser[0]);

        ScaffoldMessenger.of(context).showSnackBar(loginSuccessBar);

        setState(() => isPressLogin = false);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeRouteState(
                    title: 'Home',
                  )),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(loginFailBar);

        setState(() => isPressLogin = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: isPressLogin == true
                ? const LoadingCircle()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          'https://img.freepik.com/free-vector/connected-world-concept-illustration_114360-3027.jpg?t=st=1650570131~exp=1650570731~hmac=aa79063ca4365e1d5622440bbb741fbd60e48de4e6293d16defaf40d40ae1c83&w=740',
                          height: 350.0,
                          width: 350.0,
                        ),
                        margin: const EdgeInsets.only(top: 100.0),
                      ),
                      Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 30.0),
                          padding: const EdgeInsets.only(left: 16, right: 16),
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
                                  hintText: 'Enter your username',
                                  border: InputBorder.none),
                            ),
                          )),
                      Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 30.0),
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 241, 241, 241),
                              borderRadius: BorderRadius.circular(24.0)),
                          child: SizedBox(
                            height: 50,
                            width: 300,
                            child: TextField(
                              obscureText: true,
                              // style: const TextStyle(
                              //   letterSpacing: 1.5,
                              // ),
                              controller: password,
                              decoration: const InputDecoration(
                                  hintText: 'Enter your username',
                                  border: InputBorder.none),
                            ),
                          )),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 40.0),
                          child: TextButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword()),
                                  ),
                              child: const Text(
                                "Forgot password",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          width: 300,
                          child: TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepPurpleAccent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0))),
                              ),
                              onPressed: () => accounts.get().then(
                                      (QuerySnapshot querySnapshot) async {
                                    setState(() {
                                      isPressLogin = true;
                                    });
                                    final listUser = [];
                                    final allData = [];
                                    for (var doc in querySnapshot.docs) {
                                      allData.add(doc.data());
                                      if (doc.data()['username'] ==
                                          username.text) {
                                        listUser.add({
                                            'id': doc.id,
                                            'userName': doc.data()['username'],
                                            'email': doc.data()['email'],
                                            'age': doc.data()['age'],
                                            'phoneNumber':
                                                doc.data()['phoneNumber'],
                                            'password': doc.data()['password'],
                                            'listFriend': doc.data()['listFriend'],
                                            'url': doc.data()['url']});
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
                                      prefs.setString(
                                          'username', username.text);
                                      final List<User> friends = [];
                                      for (var friend in listUser[0]['listFriend']) {
                                        var data = querySnapshot.docs.firstWhere((element) => element.data()['username'] == friend);                           
                                        friends.add(User(
                                        id: data.id,
                                        userName: data.data()['username'],
                                        email: data.data()['email'],
                                        age: data.data()['age'],
                                        phoneNumber: data.data()['phoneNumber'],
                                        listFriend: [],
                                        url: data.data()['url'])
                                        );
                                      }
                                      userProfile.setProfile(User(
                                        id: listUser[0]['id'],
                                        userName: listUser[0]['userName'],
                                        email: listUser[0]['email'],
                                        age: listUser[0]['age'],
                                        phoneNumber: listUser[0]['phoneNumber'],
                                        listFriend: friends,
                                        url: listUser[0]['url'])
                                      );

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
                                            builder: (context) =>
                                                HomeRouteState(
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
                              child: Text('Sign in',
                                  style: TextStyle(fontSize: 25)))),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account!",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SecondRoute()),
                                  ),
                              child: const Text(
                                "Register account",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                ),
                              )),
                        ],
                      ))
                    ],
                  ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
