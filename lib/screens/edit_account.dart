import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pwd/models/account.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({
    Key? key,
    required this.account,
    required this.onSave,
    required this.accountBox,
  }) : super(key: key);

  final Account account;
  final Function(Account) onSave;
  final Box<Account> accountBox;

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _urlController;
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  late Box<Account> _accountBox;

  @override
  void initState() {
    super.initState();
    _accountBox = widget.accountBox; // Assigning the value from widget.accountBox
    _urlController = TextEditingController(text: widget.account.url);
    _loginController = TextEditingController(text: widget.account.login);
    _passwordController = TextEditingController(text: widget.account.password);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать аккаунт'),
        actions: [
          IconButton(
            onPressed: () => _saveAccount(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('URL'),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Введите URL',
              ),
            ),
            const SizedBox(height: 20),
            Text('LOGIN/EMAIL'),
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                hintText: 'Введите логин или email',
              ),
            ),
            const SizedBox(height: 20),
            Text('PASSWORD'),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Введите пароль',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAccount() {
    final updatedAccount = Account(
      id: widget.account.id,
      url: _urlController.text,
      login: _loginController.text,
      password: _passwordController.text,
      iv: widget.account.iv,
    );

    _accountBox.put(updatedAccount.key, updatedAccount); // Using _accountBox here
    Navigator.pop(context, updatedAccount); // Передаем обновленный аккаунт на экран AccountDetailsScreen
  }
}
