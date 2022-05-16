import 'dart:convert';

import 'package:http/http.dart';

String url = "https://nodejs-cars.herokuapp.com";

Future<void> pushNotification(tokenReciver, sender, message) async {
  Map<String, String> headers = {"Content-type": "application/json"};

  Map<String, dynamic> body = {
    'sender': sender,
    'message': message,
    "token": tokenReciver
  };
  String jsonBody = jsonEncode(body);

  // tạo POST request
  dynamic response = await post("${url}/chatting/sendMessage",
      headers: headers, body: jsonBody);
}
