class Utilities {
  String getUserChatting({idChatting = String, username = String}) {
    var name = idChatting.toString().split('_');
    if (name[0].toString().contains(username)) {
      return name[1];
    } else {
      return name[0];
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
