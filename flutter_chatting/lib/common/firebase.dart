import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<List<String>> uploadImageToFirebase(List<File> listImage) async {
  List<String> listImageUri = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  if (listImage.isEmpty)
    return [];
  else {
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

Future<String> getImageFromFirebase(String imageStoragePath) async {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  print('IMAGE PATH === $imageStoragePath');
  if (imageStoragePath.isEmpty)
    return "";
  else {
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
