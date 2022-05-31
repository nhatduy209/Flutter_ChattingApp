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

const deleteCommentSuccess = SnackBar(
  content: Text('You have deleted your comment'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 30, 224, 130),
);

const deleteCommentFail = SnackBar(
  content: Text('You can\'t delete other people comment'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 227, 41, 28),
);

const replyCommentSuccess = SnackBar(
  content: Text('You have replied to a comment'),
  behavior: SnackBarBehavior.fixed,
  backgroundColor: Color.fromARGB(255, 30, 224, 130),
);
