import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:argon2/argon2.dart';
import 'package:pwd/widgets/input_field.dart';
import 'dart:typed_data';
import 'dart:convert';

class CreateMasterPasswordScreen extends StatefulWidget {
  const CreateMasterPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateMasterPasswordScreenState();
  }
}

class _CreateMasterPasswordScreenState
    extends State<CreateMasterPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool passwordsMatch = false;
  bool isFirstPasswordEntered = false;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Мастер-пароль',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Мастер-пароль нужен для защиты ваших данных, а также для доступа к ним. Мастер-пароль необходимо вводить при каждом запуске приложения на этом устройстве.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InputField(
              controller: passwordController,
              label: 'Введите мастер-пароль',
              onChanged: _checkPasswordsMatch,
            ),
            const SizedBox(height: 20),
            InputField(
                controller: confirmPasswordController,
                label: 'Подтвердите мастер-пароль',
                onChanged: (value) {
                  _checkPasswordsMatch(value);
                  _checkFirstPasswordEntered(value);
                }),
            const SizedBox(
              height: 10,
            ),
            if (!passwordsMatch &&
                isFirstPasswordEntered)
              const Text(
                'Пароли не совпадают',
                style: TextStyle(
                  color: Color.fromARGB(255, 249, 100, 92),
                  fontSize: 15,
                ),
              ),
            const Spacer(),
            if (passwordsMatch && MediaQuery.of(context).viewInsets.bottom == 0)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 112, 116, 178),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  onPressed: () {
                    registerFirstTime(passwordController.text);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'Создать',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 238, 239, 255),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _checkPasswordsMatch(String value) {
    setState(() {
      passwordsMatch =
          passwordController.text == confirmPasswordController.text &&
              passwordController.text.isNotEmpty &&
              confirmPasswordController.text.isNotEmpty;
    });
    if (passwordsMatch) {
      FocusScope.of(context).unfocus();
    }
  }

  void _checkFirstPasswordEntered(String value) {
    setState(() {
      isFirstPasswordEntered = value.isNotEmpty;
    });
  }

  Future<void> registerFirstTime(String masterPassword) async {
    const storage = FlutterSecureStorage();
    final argon2 = Argon2BytesGenerator();
    final salt = Uint8List.fromList(utf8.encode('somesalt'));

    final parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      salt,
      version: Argon2Parameters.ARGON2_VERSION_10,
      iterations: 2,
      memoryPowerOf2: 16,
    );

    final Uint8List passwordBytes = utf8.encode(masterPassword);
    argon2.init(parameters);
    final result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result, 0, result.length);

    final hashedPassword = base64.encode(result);

    await storage.write(key: 'master_password', value: hashedPassword);
  }
}
