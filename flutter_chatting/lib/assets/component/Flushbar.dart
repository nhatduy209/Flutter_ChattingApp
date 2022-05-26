import 'package:flutter/material.dart';

const loginSuccessBar = SnackBar(
  content: Text('Yay! Welcome back'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 30, 224, 130),
);

const loginFailBar = SnackBar(
  content: Text('Username or password invalid , check again'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 227, 41, 28),
);

const deletePost = SnackBar(
  content: Text('You have deleted your post'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 30, 224, 130),
);
