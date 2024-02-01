import 'package:flutter/material.dart';
import 'package:pwd/models/account.dart';

class NewAccountScreen extends StatelessWidget {
  NewAccountScreen({super.key, required this.onSave});

  final Function(Account) onSave;

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _urlController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'URL',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _loginController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'LOGIN/EMAIL',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                labelStyle: Theme.of(context).textTheme.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(25, 12, 25, 12)),
              onPressed: () {
                _saveAccount(context);
              },
              child: const Text('Save Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAccount(BuildContext context) {
    String url = _urlController.text;
    String login = _loginController.text;
    String password = _passwordController.text;

    if (url.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
      Account newAccount = Account(url: url, login: login, password: password);
      onSave(newAccount); 
      Navigator.pop(context); 
    } else {
      // Ошибка
    }
  }
}
