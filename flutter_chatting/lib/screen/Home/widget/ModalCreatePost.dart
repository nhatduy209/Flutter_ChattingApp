// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting/common/firebase.dart';
import 'package:flutter_chatting/models/ListPostProvider.dart';
import 'package:flutter_chatting/models/PostModel.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../../../models/UserModel.dart';
import '../../../models/UserProfileProvider.dart';

class ModalCreatePost extends StatefulWidget {
  const ModalCreatePost({Key? key}) : super(key: key);

  @override
  State<ModalCreatePost> createState() => _ModalCreatePostState();
}

class _ModalCreatePostState extends State<ModalCreatePost> {
  List<File> listImage = <File>[];
  List<File> videoPath = <File>[];
  TextEditingController contentPost = TextEditingController();

  Future<void> selectImage() async {
    PickedFile listPickedFiles =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (listPickedFiles.path.isNotEmpty) {
      setState(() {
        listImage.add(File(listPickedFiles.path));
      });
    }
  }

  Future<void> selectVideo() async {
    PickedFile listPickedFiles =
        await ImagePicker().getVideo(source: ImageSource.gallery);

    if (listPickedFiles.path.isNotEmpty) {
      print('PATH VIDEO --- ' + listPickedFiles.path);
      setState(() {
        videoPath.add(File(listPickedFiles.path));
      });
    }
  }

  Future<void> handleAddPost(String text, List<File> listImage,
      ListPostProvider listPostProvider, BuildContext context) async {
    String videoUploadUri = "";

    CollectionReference post = FirebaseFirestore.instance.collection('post');
    User profile = Provider.of<UserProfile>(context, listen: false).userProfile;

    PostOwner owner = PostOwner(url: profile.url, username: profile.userName);
    List<String> listImageUrl = [];
    if (listImage.isNotEmpty) {
      listImageUrl = await uploadImageToFirebase(listImage);
    }

    if (videoPath.isNotEmpty) {
      videoUploadUri = await uploadVideoToFirebase(videoPath[0]);
    }

    Post newPost = Post(
        postId: '',
        content: text,
        canView: [profile.userName],
        likes: [],
        comments: [],
        photos: listImageUrl,
        owner: owner,
        createAt: Timestamp.fromDate(DateTime.now()),
        video: videoUploadUri);

    post.add(newPost.toJson());
    listPostProvider.handleAddPost(newPost);
    Navigator.pop(context);
  }

  Widget _renderImage() {
    return listImage.isNotEmpty
        ? SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: listImage.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: const EdgeInsets.only(right: 7),
                    child: InkWell(
                        onTap: () => {
                              setState(
                                  () => {listImage.remove(listImage[index])})
                            },
                        child: Image.file(File(listImage[index].path),
                            width: 200, height: 200)));
              },
            ))
        : Container();
  }

  Widget _renderVideo(context) {
    VideoPlayerController? _videoPlayerController;
    Future<void> _initializeVideoPlayerFuture;

    if (videoPath.isNotEmpty) {
      _videoPlayerController =
          VideoPlayerController.file(File(videoPath[0].path));
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    }

    return videoPath.isNotEmpty
        ? SizedBox(
            height: 200,
            child: Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.only(right: 7),
                child: InkWell(
                    onTap: () => {_videoPlayerController!.play()},
                    child: VideoPlayer(_videoPlayerController!))))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    ListPostProvider listPostProvider =
        Provider.of<ListPostProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20),
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Add new post', style: const TextStyle(fontSize: 25)),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  maxLines: 5,
                  controller: contentPost,
                  decoration: const InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(
                      //     vertical: MediaQuery.of(context).size.height / 4),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      labelText: 'Share what your think...'),
                ),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(children: [
                      IconButton(
                          iconSize: 30.0,
                          icon: const Icon(Icons.photo),
                          color: const Color(0xFF04764E),
                          onPressed: () {
                            selectImage();
                          }),
                      IconButton(
                          iconSize: 30.0,
                          icon: const Icon(Icons.switch_video),
                          color: const Color(0xFF04764E),
                          onPressed: () {
                            selectVideo();
                          })
                    ])),
                _renderImage(),
                const SizedBox(
                  height: 5,
                ),
                _renderVideo(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF04764E))),
                      child: Text('Create'),
                      onPressed: () {
                        handleAddPost(contentPost.text, listImage,
                            listPostProvider, context);
                      },
                    ),
                    ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF000000)))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
