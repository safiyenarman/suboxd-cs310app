import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/reviews_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/courses_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
      ],
      child: const SUboxdApp(),
    ),
  );
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
      initialRoute: Routes.splash,
      routes: Routes.getRoutes(),
    );
  }
}