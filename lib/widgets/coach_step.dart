import 'package:flutter/material.dart';

class CoachStep {
  const CoachStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.shouldShow,
    this.showIf = true,
  });

  final GlobalKey targetKey;
  final String title;
  final List<String> description;

  /// Optional callback to determine if this step should be shown.
  /// If provided, this takes precedence over [showIf].
  final bool Function()? shouldShow;

  /// Simple boolean flag to control if this step should be shown.
  /// Only used if [shouldShow] is not provided. Defaults to `true`.
  final bool showIf;

  /// Checks if this step should be displayed based on its conditions.
  bool get isVisible {
    return shouldShow?.call() ?? showIf;
  }
}
