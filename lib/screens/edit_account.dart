import 'package:flutter/material.dart';
import 'package:pwd/encryption/encryption_util.dart';
import 'package:pwd/models/account.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({
    super.key,
    required this.account,
    required this.onSave,
    required this.onDelete,
  });

  final Account account;
  final Function(Account, String) onSave;
  final Function(Account) onDelete;

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
    _passwordController = TextEditingController(text: ' ');
    _urlController = TextEditingController(text: widget.account.url);
    _loginController = TextEditingController(text: widget.account.login);
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
            onPressed: () => _deleteAccount(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: ListView(
          children: [
            _buildTextField('URL', _urlController, 'Введите URL'),
            _buildTextField(
              'LOGIN/EMAIL',
              _loginController,
              'Введите логин или email',
            ),
            _buildPasswordField(
              'PASSWORD',
              _passwordController,
              'Введите пароль',
            ),
            const SizedBox(height: 20),
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
                  child: const Text('Сохранить аккаунт'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller,
    String hintText,
  ) {
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
    String labelText,
    TextEditingController controller,
    String hintText,
  ) {
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
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
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

  void _saveAccount() async {
    final newPassword = _passwordController.text;
    final encryptedPasswordData = await encryptPassword(newPassword);

    final updatedAccount = Account(
      id: widget.account.id,
      url: _urlController.text,
      login: _loginController.text,
      password: encryptedPasswordData['encryptedPassword']!,
    );

    final iv = encryptedPasswordData['iv'];

    if (iv != null) {
      widget.onSave(updatedAccount, iv);
    }
  }

  void _decryptPassword() async {
    final iv = await EncryptionUtil.getIVForAccount(widget.account.id) ?? '';
    final decryptedPassword =
        await decryptPassword(widget.account.password, iv) ?? '';
    setState(() {
      _passwordController.text = decryptedPassword;
    });
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Удаление аккаунта',
            style: TextStyle(
              color: Color.fromARGB(255, 238, 239, 255),
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Вы уверены, что хотите удалить аккаунт?',
            style: TextStyle(
              color: Color.fromARGB(255, 212, 213, 227),
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete(widget.account);
                Navigator.of(context).pop();
              },
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }
}
