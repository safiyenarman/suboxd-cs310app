import 'package:flutter/material.dart';

import 'routes.dart';
// ProfileScreen.routeName hala kullanıldığı için import yerinde kalmalı
import 'screens/profile_screen.dart';

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E2229),
      ),

      // UYGULAMA AÇILDIĞINDA İLK AÇILACAK EKRAN (SplashScreen olarak ayarlandı)
      initialRoute: Routes.splash, // '/profile' yerine '/'

      // Tüm route'lar tek yerden geliyor
      routes: Routes.getRoutes(),
    );
  }
}