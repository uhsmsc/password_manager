import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/screens/new_account.dart';
import 'package:pwd/widgets/account_item.dart';

class AccountsListScreen extends StatefulWidget {
  final Box<Account> accountBox;

  const AccountsListScreen({super.key, required this.accountBox});

  @override
  State<StatefulWidget> createState() {
    return _AccountsListScreenState();
  }
}

class _AccountsListScreenState extends State<AccountsListScreen> {
  late Box<Account> _accountBox;

  @override
  void initState() {
    super.initState();
    _accountBox = widget.accountBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined),
          iconSize: 30,
          color: const Color.fromARGB(255, 218, 218, 218),
        ),
        centerTitle: true,
        title: const Text('Аккаунты'),
        actions: [
          IconButton(
            onPressed: () => _openAddAccount(context),
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 30,
            color: const Color.fromARGB(255, 218, 218, 218),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _accountBox.listenable(),
        builder: (context, Box<Account> box, _) {
          final accounts = box.values.toList();

          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Хранилище пустое...',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 23,
                        ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    'Добавь свой первый аккаунт!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
              itemCount: accounts.length,
              itemBuilder: (ctx, index) =>
                  AccountItem(account: accounts[index]),
            );
          }
        },
      ),
    );
  }

  void _openAddAccount(BuildContext context) async {
    final newAccount = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewAccountScreen(
          onSave: _saveAccount,
        ),
      ),
    );

    if (newAccount != null && newAccount is Account) {
      _saveAccount(newAccount);
    }
  }

  void _saveAccount(Account newAccount) {
    _accountBox.add(newAccount);
  }
}