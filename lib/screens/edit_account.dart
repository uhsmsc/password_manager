import 'package:flutter/material.dart';
import 'package:pwd/encryption/encryption_util.dart';
import 'package:pwd/models/account.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({
    super.key,
    required this.account,
    required this.onSave,
  });

  final Account account;
  final Function(Account) onSave;

  @override
  State<StatefulWidget> createState() {
    return _EditAccountScreenState();
  }
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _urlController;
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.account.url);
    _loginController = TextEditingController(text: widget.account.login);
    _passwordController = TextEditingController();

    _decryptPassword();
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
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 10),
        child: ListView(
          children: [
            _buildTextField('URL', _urlController, 'Введите URL'),
            _buildTextField(
                'LOGIN/EMAIL', _loginController, 'Введите логин или email'),
            _buildPasswordField(
                'PASSWORD', _passwordController, 'Введите пароль'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(196, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _saveAccount(),
                  child: const Text(
                    'Сохранить аккаунт',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20),
          hintText: hintText,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium,
        obscureText: _isObscure,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20),
          hintText: hintText,
          isDense: true,
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
      ),
    );
  }

  void _decryptPassword() async {
    final decryptedPassword =
        await decryptPassword(widget.account.password, widget.account.iv) ?? '';
    setState(() {
      _passwordController.text = decryptedPassword;
    });
  }

  void _saveAccount() async {
    final newPassword = _passwordController.text;
    final encryptedPasswordData = await encryptPassword(newPassword);

    final updatedAccount = Account(
      id: widget.account.id,
      url: _urlController.text,
      login: _loginController.text,
      password: encryptedPasswordData['encryptedPassword']!,
      iv: encryptedPasswordData['iv']!,
    );

    widget.onSave(updatedAccount);
  }
}
