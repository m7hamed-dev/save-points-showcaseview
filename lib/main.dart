import 'package:flutter/material.dart';
import 'package:save_points_showcaseview/example_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Points Explainer',
      theme: ThemeData(
        colorScheme: baseScheme.copyWith(
          surface: const Color(0xFFF8F7FF),
          surfaceContainerHighest: const Color(0xFFEAE8FF),
        ),
        useMaterial3: true,
        textTheme: Typography.blackMountainView.copyWith(
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
          titleMedium: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          bodyLarge: const TextStyle(
            height: 1.5,
            letterSpacing: 0,
          ),
          bodyMedium: const TextStyle(
            height: 1.5,
          ),
        ),
      ),
      routes: {
        '/example': (_) => const ExampleCoachPage(),
      },
      home: const ExampleCoachPage(),
    );
  }
}
