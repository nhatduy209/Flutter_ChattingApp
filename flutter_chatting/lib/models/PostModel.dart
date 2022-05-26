import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Post {
  List<String> canView;
  List<String> photos;
  List<CommentModel> comments;
  List<LikeModel> likes;
  PostOwner owner;
  String content;
  String video;
  dynamic createAt;
  String postId;

  Post({
    required this.canView,
    required this.comments,
    required this.likes,
    required this.owner,
    required this.photos,
    required this.content,
    required this.createAt,
    required this.video,
    required this.postId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<String> viewers = [];
    List<dynamic>.from(json['canView']).forEach((user) {
      viewers.add(user);
    });

    List<String> photos = [];
    List<dynamic>.from(json['photos']).forEach((photo) {
      photos.add(photo);
    });

    List<LikeModel> likes = [];
    List<dynamic>.from(json['likes']).forEach((like) {
      LikeModel likePost = LikeModel.fromJson((like));
      likes.add(likePost);
    });

    List<CommentModel> comments = [];
    List<dynamic>.from(json['comments']).forEach((comment) {
      CommentModel commentModel = CommentModel.fromJson((comment));
      comments.add(commentModel);
    });

    return Post(
        postId: json['postId'],
        photos: photos,
        canView: viewers,
        content: json['content'],
        likes: likes,
        comments: comments,
        owner: PostOwner.fromJson(json['owner']),
        video: json['video'],
        createAt: json['createAt']);
  }

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'content': content,
        'canView': canView,
        'photos': photos,
        'comments': comments,
        'likes': likes,
        'owner': owner.toJson(),
        'createAt': createAt,
        'video': video,
      };
}

class CommentModel {
  String content;
  Timestamp createAt;
  String username;
  String url;
  CommentModel(
      {required this.content,
      required this.createAt,
      required this.username,
      required this.url});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        content: json['content'],
        createAt: json['createAt'],
        username: json['username'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'createAt': createAt,
        'username': username,
        'url': url,
      };
}

class LikeModel {
  Timestamp createAt;
  String username;
  String url;

  LikeModel(
      {required this.createAt, required this.username, required this.url});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      createAt: json['createAt'],
      username: json['username'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createAt': createAt,
        'username': username,
        'url': url,
      };
}

class PostOwner {
  String username;
  String url;

  PostOwner({required this.username, required this.url});

  factory PostOwner.fromJson(Map<String, dynamic> json) {
    return PostOwner(username: json['username'], url: json['url']);
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'url': url,
      };
}
