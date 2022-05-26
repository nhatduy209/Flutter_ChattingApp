import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatting/screen/news-feed/widget/CommentInput.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/PostModel.dart';
import '../../models/UserModel.dart';
import '../../models/UserProfileProvider.dart';

class ActionLikeShareComment extends StatefulWidget {
  final String postId;
  final String content;
  final int index;
  // int numberOfLikes;
  List<String>? photos;
  ActionLikeShareComment({
    Key? key,
    required this.postId,
    //required this.numberOfLikes,
    required this.index,
    required this.content,
    this.photos,
  }) : super(key: key);

  @override
  ActionLikeShareState createState() => ActionLikeShareState();
}

class ActionLikeShareState extends State<ActionLikeShareComment> {
  bool pressedComment = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // _ThumbUpButton(
              //   postId: widget.postId,
              //   numberOfLikes: widget.numberOfLikes,
              // ),
              _ThumbUpButton(postId: widget.postId,),
              IconButton(
                icon: const Icon(
                  Icons.comment,
                  color: Color(0xFF04764E),
                  size: 25.0,
                ),
                onPressed: () {
                  setState(() {
                    pressedComment = !pressedComment;
                  });
                },
              ),
              _ShareButton(widget.content, widget.photos),
            ],
          ),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        ),
        pressedComment
            ? CommentInput(
                postId: widget.postId,
                index: widget.index,
                )
            : Container(),
      ],
    );
  }
}

class _ThumbUpButton extends StatefulWidget {
  String postId;
  // int numberOfLikes;
  _ThumbUpButton({Key? key, required this.postId})
      : super(key: key);

  @override
  _ThumbUpButtonState createState() => _ThumbUpButtonState();
}

class _ThumbUpButtonState extends State<_ThumbUpButton> {
  var like = 0;
  var isFetched = true;
  var isLike = false;
  var likes = [];
  CollectionReference post =
      FirebaseFirestore.instance.collection('post');
  void checkLike(List<dynamic> likeList) {
    var liked = [];
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;
    for(var e in likeList) {
      if(e['username'] == profile.userName) {
        liked.add(e);
      }
    }
    setState(() {
      if(liked.length > 0) {
        isLike = true;
      } else {
        isLike = false;
      }
    });
  }

  Future<dynamic> getLikes(
      {BuildContext? context}) async {
        if (isFetched) {
          await post.get().then((data) => {
            for(var e in data.docs) {
              if (e.id == widget.postId) {
                setState(() {
                  like = e.data()['likes'].length;
                  isFetched = false;
                }),
                checkLike(e.data()['likes']),
              }
            },
          });
        }
      }
  Future<dynamic> hanlde() async {
        await post.get().then((data) => {
            for(var e in data.docs) {
              if (e.id == widget.postId) {
                hanldeLike(e.data()['likes'], e)
              }
            },
          });
      }
  Future<dynamic> hanldeLike(likeList, DocumentSnapshot post) async {
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;
    likes = [];
    if(isLike) {
      for(var e in likeList) {
        if(e['username'] != profile.userName) {
          likes.add(e);
        }
      }
      await post.reference.update({'likes': likes});
    } else {
      likes = likeList;
      likes.add({'createAt': Timestamp.now(), 'url': '', 'username': profile.userName});
      await post.reference.update({'likes': likes});
    }
    setState(() {
      isFetched = true;
    });
    checkLike(likeList);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return FutureBuilder<dynamic>(
      future: getLikes(context: context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return
        TextButton(
          onPressed: () async {
            hanlde();
          },
          child: Row(
            children: [
              Icon(Icons.thumb_up,
              color: isLike ? Color(0xFF04764E) : Color.fromRGBO(200, 200, 200, 1.0),
              size: 25.0),
              SizedBox(width: 5),
              // Text(widget.numberOfLikes.toString()),
              Text(like.toString(), style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1.0)),),
              SizedBox(width: 10),
              Text('Like', style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1.0)),),
            ],
          ),
        );
      }
    );
  }
}

class _ShareButton extends StatelessWidget {
  String content;
  List<String>? photos;
  _ShareButton(this.content, this.photos);

  Future<List<String>> getPathFromUrl(List<String> photos) async {
    List<String> paths = [];
    for (var photo in photos) {
      final uri = Uri.parse(photo);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/${photo.length}.png';

      paths.add(path);

      File(path).writeAsBytesSync(bytes);
    }

    return paths;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      onPressed: () async {
        if (photos!.isNotEmpty) {
          //List<String> listPath = await getPathFromUrl(photos!);
          //Share.shareFiles(photos, subject: content, text: content);
          Share.share(content, subject: photos![0]);
        } else {
          Share.share(content);
        }
      },
      child: Row(
        children: const [
          Icon(Icons.share, color: Color(0xFF04764E), size: 25.0),
          SizedBox(width: 10),
          // Text(AppLocalizations.of(context)!.share)
        ],
      ),
    );
  }
}
