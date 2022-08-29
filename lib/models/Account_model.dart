class Account {
  final String username;
  final String password; 
  final String webId;

  Account(this.username, this.password, this.webId);

  toJson(Account account){
    return {
      "username" : account.username,
      "password" : account.password,
      "webId" : account.webId,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      json["username"], 
      json["password"], 
      json["webId"] 
    );
  }

  @override
  String toString() {
    return "username = $username, password = $password, webId = $webId ";
  }
}