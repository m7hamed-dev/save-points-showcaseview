import 'package:flutter/material.dart';

/// A phase model representing a step or stage in an explainable action.
///
/// This model is used by [ExplainableAction] to provide contextual
/// information about different phases of an action or feature.
///
/// ## Example
///
/// ```dart
/// Phase(
///   title: 'Setup',
///   description: 'Configure your initial settings',
///   icon: Icons.settings,
/// )
/// ```
class Phase {
  /// Creates a new phase with the given properties.
  const Phase({
    required this.title,
    required this.description,
    required this.icon,
  });

  /// The title of the phase.
  ///
  /// This should be a short, descriptive label (ideally under 30 characters).
  final String title;

  /// A detailed description of what this phase represents.
  ///
  /// This text is displayed to users to explain the phase in detail.
  final String description;

  /// The icon representing this phase.
  ///
  /// This icon is displayed alongside the title and description in the UI.
  final IconData icon;
}
