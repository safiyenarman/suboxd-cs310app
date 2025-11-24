import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'join_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const SUboxdApp());
}

class SUboxdApp extends StatelessWidget {
  const SUboxdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUboxd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C2128),
        fontFamily: 'Inter', 
      ),
      initialRoute: '/',
      routes: {
        '/':      (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/join':  (context) => const JoinScreen(),
        '/home':  (context) => const HomeScreen(),
      },
    );
  }
}