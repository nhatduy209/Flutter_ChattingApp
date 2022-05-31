import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:provider/provider.dart';

import '../../../models/PostModel.dart';
import '../../../models/UserModel.dart';
import '../../../models/UserProfileProvider.dart';

class CommentInput extends StatelessWidget {
  final String postId;
  final int index;

  var comments = [];
  CommentModel cmt = CommentModel(
      content: '',
      createAt: Timestamp.now(),
      username: '',
      url: '',
      listReply: [],
      id: '');
  CommentInput({Key? key, required this.postId, required this.index})
      : super(key: key);
  CollectionReference post = FirebaseFirestore.instance.collection('post');
  final commentInput = TextEditingController();
  Future reloadPost(context, comment) async {
    ListPostProvider listPostProvider =
        Provider.of<ListPostProvider>(context, listen: false);
    listPostProvider.addComment(comment, index);
  }

  Future comment(BuildContext context) async {
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;
    ListPostProvider listPostProvider =
        Provider.of<ListPostProvider>(context, listen: false);
    await post.get().then((data) => {
          for (DocumentSnapshot ds in data.docs)
            {
              comments = [],
              if (ds.id == postId)
                {
                  cmt = CommentModel(
                      content: commentInput.text,
                      url: profile.url,
                      createAt: Timestamp.now(),
                      username: profile.userName,
                      listReply: [],
                      id: DateTime.now().millisecondsSinceEpoch.toString()),
                  comments = ds.data()['comments'],
                  comments.add({
                    'content': commentInput.text,
                    'url': profile.url,
                    'createAt': Timestamp.now(),
                    'username': profile.userName,
                    'reply': [],
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  }),
                  reloadPost(context, cmt),
                  ds.reference.update({'comments': comments}).then(
                      (value) => listPostProvider.setEditedPostId(ds.id))
                }
            }
        });
    commentInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 50),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 60,
            width: MediaQuery.of(context).size.width - 70,
            child: TextFormField(
              controller: commentInput,
              // onChanged: (comment) => {commentInput.text = comment},
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'add comment...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, size: 30.0),
            color: const Color(0xFF000000),
            onPressed: () async => {comment(context)},
          ),
        ],
      ),
    );
  }
}
