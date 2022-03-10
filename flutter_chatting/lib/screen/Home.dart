import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 33.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.reorder, size: 30.0), onPressed: () => {}),
                Text(
                  'Chatty',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
                IconButton(
                    icon: Icon(Icons.camera_alt, size: 30.0),
                    onPressed: () => {}),
              ])),
      ComponentButton(text: "Button1 "),
      ComponentButton(text: "Button2 ")
    ]));
  }
}

class ComponentButton extends StatefulWidget {
  @override
  final String
      text; // <--- generates the error, "Field doesn't override an inherited getter or setter"
  ComponentButton({required String text}) : this.text = text;

  ComponentButtonState createState() => new ComponentButtonState(text);
}

class ComponentButtonState extends State<ComponentButton> {
  ComponentButtonState(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
