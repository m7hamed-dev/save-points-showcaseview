import 'package:flutter/material.dart';

/// A single step in a showcase coach tour.
///
/// Each step represents one highlight in the guided tour, pointing to a
/// specific widget via a [GlobalKey] and displaying instructional content.
///
/// ## Example
///
/// ```dart
/// CoachStep(
///   targetKey: myButtonKey,
///   title: 'Action Button',
///   description: [
///     'Tap this button to perform an action.',
///     'You can undo this action later.',
///   ],
///   showIf: isFeatureEnabled,
/// )
/// ```
///
/// See also:
/// - [ShowcaseCoach] for displaying the tour
/// - [ShowcaseCoachConfig] for customizing appearance
class CoachStep {
  /// Creates a new showcase coach step.
  ///
  /// The [targetKey] must be attached to a widget in the widget tree.
  /// The [title] and [description] are displayed in the tooltip card.
  ///
  /// Use [shouldShow] for dynamic visibility logic, or [showIf] for simple
  /// boolean conditions. If both are provided, [shouldShow] takes precedence.
  const CoachStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.shouldShow,
    this.showIf = true,
  });

  /// The [GlobalKey] attached to the widget to highlight.
  ///
  /// This key must be unique across all steps and attached to a visible
  /// widget in the widget tree.
  final GlobalKey targetKey;

  /// The title displayed in the tooltip card.
  ///
  /// Keep this concise (ideally under 50 characters) for best readability.
  final String title;

  /// The description text displayed in the tooltip card.
  ///
  /// Each string in the list represents one page of description. Users can
  /// swipe between pages. Keep descriptions concise and actionable.
  final List<String> description;

  /// Optional callback to determine if this step should be shown.
  ///
  /// If provided, this takes precedence over [showIf]. This is useful for
  /// complex conditional logic that depends on app state.
  ///
  /// ```dart
  /// shouldShow: () => user.isPremium && feature.isEnabled
  /// ```
  final bool Function()? shouldShow;

  /// Simple boolean flag to control if this step should be shown.
  ///
  /// Only used if [shouldShow] is not provided. Defaults to `true`.
  ///
  /// ```dart
  /// showIf: isFeatureEnabled
  /// ```
  final bool showIf;

  /// Checks if this step should be displayed based on its conditions.
  ///
  /// Returns `true` if the step should be shown, `false` otherwise.
  /// Steps that return `false` are automatically filtered out before
  /// the tour begins.
  bool get isVisible {
    return shouldShow?.call() ?? showIf;
  }
}
