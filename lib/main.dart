import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pwd/models/account.dart';
import 'package:pwd/screens/accounts_list.dart';
import 'package:pwd/screens/start.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromRGBO(32, 30, 73, 1),
  ),
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    bodyLarge: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 210, 200, 255),
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 146, 146, 146),
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  ),
);

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<Account>('accounts');

  final accountBox = Hive.box<Account>('accounts');

  runApp(MyApp(accountBox: accountBox));
}

class MyApp extends StatelessWidget {
  final Box<Account> accountBox;

  const MyApp({Key? key, required this.accountBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      routes: {
        '/': (context) => const StartScreen(), // Экран аутентификации
        '/home': (context) => AccountsListScreen(
            accountBox: accountBox), // Главный экран с передачей accountBox
      },
      initialRoute: '/', // Начальный маршрут при запуске приложения
    );
  }
}
