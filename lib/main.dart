import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const Copa2026App());
}

class Copa2026App extends StatelessWidget {
  const Copa2026App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Copa 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}