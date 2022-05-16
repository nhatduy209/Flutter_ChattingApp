import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatting/screen/news-feed/widget/CommentInput.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ActionLikeShareComment extends StatefulWidget {
  final String postId;
  final String content;
  // int numberOfLikes;
  List<String>? photos;
  ActionLikeShareComment({
    Key? key,
    required this.postId,
    //required this.numberOfLikes,
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
              _ThumbUpButton(),
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
                )
            : Container(),
      ],
    );
  }
}

class _ThumbUpButton extends StatefulWidget {
  // String postId;
  // int numberOfLikes;
  // _ThumbUpButton({Key? key, required this.postId, required this.numberOfLikes})
  //     : super(key: key);

  @override
  _ThumbUpButtonState createState() => _ThumbUpButtonState();
}

class _ThumbUpButtonState extends State<_ThumbUpButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return TextButton(
      onPressed: () async {
        //  context.read<ActionBloc>().add(ActionLikePost(widget.postId));
      },
      child: Row(
        children: const [
          Icon(Icons.thumb_up, color: Color(0xFF04764E), size: 25.0),
          SizedBox(width: 5),
          // Text(widget.numberOfLikes.toString()),
          Text('1'),
          SizedBox(width: 10),
          Text('Like'),
        ],
      ),
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
      print(' Res ---' + response.body);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/$photo';
      print(' list image ---' + path);

      paths.add(path);

      File(path).writeAsBytesSync(bytes);
    }

    return paths;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextButton(
      //  '/data/user/0/com.lengineer.lecongressman/cache/scaled_image_picker2961409313100381031.jpg'
      onPressed: () async {
        if (photos!.isNotEmpty) {
          List<String> listPath = await getPathFromUrl(photos!);
          Share.shareFiles(listPath, subject: content, text: content);
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
