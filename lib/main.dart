import 'package:flutter/material.dart';
import 'package:save_points_showcaseview/example_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Points Explainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        textTheme: Typography.blackMountainView,
      ),
      routes: {
        '/example': (_) => const ExampleCoachPage(),
      },
      home: const ExampleCoachPage(),
    );
  }
}
