import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/MessageModel.dart';

class RenderMessage extends StatelessWidget {
  bool isPress = false;
  bool renderOnTheLeft;
  Message message;
  List<Message> listMessage;
  RenderMessage({
    required bool renderOnTheLeft,
    required Message message,
    required List<Message> listMessage,
  })  : this.renderOnTheLeft = renderOnTheLeft,
        this.message = message,
        this.listMessage = listMessage;
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

  dynamic findIndex(Message mess) {
    // Find the index of person. If not found, index = -1
    final index = listMessage.indexWhere((element) => element.id == mess.id);

    if (index > 0) {
      final difference = listMessage[index]
          .time
          .difference(listMessage[index - 1].time)
          .inDays;

      if (difference > 0) {
        //return (Text('${mess.time.day}/${mess.time.month}' , ));
        return (Container(
            width: 100,
            margin: const EdgeInsets.only(top: 7.0, bottom: 7),
            child: (Text(
                '${mess.time.day}/${mess.time.month}, ${DateFormat('EEEE').format(mess.time)}',
                style: TextStyle(color: Color.fromARGB(255, 93, 95, 226)),
                textAlign: TextAlign.center))));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateTime = convertDateTime(message.time);
    // TODO: implement build
    return renderOnTheLeft == true
        ? Column(children: [
            findIndex(message),
            Container(
                width: 300,
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
                        message.content.contains(
                                'https://firebasestorage.googleapis.com/')
                            ? Image.network(message.content)
                            : Text(
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
          ])
        : Column(
            children: [
              findIndex(message),
              Container(
                  width: 300,
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
                          message.content.contains(
                                  'https://firebasestorage.googleapis.com/')
                              ? Image.network(message.content,
                                  width: 100, height: 100)
                              : Text(
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
                      )))
            ],
          );
  }
}
