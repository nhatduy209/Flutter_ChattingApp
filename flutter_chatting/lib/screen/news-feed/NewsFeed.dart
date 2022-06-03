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
import 'package:video_player/video_player.dart';

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
      if (reload == true) {
        listPostProvider.reloadPost();
      }
      await posts
          .orderBy('createAt', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        for (var doc in querySnapshot.docs) {
          var p = doc.data();
          p['postId'] = doc.id;
          Post post = Post.fromJson(p);

          for (var element in post.canView) {
            if ((element == username || post.owner.username == username) &&
                listPostProvider.checkExist(post) == false) {
              listPostProvider.add(post);
            }
          }
        }
        setState(() => reload = false);
        //  setState(() => loadingPost = LOAD_POST.success);
        return true;
      }).catchError((err) {
        print('Error getting post --- ' + err.toString());
        return false;
      });
    }
    return false;
  }

  int convertTimeStamp(dynamic timeStamp) {
    var time = timeStamp as Timestamp;

    return time.millisecondsSinceEpoch * 1000;
  }

  @override
  Widget build(BuildContext context) {
    var listPostProvider = Provider.of<ListPostProvider>(context, listen: true);

    print('LIST POST ---' + listPostProvider.getListPosts.length.toString());
    return FutureBuilder(
      future: getListPost(listPostProvider),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData == true) {
          return RefreshIndicator(
            onRefresh: () async {
              reload = true;
              getListPost(listPostProvider);
            },
            child: listPostProvider.getListPosts.isNotEmpty
                ? ListView.builder(
                    itemCount: listPostProvider.getListPosts.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                  title: Text(
                                    listPostProvider
                                        .getListPosts[index].owner.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        listPostProvider
                                            .getListPosts[index].owner.url),
                                  ),
                                  subtitle: Text(Jiffy(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              convertTimeStamp(listPostProvider
                                                  .getListPosts[index]
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
                                        .getListPosts[index].content,
                                  ),
                                ),
                              ),
                              listPostProvider
                                      .getListPosts[index].photos.isNotEmpty
                                  ? _ListPhoto(listPostProvider
                                      .getListPosts[index].photos)
                                  : Container(),
                              const SizedBox(height: 10),
                              listPostProvider
                                      .getListPosts[index].video.isNotEmpty
                                  ? _ListVideo(listPostProvider
                                      .getListPosts[index].video)
                                  : Container(),
                              const SizedBox(height: 10),
                              const Divider(),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                              ),
                              ActionLikeShareComment(
                                  index: index,
                                  postId: listPostProvider
                                      .getListPosts[index].postId,
                                  content: listPostProvider
                                      .getListPosts[index].content,
                                  photos: listPostProvider
                                      .getListPosts[index].photos),
                              listPostProvider
                                      .getListPosts[index].comments.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: ListComments(
                                          postId: listPostProvider
                                              .getListPosts[index].postId),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('You haven\'t posted any things... ')),
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

class _ListVideo extends StatelessWidget {
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  _ListVideo(this.videos);
  final String videos;

  @override
  Widget build(BuildContext context) {
    print('Video ----' + videos);
    if (videos.isNotEmpty) {
      _videoPlayerController = VideoPlayerController.network(videos);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    }

    return SizedBox(
      height: 200,
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          height: 200,
          width: 200,
          margin: const EdgeInsets.only(right: 7),
          child: InkWell(
            onTap: () => {_videoPlayerController!.play()},
            child: VideoPlayer(_videoPlayerController!),
          ),
        ),
      ),
    );
  }
}
