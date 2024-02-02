import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Account {
  Account({
    required this.url,
    required this.login,
    required this.password,
    }) : id = uuid.v4(), iconUrl = 'https://icons.bitwarden.net/$url/icon.png';

  String id;
  String url;
  String login;
  String password;
  String iconUrl;
} 