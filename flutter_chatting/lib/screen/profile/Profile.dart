import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/UserModel.dart';
import 'package:flutter_chatting/models/UserProfileProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../common/firebase.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileState();
}

class ProfileState extends State<ProfileScreen> {
  List<File> listImage = <File>[];
  var userProfile = User(id: '', userName: '', email: '', age: '', phoneNumber: '', url: '', listFriend: [], token: '');
  final phoneNumber = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final userName = TextEditingController();
  late String url = 'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740';
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  showMessage() {
    Fluttertoast.showToast(
    msg: "Updated successfully",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green[500],
    textColor: Colors.white,
    fontSize: 16.0);
  }
  changeProfile() async {
    if (listImage.isNotEmpty) {
      var listImageUrl = await uploadImageToFirebase(listImage);
      url = listImageUrl.isNotEmpty ? listImageUrl[0] : '';
    }
    // if (password.text.isNotEmpty) {
    //   if (confirmPassword.text == password.text) {
    //     var accounts = await FirebaseFirestore.instance.collection('account');
    //     accounts.doc(userProfile.id).update({
    //       'age': age.text, 'phoneNumber': phoneNumber.text, 'url': url,
    //       'password': password.text
    //     }).then((value) => print('success'));
    //   } else {
    //     print('password is wrong!');
    //   }
    //   return;
    // }
    var accounts = await FirebaseFirestore.instance.collection('account');
    accounts.doc(userProfile.id).update({
     'age': age.text, 'phoneNumber': phoneNumber.text, 'url': url
    }).then((value) => {
      showMessage()

      });
  }
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        if (listImage.isEmpty) {
          listImage.add(File(pickedFile.path));
        } else {
          listImage[0] = File(pickedFile.path);
        }
      });
    }
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        if (listImage.isEmpty) {
          listImage.add(File(pickedFile.path));
        } else {
          listImage[0] = File(pickedFile.path);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfile>(context);
    if (userProfile.id.isEmpty) {
      userProfile = Provider.of<UserProfile>(context).userProfile;
      phoneNumber.text = userProfile.phoneNumber;
      age.text = userProfile.age;
      email.text = userProfile.email;
      userName.text = userProfile.userName;
      url = userProfile.url != null ? url : userProfile.url;
      print(userProfile.url);
    }
    // TODO: implement build
    return Scaffold(
        body: SingleChildScrollView(
      child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Icon(Icons.arrow_back,
                        color: Colors.black38, size: 24.0),
                  )),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: const Text("My Profile",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child:
                      listImage.isEmpty && url.isNotEmpty ? Image.network(
                        // userProfile.url.isNotEmpty ? userProfile.url :
                        'https://img.freepik.com/free-vector/mysterious-gangster-mafia-character-smoking_23-2148474614.jpg?t=st=1650615735~exp=1650616335~hmac=e739702e26831846c2cb4c0c1b3901323df00e8379fd23bf37a6c6a157b4d68b&w=740',
                        height: 100.0,
                        width: 100.0,
                      ) : 
                      Image.file(listImage[0], height: 100.0,
                        width: 100.0,),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80.0, left: 80.0),
                      child: IconButton(
                                    icon: const Icon(Icons.camera,
                          color: Colors.black38, size: 24.0),
                                    onPressed: () => {_getFromGallery()},
                                  ),
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Username",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: userName,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        border: InputBorder.none),
                    ),
                  )),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Email",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(hintText: 'Enter your email',border: InputBorder.none),
                    ),
                  )),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Age",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: age,
                      decoration: InputDecoration(hintText: 'Enter your age',border: InputBorder.none),
                    ),
                  )),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Phone Number",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: phoneNumber,
                      decoration: InputDecoration(hintText: 'Enter your phone number',border: InputBorder.none),
                    ),
                  )),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Password",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Enter your current password',border: InputBorder.none),
                    ),
                  )),
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                alignment: Alignment.bottomLeft,
                child: const Text("Confirm Password",
                    style: TextStyle(fontSize: 20.0, color: Colors.black)),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(
                      controller: confirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Confirm your current password',border: InputBorder.none),
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 42.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(
                            255, 189, 0, 255), // background
                        onPrimary: Colors.white, // foreground
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        side: const BorderSide(
                          width: 0,
                          color: Color.fromARGB(255, 189, 0, 255),
                        )),
                    onPressed: () => {
                      changeProfile()
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )),
            ],
          )),
    ));
  }
}
