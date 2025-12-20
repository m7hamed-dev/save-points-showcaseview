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
    this.onNext,
    this.onSkip,
    this.nextButtonText,
    this.skipButtonText,
    this.showSkipButton = true,
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

  /// Custom action to execute when "Next" button is pressed.
  ///
  /// If provided, this is called before advancing to the next step.
  /// This allows you to perform custom actions like navigation, animations,
  /// or state updates before moving to the next step.
  ///
  /// ```dart
  /// onNext: () {
  ///   Navigator.push(context, MaterialPageRoute(builder: (_) => NextScreen()));
  /// }
  /// ```
  final VoidCallback? onNext;

  /// Custom action to execute when "Skip" button is pressed.
  ///
  /// If provided, this is called before skipping the tour.
  /// This allows you to perform custom cleanup or tracking.
  ///
  /// ```dart
  /// onSkip: () {
  ///   analytics.logEvent('tour_skipped');
  /// }
  /// ```
  final VoidCallback? onSkip;

  /// Custom text for the "Next" button.
  ///
  /// If not provided, defaults to "Next" or "Done" for the last step.
  ///
  /// ```dart
  /// nextButtonText: 'Continue'
  /// ```
  final String? nextButtonText;

  /// Custom text for the "Skip" button.
  ///
  /// If not provided, defaults to "Skip".
  ///
  /// ```dart
  /// skipButtonText: 'Maybe Later'
  /// ```
  final String? skipButtonText;

  /// Whether to show the skip button for this step.
  ///
  /// Defaults to `true`. Set to `false` to hide the skip button for
  /// important steps that users must complete.
  ///
  /// ```dart
  /// showSkipButton: false  // Hide skip for critical steps
  /// ```
  final bool showSkipButton;

  /// Checks if this step should be displayed based on its conditions.
  ///
  /// Returns `true` if the step should be shown, `false` otherwise.
  /// Steps that return `false` are automatically filtered out before
  /// the tour begins.
  bool get isVisible {
    return shouldShow?.call() ?? showIf;
  }
}
