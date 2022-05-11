import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  //final String postID;
  //const CommentInput({Key? key, required this.postID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 50),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            height: 60,
            width: MediaQuery.of(context).size.width - 70,
            child: TextFormField(
              onChanged: (comment) => {},
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  hintText: 'add comment...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_right, size: 30.0),
            color: const Color(0xFF000000),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
