import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pwd/encryption/encryption_util.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/screens/edit_account.dart';
import 'package:pwd/widgets/common_widgets.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({
    super.key,
    required this.account,
    required this.accountBox,
  });

  final Account account;
  final Box<Account> accountBox;

  @override
  State<StatefulWidget> createState() {
    return _AccountDetailsScreenState();
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late TextEditingController _passwordController;
  late Future<String?> _decryptedPassword;
  bool _showPassword = false;
  late Box<Account> _accountBox;
  late Account _account;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: widget.account.password);
    _accountBox = widget.accountBox;
    _account = widget.account;
    _decryptedPassword = _getDecryptedPassword();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<String?> _getDecryptedPassword() async {
    final iv = await EncryptionUtil.getIVForAccount(_account.id) ?? '';
    return decryptPassword(_account.password, iv);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_account.url),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _openEditAccountScreen(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: ListView(
          children: [
            _buildListTile(
              'URL',
              _account.url,
              () => _copyToClipboard('URL', _account.url),
            ),
            _buildListTile(
              'LOGIN/EMAIL',
              _account.login,
              () => _copyToClipboard('Логин', _account.login),
            ),
            FutureBuilder<String?>(
              future: _decryptedPassword,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Ошибка: ${snapshot.error}');
                } else {
                  final decryptedPassword = snapshot.data ?? '';
                  return _buildListTile(
                    'PASSWORD',
                    _showPassword
                        ? decryptedPassword
                        : _getMaskedPassword(decryptedPassword),
                    () => _copyToClipboard('Пароль', decryptedPassword),
                  );
                }
              },
            ),
            const SizedBox(
              height: 22,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  child: Text(
                    _showPassword ? 'Скрыть пароль' : 'Показать пароль',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, VoidCallback onPressed) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.copy_rounded),
      ),
    );
  }

  void _copyToClipboard(String label, String data) {
    Clipboard.setData(ClipboardData(text: data));
    SnackbarHandler.showSnackbar(context, '$label скопирован в буфер обмена');
  }

  String _getMaskedPassword(String decryptedPassword) {
    return '•' * decryptedPassword.length;
  }

  void _openEditAccountScreen(BuildContext context) async {
    final updatedAccountWithIV = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(
          account: _account,
          onSave: _saveAccount,
          onDelete: _deleteAccount,
        ),
      ),
    );

    if (updatedAccountWithIV != null &&
        updatedAccountWithIV is Map<String, dynamic>) {
      final updatedAccount = updatedAccountWithIV['account'] as Account;
      final iv = updatedAccountWithIV['iv'] as String;
      _saveAccount(updatedAccount, iv);
    }
  }

  void _saveAccount(Account updatedAccount, String iv) async {
    final updatedEncryptedAccount = Account(
      id: updatedAccount.id,
      url: updatedAccount.url,
      login: updatedAccount.login,
      password: updatedAccount.password,
    );

    _accountBox.put(_account.key, updatedEncryptedAccount);
    EncryptionUtil.saveIVForAccount(_account.id, iv);

    Navigator.pop(context);

    setState(() {
      _account = updatedEncryptedAccount;
      _decryptedPassword = decryptPassword(updatedAccount.password, iv);
    });
  }

  void _deleteAccount(Account updatedAccount) {
    _accountBox.delete(updatedAccount.key);
    EncryptionUtil.deleteIVForAccount(updatedAccount.id);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
