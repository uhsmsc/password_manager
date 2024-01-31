import 'package:flutter/material.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/screens/new_account.dart';
import 'package:pwd/widgets/account_item.dart';

class AccountsListScreen extends StatefulWidget {
  const AccountsListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountsListScreenState();
  }
}

class _AccountsListScreenState extends State<AccountsListScreen> {
  final List<Account> accounts = [];

  void _openAddAccount(BuildContext context) async {
    final newAccount = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewAccountScreen(
          onSave: _saveAccount,
        ),
      ),
    );

    if (newAccount != null && newAccount is Account) {
      setState(() {
        accounts.add(newAccount);
      });
    }
  }

  void _saveAccount(Account newAccount) {
    setState(() {
      accounts.add(newAccount);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Uh oh... nothing here!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 13),
          Text(
            'Add new account',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );

    if (accounts.isNotEmpty) {
      content = ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (ctx, index) => AccountItem(account: accounts[index]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            print('Settings button tapped');
          },
          icon: const Icon(Icons.settings_outlined),
          iconSize: 30,
          color: const Color.fromARGB(255, 218, 218, 218),
        ),
        centerTitle: true,
        title: const Text('Accounts List'),
        actions: [
          IconButton(
            onPressed: () => _openAddAccount(context),
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 30,
            color: const Color.fromARGB(255, 218, 218, 218),
          ),
        ],
      ),
      body: content,
    );
  }
}
