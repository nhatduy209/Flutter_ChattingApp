import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/BubleMessageModel.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SlideBar extends StatelessWidget {
  const SlideBar(this.component, this.username, {Key? key}) : super(key: key);

  final BubbleMessage username;
  final Widget component;

  @override
  Widget build(BuildContext context) {
    var listUsers = Provider.of<ListUserModel>(context);
    // TODO: implement build
    return Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext context) {
                listUsers.removeUser(username);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: component);
  }
}
