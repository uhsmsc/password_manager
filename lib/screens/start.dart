import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwd/screens/auth.dart';
import 'package:pwd/screens/greeting.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isMasterPasswordSet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Ошибка: ${snapshot.error}');
        }
        final bool isMasterPasswordSet = snapshot.data ?? false;
        if (isMasterPasswordSet) {
          return AuthenticationScreen();
        } else {
          return const GreetingScreen();
        }
      },
    );
  }

  Future<bool> isMasterPasswordSet() async {
    const storage = FlutterSecureStorage();
    String? masterPassword = await storage.read(key: 'master_password');
    return masterPassword != null;
  }
}
