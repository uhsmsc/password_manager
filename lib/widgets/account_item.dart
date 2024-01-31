import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pwd/models/account.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Account tapped: ${account.url}');
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: _buildIcon(account.iconUrl),
        ),
        title: Text(
          account.url,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        subtitle: Text(
          account.login,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildIcon(String iconUrl) {
    print(iconUrl);
    return Container(
      width: 55,
      height: 55,
      child: CachedNetworkImage(
        imageUrl: iconUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const CircularProgressIndicator(), // _generateAlternativeIcon(account.url),
        errorWidget: (context, url, error) =>
            _generateAlternativeIcon(account.url),
      ),
    );
  }

  Widget _generateAlternativeIcon(String text) {
    try {
      return Container(
        color: _generateRandomColor(),
        child: Center(
          child: Text(
            text.isNotEmpty ? text[0].toUpperCase() : '',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (error) {
      print('Error generating alternative icon: $error');
      return Container(); 
    }
  }

  Color _generateRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(1.0);
  }
}
