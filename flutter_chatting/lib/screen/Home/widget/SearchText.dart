import 'package:flutter/material.dart';
import 'package:flutter_chatting/models/ListBubbeMessageProvider.dart';
import 'package:provider/provider.dart';

class SearchText extends StatefulWidget {
  const SearchText({Key? key}) : super(key: key);

  @override
  @override
  State<StatefulWidget> createState() => SearchTextState();
}

class SearchTextState extends State<SearchText> {
  final _searchController = TextEditingController();

  Future<void> search(
    String username,
    ListUserModel listUsers,
  ) async {
    listUsers.search(username);
  }

  @override
  Widget build(BuildContext context) {
    var listUsers = Provider.of<ListUserModel>(context);
    // TODO: implement build
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: () {
            search(_searchController.text, listUsers);
          },
          icon: const Icon(Icons.search),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            _searchController.clear();
          },
          icon: const Icon(Icons.clear),
        ),
        hintText: "Friends...",
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
