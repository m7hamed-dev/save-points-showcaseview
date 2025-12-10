import 'package:flutter/material.dart';

///### Phase model
class Phase {
  const Phase({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
