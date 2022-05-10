// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ModalCreatePost extends StatefulWidget {
  const ModalCreatePost({Key? key}) : super(key: key);

  @override
  State<ModalCreatePost> createState() => _ModalCreatePostState();
}

class _ModalCreatePostState extends State<ModalCreatePost> {
  List<File> listImage = <File>[];
  TextEditingController contentPost = TextEditingController();

  // Widget _contentInput(context) {
  //   return BlocBuilder<HomePageBloc, HomePageState>(
  //       buildWhen: (previous, current) =>
  //           previous.contentPost != current.contentPost,
  //       builder: (context, state) {
  //         return TextFormField(
  //           textAlign: TextAlign.start,
  //           maxLines: 5,
  //           onChanged: (content) => context
  //               .read<HomePageBloc>()
  //               .add(HomePageOnContentChanged(content)),
  //           decoration: InputDecoration(
  //               // contentPadding: EdgeInsets.symmetric(
  //               //     vertical: MediaQuery.of(context).size.height / 4),
  //               border: const OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //               labelText: AppLocalizations.of(context)!.inputContentPost),
  //         );
  //       });
  // }

  Future<void> selectImage() async {
    PickedFile listPickedFiles =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (listPickedFiles.path.isNotEmpty) {
      setState(() {
        listImage.add(File(listPickedFiles.path));
      });
    }
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

  @override
  Widget build(BuildContext context) {
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
                    ])),
                _renderImage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF04764E))),
                      child: Text('Create'),
                      onPressed: () {
                        print('CONTENT =====' + contentPost.text);
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