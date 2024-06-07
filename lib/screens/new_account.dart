import 'package:flutter/material.dart';
import 'package:pwd/encryption/encryption_util.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/widgets/input_field.dart';
import 'package:uuid/uuid.dart';

class NewAccountScreen extends StatelessWidget {
  const NewAccountScreen({Key? key, required this.onSave}) : super(key: key);

  final Function(Account) onSave;

  @override
  Widget build(BuildContext context) {
    final TextEditingController urlController = TextEditingController();
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый аккаунт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputField(
                controller: urlController, label: 'URL', obscureText: false),
            const SizedBox(height: 20),
            InputField(
                controller: loginController,
                label: 'LOGIN/EMAIL',
                obscureText: false),
            const SizedBox(height: 20),
            InputField(controller: passwordController, label: 'PASSWORD'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => _saveAccount(context, urlController.text,
                  loginController.text, passwordController.text),
              child: const Text(
                'Добавить аккаунт',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAccount(BuildContext context, String url, String login,
      String password) async {
    const uuid = Uuid();
    final accountId = uuid.v4();

    encryptPassword(password).then((encryptedPasswordMap) {
      final newAccount = Account(
        id: accountId,
        url: url,
        login: login,
        password: encryptedPasswordMap['encryptedPassword']!,
      );

      onSave(newAccount);

      EncryptionUtil.saveIVForAccount(accountId, encryptedPasswordMap['iv']!);

      Navigator.pop(context);
    });
  }
}

