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
            _buildTextField(_urlController, 'URL', context: context),
            const SizedBox(height: 20),
            _buildTextField(_loginController, 'LOGIN/EMAIL', context: context),
            const SizedBox(height: 20),
            _buildTextField(_passwordController, 'PASSWORD', obscureText: true, context: context),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _saveAccount(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
              ),
              child: const Text('Save Account'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false, required BuildContext context}) {
  return TextField(
    controller: controller,
    style: Theme.of(context).textTheme.bodyMedium,
    decoration: _buildInputDecoration(label, context: context),
    obscureText: obscureText,
  );
}

  InputDecoration _buildInputDecoration(String label, {required BuildContext context}) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
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
      // Обработка ошибки
    }
  }
}
