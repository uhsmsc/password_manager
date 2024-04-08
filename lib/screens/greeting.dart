import 'package:flutter/material.dart';
import 'package:pwd/screens/create_master_password.dart';

class GreetingScreen extends StatelessWidget {
  const GreetingScreen({Key? key}) : super(key: key);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 200,
                  height: 200,
                  child: Image(
                    image: AssetImage('assets/images/logo1.png'),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Password Manager',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Теперь ваша личная информация будет под надежной защитой. Больше никаких забытых паролей и потерянных данных – мы позаботимся о вашей безопасности.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMasterPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Начать',
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
}
