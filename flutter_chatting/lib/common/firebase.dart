import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<List<String>> uploadImageToFirebase(List<File> listImage) async {
  List<String> listImageUri = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  if (listImage.isEmpty) {
    return [];
  } else {
    return await Future.wait(listImage.map((element) async {
      String destination = 'message/${basename(element.path)}';
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(element);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .getDownloadURL();
      listImageUri.add(downloadURL);
    })).then((value) => listImageUri).onError((error, stackTrace) => []);
  }
}

Future<String> uploadVideoToFirebase(File video) async {
  String videoUri = "";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  try {
    if (video.path.isEmpty) {
      return videoUri;
    } else {
      String destination = 'message/${basename(video.path)}';
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(video);
      videoUri = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .getDownloadURL();

      return videoUri;
    }
  } catch (err) {
    print('Error when uploading video' + err.toString());
    return videoUri;
  }
}

Future<String> getImageFromFirebase(String imageStoragePath) async {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  print('IMAGE PATH === $imageStoragePath');
  if (imageStoragePath.isEmpty) {
    return "";
  } else {
    try {
      print('IMAGE PATH === $imageStoragePath');
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(imageStoragePath)
          .getDownloadURL();
      print('DOWNLOADED URL ---------------------- $downloadURL');
      return downloadURL;
    } catch (err) {
      print('ERR WHEN GETTING IMAGE $err');
      return "";
    }
  }
}

Future makeOnline(String username, String token) async {
  print('TOKEN GET ----' + token);
  QuerySnapshot accounts = await FirebaseFirestore.instance
      .collection('account')
      .where('username', isEqualTo: username)
      .get();

  accounts.docs[0].reference.update({'isOnline': true});
  accounts.docs[0].reference.update({'token': token});
}

Future<void> deleteAPI(String collection, String documentDelete) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .get()
      .then((querySnapshot) => {
            for (var doc in querySnapshot.docs)
              if (doc.id == documentDelete) {doc.reference.delete()}
          });
}
