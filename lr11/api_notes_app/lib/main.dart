import 'package:flutter/material.dart';
import 'pages/notes_page.dart';

void main() {
  runApp(const ApiNotesApp());
}

class ApiNotesApp extends StatelessWidget {
  const ApiNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Notes',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(71, 255, 7, 7),
        ),
        primaryColor: const Color.fromARGB(144, 244, 67, 54),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(144, 244, 67, 54),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(144, 244, 67, 54),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(123, 244, 67, 54),
          foregroundColor: Color.fromARGB(207, 255, 255, 255),
        ),
        cardTheme: const CardThemeData(
          color: Color.fromARGB(255, 60, 60, 60),
        )
      ),
      home: const NotesPage(),
    );
  }
}