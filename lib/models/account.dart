import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String url;

  @HiveField(2)
  late String login;

  @HiveField(3)
  late String password;

  @HiveField(4)
  late String iconUrl;

  @HiveField(5)
  late String iv;

  Account({
    required this.id,
    required this.url,
    required this.login,
    required this.password,
    required this.iv,
  }) : iconUrl = 'https://icons.bitwarden.net/$url/icon.png';
}