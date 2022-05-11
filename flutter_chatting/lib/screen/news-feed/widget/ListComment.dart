import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class ListComments extends StatelessWidget {
  int indexComment;
  ListComments(this.indexComment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listPostProvider = Provider.of<ListPostProvider>(context);
    print('COMMENT -----' +
        listPostProvider.getListPosts[indexComment].comments.length.toString());
    return (ListView.builder(
      shrinkWrap: true,
      itemCount: listPostProvider
          .getListPosts[indexComment].comments.length, // list comments in posts
      itemBuilder: (BuildContext context, int index) {
        return (Container(
          padding:
              const EdgeInsets.only(left: 20, right: 10, top: 5, bottom: 5),
          child: ListTile(
            title: Text(
              listPostProvider
                  .getListPosts[indexComment].comments[index].username,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              listPostProvider
                  .getListPosts[indexComment].comments[index].content,
              style: const TextStyle(fontSize: 11.0),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                listPostProvider.getListPosts[indexComment].comments[index].url,
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
    ));
  }
}
