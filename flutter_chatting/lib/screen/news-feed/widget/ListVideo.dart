import 'dart:html';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class _ListVideo extends StatelessWidget {
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  _ListVideo(this.videos);
  final String videos;

  @override
  Widget build(BuildContext context) {
    if (videos.isNotEmpty) {
      _videoPlayerController = VideoPlayerController.network(videos);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
    }

    // TODO: implement build
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
