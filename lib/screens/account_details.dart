import 'package:flutter/material.dart';
import 'package:pwd/models/account.dart';

class AccountDetailsScreen extends StatefulWidget {
  final Account account;

  const AccountDetailsScreen({super.key, required this.account});

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
          style: Theme.of(context).textTheme.bodyLarge,
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              print('Edit button tapped');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'URL',
              style: Theme.of(context).textTheme.bodySmall, 
            ),
            Text(
              widget.account.url,
              style: Theme.of(context).textTheme.bodyMedium, 
            ),
            const SizedBox(height: 20),
            Text(
              'LOGIN',
              style: Theme.of(context).textTheme.bodySmall, 
            ),
            Text(
              widget.account.login,
              style: Theme.of(context).textTheme.bodyMedium, 
            ),
            const SizedBox(height: 20),
            Text(
              'PASSWORD',
              style: Theme.of(context).textTheme.bodySmall, 
            ),
            Text(
              _showPassword ? widget.account.password : _getMaskedPassword(),
              style: Theme.of(context).textTheme.bodyMedium, 
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                    print('Show Password button tapped');
                  },
                  child: const Text('Show Password'),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Copy Password button tapped');
                  },
                  child: const Text('Copy Password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMaskedPassword() {
    return '•' * widget.account.password.length;
  }
}
