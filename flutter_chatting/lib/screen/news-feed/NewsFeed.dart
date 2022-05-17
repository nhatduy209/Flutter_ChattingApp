import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:flutter_chatting/models/PostModel.dart';
import 'package:flutter_chatting/screen/news-feed/ActionLikeShareComment.dart';
import 'package:flutter_chatting/screen/news-feed/widget/ListComment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LOAD_POST {
  none,
  fail,
  success,
}

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  NewsFeedState createState() => NewsFeedState();
}

class NewsFeedState extends State<NewsFeed> {
  LOAD_POST loadingPost = LOAD_POST.none;
  bool reload = false;
  //List<Post> listPostProvider.getListPosts = [];
  CollectionReference posts = FirebaseFirestore.instance.collection('post');

  Future<bool> getListPost(ListPostProvider listPostProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');

    if (listPostProvider.getListPosts.isEmpty || reload == true) {
      await posts.get().then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          var post = Post.fromJson(doc.data());

          for (var element in post.canView) {
            if (element == username) {
              listPostProvider.add(post);
            }
          }
        }
        setState(() => reload = false);
        //  setState(() => loadingPost = LOAD_POST.success);
        return true;
      }).catchError((err) {
        return false;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var listPostProvider = Provider.of<ListPostProvider>(context);

    return FutureBuilder(
      future: getListPost(listPostProvider),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData == true) {
          return RefreshIndicator(
            onRefresh: () async {
              reload = true;
              getListPost(listPostProvider);
            },
            child: ListView.builder(
              itemCount: listPostProvider.getListPosts.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            listPostProvider.getListPosts[index].owner.username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // subtitle: Text(
                          //   Jiffy(posts.state.listPosts[index].createdAt)
                          //       .fromNow(),
                          //   style: const TextStyle(fontSize: 11.0),
                          // ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/flutter-chatting-c8c87.appspot.com/o/message%2Fscaled_image_picker2688855893894157660.jpg?alt=media&token=0d45b817-1b49-49d7-b6e3-cd46523c0eb1"),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              listPostProvider.getListPosts[index].content,
                            ),
                          ),
                        ),
                        listPostProvider.getListPosts[index].photos.isNotEmpty
                            ? _ListPhoto(
                                listPostProvider.getListPosts[index].photos)
                            : Container(),
                        const SizedBox(height: 10),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                        ),
                        ActionLikeShareComment(
                            content:
                                listPostProvider.getListPosts[index].content,
                            photos:
                                listPostProvider.getListPosts[index].photos),
                        listPostProvider.getListPosts[index].comments.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: ListComments(index),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Align(child: Text('Loading post.....'));
        }
      },
    );
  }
}

class _ListPhoto extends StatelessWidget {
  const _ListPhoto(this.photos);
  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Image.network(photos[index]),
          );
        },
      ),
    );
  }
}
