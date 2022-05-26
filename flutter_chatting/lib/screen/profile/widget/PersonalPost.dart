import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/assets/component/Flushbar.dart';
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

class PersonalPost extends StatefulWidget {
  const PersonalPost({Key? key}) : super(key: key);

  @override
  PersonalPostState createState() => PersonalPostState();
}

class PersonalPostState extends State<PersonalPost> {
  LOAD_POST loadingPost = LOAD_POST.none;
  bool reload = false;
  String selecton = '';
  ListPostProvider listPostProvider = ListPostProvider();

  CollectionReference posts = FirebaseFirestore.instance.collection('post');
  Future<bool> getListPost(ListPostProvider listPostProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');

    if (listPostProvider.getListPersonalPosts.isEmpty || reload == true) {
      if (reload) {
        listPostProvider.reloadPost();
      }
      await posts
          .orderBy('createAt', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          var post = Post.fromJson(doc.data());

          if (post.owner.username == username &&
              listPostProvider.checkExistPersonalPost(post) == false) {
            listPostProvider.addPersonalPost(post);
          }
        }
        setState(() => reload = false);

        return true;
      }).catchError((err) {
        print('Error getting personal post --- ' + err.toString());
        return false;
      });
    }
    return false;
  }

  int convertTimeStamp(dynamic timeStamp) {
    var time = timeStamp as Timestamp;

    return time.millisecondsSinceEpoch * 1000;
  }

  Future<void> handlePost(selection, Post post) async {
    switch (selection) {
      case 'delete':
        listPostProvider.removePersonalPost(post);
        ScaffoldMessenger.of(context).showSnackBar(deletePost);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    listPostProvider = Provider.of<ListPostProvider>(context, listen: true);
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
              itemCount: listPostProvider.getListPersonalPosts.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(
                              listPostProvider
                                  .getListPersonalPosts[index].owner.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: DropdownButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: const Color(0xFF000000),
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onChanged: (String? val) {
                                handlePost(
                                    val,
                                    listPostProvider
                                        .getListPersonalPosts[index]);
                              },
                              items: <String>[
                                'delete',
                                'edit'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/flutter-chatting-c8c87.appspot.com/o/message%2Fscaled_image_picker2688855893894157660.jpg?alt=media&token=0d45b817-1b49-49d7-b6e3-cd46523c0eb1"),
                            ),
                            subtitle: Text(Jiffy(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        convertTimeStamp(listPostProvider
                                            .getListPersonalPosts[index]
                                            .createAt)))
                                .fromNow())),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              listPostProvider
                                  .getListPersonalPosts[index].content,
                            ),
                          ),
                        ),
                        listPostProvider
                                .getListPersonalPosts[index].photos.isNotEmpty
                            ? _ListPhoto(listPostProvider
                                .getListPersonalPosts[index].photos)
                            : Container(),
                        const SizedBox(height: 10),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                        ),
                        ActionLikeShareComment(
                            content: listPostProvider
                                .getListPersonalPosts[index].content,
                            photos: listPostProvider
                                .getListPersonalPosts[index].photos),
                        listPostProvider
                                .getListPersonalPosts[index].comments.isNotEmpty
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