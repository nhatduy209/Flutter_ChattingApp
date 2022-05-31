import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/assets/component/Flushbar.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../../models/PostModel.dart';
import '../../../models/UserModel.dart';
import '../../../models/UserProfileProvider.dart';

class ListComments extends StatefulWidget {
  final String postId;
  // int numberOfLikes;
  ListComments({Key? key, required this.postId
      //required this.numberOfLikes,
      })
      : super(key: key);

  @override
  ListCommentsState createState() => ListCommentsState();
}

class ListCommentsState extends State<ListComments> {
  List<CommentModel> listComments = [];
  CollectionReference posts = FirebaseFirestore.instance.collection('post');
  late bool firstReload = true;
  bool isPressReplyComment = false;

  Future<dynamic> reload() async {
    final List<CommentModel> list = [];
    await posts.get().then((data) {
      for (var post in data.docs) {
        if (post.id == widget.postId) {
          for (var comment in post.data()['comments']) {
            try {
              CommentModel cmtModel = CommentModel.fromJson(comment);
              list.add(cmtModel);
            } catch (err) {}
          }
        }
      }
    });

    if (list.length != listComments.length) {
      setState(() {
        listComments = list;
      });
    }
  }

  Future<dynamic> getListComments({BuildContext? context}) async {
    await reload();
  }

  Future<dynamic> deleteComment(
      BuildContext context, CommentModel comment) async {
    await posts.doc(widget.postId).update({
      'comments': listComments
          .where((element) =>
              element.content != comment.content &&
              element.createAt != comment.createAt)
          .toList()
    }).then((value) => {Navigator.pop(context, 'OK'), reload()});
  }

  Widget OptionPopup(CommentModel comment) {
    return Container(
        height: 50,
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.black87),
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () => {
                  Navigator.pop(context),
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete confirm form'),
                      content:
                          const Text('Do you want to delete this comment?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => deleteComment(context, comment),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  )
                },
            child: const Text(
              'Delete',
              style: TextStyle(fontSize: 24, color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;

    return FutureBuilder<dynamic>(
        future: getListComments(context: context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listComments.length, // list comments in posts
            itemBuilder: (BuildContext context, int index) {
              return (Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 10, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    listComments[index].username,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  subtitle: ReplyComment(
                    content: listComments[index].content,
                    postId: widget.postId,
                    commentId: listComments[index].id,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      listComments[index].url,
                    ),
                  ),
                  trailing: Text(
                    Jiffy(
                      listComments[index].createAt.toDate().toString(),
                    ).fromNow(),
                    style: const TextStyle(fontSize: 11.0),
                  ),
                  onTap: () => {
                    listComments[index].username == profile.userName
                        ? showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                            builder: (BuildContext context) {
                              return OptionPopup(listComments[index]);
                            },
                          )
                        : ScaffoldMessenger.of(context)
                            .showSnackBar(deleteCommentFail)
                  },
                ),
              ));
            },
          );
        });
  }
}

class ReplyComment extends StatefulWidget {
  final String content;
  final String commentId;
  final String postId;
  const ReplyComment(
      {Key? key,
      required this.content,
      required this.postId,
      required this.commentId})
      : super(key: key);

  @override
  ReplyCommentState createState() => ReplyCommentState();
}

class ReplyCommentState extends State<ReplyComment> {
  bool isPressCommentReply = false;
  final replyCommentInput = TextEditingController();
  Future<void> replyComment() async {
    CollectionReference post = FirebaseFirestore.instance.collection('post');
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;

    ReplyCommentModel response = ReplyCommentModel(
      content: replyCommentInput.text,
      url: profile.url,
      createAt: Timestamp.now(),
      username: profile.userName,
    );

    late Post updatePost;

    await post.doc(widget.postId).get().then((data) {
      updatePost = Post.fromJson(data.data());
      for (var element in updatePost.comments) {
        {
          if (element.id == widget.commentId) {
            element.listReply.add(response);
          }
        }
      }
    });

    await post.doc(widget.postId).update(updatePost.toJson());
    ScaffoldMessenger.of(context).showSnackBar(replyCommentSuccess);
    replyCommentInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.content,
            style: const TextStyle(fontSize: 11.0),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isPressCommentReply = !isPressCommentReply;
              });
            },
            child: const SizedBox(
              height: 20,
              width: 50,
              child: Text('Reply',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Color.fromARGB(255, 98, 170, 229))),
            ),
          ),
          const SizedBox(height: 5),
          isPressCommentReply == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: TextFormField(
                            controller: replyCommentInput,
                            decoration: const InputDecoration.collapsed(
                                hintText: 'type somthing...'),
                            style: const TextStyle(fontSize: 11.0)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
                          onTap: () {
                            replyComment();
                          },
                          child: const SizedBox(
                            child: Text('Send',
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color.fromARGB(255, 98, 170, 229))),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
