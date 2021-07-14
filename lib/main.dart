import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Sustaining Garden',
      theme: ThemeData(
        primaryColorLight: const Color(0xFFF5FDFB),
        primaryColor: const Color(0xFF0C9359),
        primaryColorDark: const Color(0xFF06492C),
        accentColor: const Color(0xFF3BCEAC),
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
