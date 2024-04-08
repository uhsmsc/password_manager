import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      routes: {
        '/': (context) => const StartScreen(), // Экран аутентификации
        '/home': (context) => const AccountsListScreen(), // Главный экран
      },
      initialRoute: '/', // Начальный маршрут при запуске приложения
    );
  }
}