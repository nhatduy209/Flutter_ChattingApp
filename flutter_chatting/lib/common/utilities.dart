class Utilities {
  String getUserChatting({idChatting = String, username = String}) {
    if (idChatting.toString().indexOf(username) == 0) {
      return idChatting.toString().substring(username.toString().length + 1);
    } else {
      return idChatting.toString().substring(0, username.toString().length + 2);
    }
  }
}
