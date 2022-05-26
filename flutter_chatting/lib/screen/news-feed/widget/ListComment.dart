import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../../models/PostModel.dart';
class ListComments extends StatefulWidget {
  final String postId;
  // int numberOfLikes;
  ListComments({
    Key? key,
    required this.postId,
    //required this.numberOfLikes,
  }) : super(key: key);

  @override
  ListCommentsState createState() => ListCommentsState();
}

class ListCommentsState extends State<ListComments> {
  List<CommentModel> listComments = [];
  CollectionReference posts = FirebaseFirestore.instance.collection('post');
  late bool firstReload = true;

  Future<dynamic> reload() async {
    final List<CommentModel> list = [];
          await posts.get().then((data) => {
            for(var post in data.docs) {
              if (post.id == widget.postId) {
                for(var comment in post.data()['comments']) {
                  list.add(CommentModel(content: comment['content'], createAt: comment['createAt'], username: comment['username'], url: comment['url']))
                }
              }
            },
            setState(() {
                  listComments = list;
                })
          });
  }

  Future<dynamic> getListComments(
      {BuildContext? context}) async {
        await reload();
        // ListPostProvider listPostProvider = Provider.of<ListPostProvider>(context!, listen: false);
        // if(widget.postId == listPostProvider.editedPostId || firstReload) {
        //   if(firstReload) {
        //     await reload();
        //     firstReload = false;
        //     return;
        //   }
        //   await reload();
        //   listPostProvider.setEditedPostId('');
        // }
      }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getListComments(context: context),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: listComments.length, // list comments in posts
          itemBuilder: (BuildContext context, int index) {
            return (Container(
              padding:
                  const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
              child: ListTile(
                title: Text(
                  listComments[index].username,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  listComments[index].content,
                  style: const TextStyle(fontSize: 11.0),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    listComments[index].url,
                  ),
                ),
                // trailing: Text(
                //   Jiffy(
                //     listPostProvider
                //         .getListPosts[indexComment].comments[index].createAt,
                //   ).fromNow(),
                //   style: const TextStyle(fontSize: 11.0),
                // ),
              ),
            ));
          },
        );
      }
    );
  }
}
