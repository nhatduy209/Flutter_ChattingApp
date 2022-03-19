import 'package:flutter/material.dart';

import '../models/Message.dart';

// class RenderMessage extends StatefulWidget {
//   @override
//   final bool renderOnTheLeft;

//   @override
//   final Message message;

//   RenderMessage({
//     required bool renderOnTheLeft,
//     required Message message,
//   })  : this.renderOnTheLeft = renderOnTheLeft,
//         this.message = message;

//   @override
//   MessageState createState() => MessageState(renderOnTheLeft, message);
// }

class RenderMessage extends StatelessWidget {
  bool isPress = false;
  bool renderOnTheLeft;
  Message message;

  RenderMessage({
    required bool renderOnTheLeft,
    required Message message,
  })  : this.renderOnTheLeft = renderOnTheLeft,
        this.message = message;
  @override
  String convertDateTime(DateTime dateTime) {
    String hourToString = "";
    String minuteToString = "";

    if (dateTime.hour < 10) {
      hourToString = '0' + dateTime.hour.toString();
    } else {
      hourToString = dateTime.hour.toString();
    }

    if (dateTime.minute < 10) {
      minuteToString = '0' + dateTime.minute.toString();
    } else {
      minuteToString = dateTime.minute.toString();
    }

    return '$hourToString:$minuteToString';
  }

  @override
  Widget build(BuildContext context) {
    String dateTime = convertDateTime(message.time);
    // TODO: implement build
    return renderOnTheLeft == true
        ? Container(
            width: 200,
            margin: const EdgeInsets.only(top: 5, left: 100),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.content,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    Text(
                      dateTime,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )))
        : Container(
            width: 200,
            margin: const EdgeInsets.only(top: 5, right: 100),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 5),
                    Text(
                      dateTime,
                      textAlign: TextAlign.right,
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[100],
                      ),
                    )
                  ],
                )
                // Text(
                //   message.content,
                //   textAlign: TextAlign.right,
                // ),
                ));
  }
}
