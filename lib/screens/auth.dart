import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:argon2/argon2.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:pwd/widgets/input_field.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 120,
          bottom: 70,
          left: 32,
          right: 32,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 110,
                  height: 110,
                  child: Image(
                    image: AssetImage('assets/images/logo2.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Your Password Manager',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            InputField(
              controller: passwordController,
              label: 'Мастер-пароль',
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 112, 116, 178),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  foregroundColor: const Color.fromARGB(255, 238, 239, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  authenticateAndNavigate(context);
                },
                child: const Text(
                  'Разблокировать',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void authenticateAndNavigate(BuildContext context) {
    final enteredPassword = passwordController.text;
    authenticate(enteredPassword).then((authenticated) {
      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Очистка поля ввода
        passwordController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Ошибка аутентификации',
                style: TextStyle(
                  color: Color.fromARGB(255, 238, 239, 255),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                'Неверный мастер-пароль',
                style: TextStyle(
                  color: Color.fromARGB(255, 212, 213, 227),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ОК'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<bool> authenticate(String enteredPassword) async {
    const storage = FlutterSecureStorage();
    final masterPasswordHash = await storage.read(key: 'master_password');
    final saltString = await storage.read(key: 'master_password_salt');
    final salt = base64.decode(saltString!);
    if (masterPasswordHash != null) {
      final argon2 = Argon2BytesGenerator();
      final passwordBytes = utf8.encode(enteredPassword);

      final parameters = Argon2Parameters(
        Argon2Parameters.ARGON2_i,
        salt,
        version: Argon2Parameters.ARGON2_VERSION_10,
        iterations: 2,
        memoryPowerOf2: 16,
      );

      final hash = Uint8List(32);
      argon2.init(parameters);
      argon2.generateBytes(passwordBytes, hash, 0, hash.length);

      final expectedHash = base64.decode(masterPasswordHash);

      return hash.length == expectedHash.length &&
          const IterableEquality().equals(hash, expectedHash);
    } else {
      return false;
    }
  }
}
