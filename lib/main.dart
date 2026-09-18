import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MultiScreenApp());
}

class MultiScreenApp extends StatelessWidget {
  const MultiScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Screen App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Initial route definition
      initialRoute: AppRoutes.home,
      // Named routes table
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.register: (context) => const FormScreen(),
        AppRoutes.detail: (context) => const DetailScreen(),
      },
    );
  }
}
