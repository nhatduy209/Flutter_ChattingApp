import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../../models/PostModel.dart';
import '../../../models/UserModel.dart';
import '../../../models/UserProfileProvider.dart';
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
  Future<dynamic> deleteComment(BuildContext context, CommentModel comment) async {
    await posts.doc(widget.postId)
    .update(
      {
        'comments': listComments.where((element) => element.content != comment.content && element.createAt != comment.createAt).toList()
      }
    ).then((value) => {
      Navigator.pop(context, 'OK'),
      reload()
    });
  }
  Widget OptionPopup(CommentModel comment) {
    return Container(
            height: 50,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.black87
            ),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => {
                Navigator.pop(context),
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete confirm form'),
                    content: const Text('Do you want to delete this comment?'),
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
              child: Text('Delete', style: TextStyle(fontSize: 24, color: Colors.white),))
            );
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
                trailing: Text(
                  Jiffy(
                    listComments[index].createAt.toDate().toString(),
                  ).fromNow(),
                  style: const TextStyle(fontSize: 11.0),
                ),
                onTap: () => {
                  listComments[index].username == profile.userName ?
                  showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                        builder: (BuildContext context) {
                          return OptionPopup(listComments[index]);
                        },
                      ) : print('hong bé ơi')
                },
              ),
            ));
          },
        );
      }
    );
  }
}
