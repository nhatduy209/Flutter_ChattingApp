class Utilities {
  String getUserChatting({idChatting = String, username = String}) {
    if (idChatting.toString().indexOf(username) == 0) {
      return idChatting.toString().substring(username.toString().length + 1);
    } else {
      return idChatting.toString().substring(0, username.toString().length + 2);
    }
  }

  dynamic emailRule(String input, [String message = 'invalid email']) {
    var reg = RegExp(r'/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/');
    
    return {
      'value': reg.firstMatch(input),
      'message' : message
    };
  }
}
