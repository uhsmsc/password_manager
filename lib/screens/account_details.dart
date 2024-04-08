import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/widgets/common_widgets.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key, required this.account});

  final Account account;

  @override
  State<StatefulWidget> createState() {
    return _AccountDetailsScreenState();
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late TextEditingController _passwordController;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _passwordController.text = widget.account.password;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.account.url,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: ListView(
          children: [
            _buildListTile(
              'URL',
              widget.account.url,
              () => _copyToClipboard('URL', widget.account.url),
            ),
            _buildListTile(
              'LOGIN/EMAIL',
              widget.account.login,
              () => _copyToClipboard('Логин', widget.account.login),
            ),
            _buildListTile(
              'PASSWORD',
              _showPassword ? widget.account.password : _getMaskedPassword(),
              () => _copyToClipboard('Пароль', widget.account.password),
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

  String _getMaskedPassword() {
    return '•' * widget.account.password.length;
  }
}
