import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive/hive.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/screens/account_details.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account, required this.accountBox});

  final Account account;
  final Box<Account> accountBox;

  void _openAccountDetails(BuildContext context, Account account) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AccountDetailsScreen(
          account: account,
          accountBox: accountBox,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openAccountDetails(context, account);
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: _buildIcon(account.iconUrl),
        ),
        title: Text(
          account.url,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, height: 1),
        ),
        subtitle: Text(
          account.login,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildIcon(String iconUrl) {
    return SizedBox(
      width: 55,
      height: 55,
      child: CachedNetworkImage(
        imageUrl: iconUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const CircularProgressIndicator(),
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
            style: const TextStyle(color: Colors.white),
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