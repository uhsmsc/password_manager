import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pwd/screens/accounts_list.dart';


final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 18, 18, 18),
  ),
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    bodyLarge: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ), 
    bodyMedium: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 18,
    ),
    bodySmall: GoogleFonts.montserrat(
      color: const Color.fromARGB(255, 87, 87, 87),
      fontSize: 16,
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
      home: const AccountsListScreen(),
    );
  }
}