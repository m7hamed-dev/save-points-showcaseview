/// A beautiful, modern showcase coach overlay for Flutter.
///
/// This library provides a design-forward showcase coach with smooth animations,
/// glassmorphism effects, and step-by-step guided tours. It includes built-in
/// validation, accessibility support, and customizable theming.
///
/// ## Quick Start
///
/// ```dart
/// await ShowcaseCoach.show(
///   context,
///   steps: [
///     CoachStep(
///       targetKey: myKey,
///       title: 'Welcome!',
///       description: ['This is your first step.'],
///     ),
///   ],
/// );
/// ```
///
/// See the [README](https://pub.dev/packages/save_points_showcaseview) for
/// complete documentation and examples.
library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:save_points_showcaseview/widgets/coach_step.dart';

// Export CoachStep for convenience
export 'package:save_points_showcaseview/widgets/coach_step.dart';

part 'widgets/showcase_coach.dart';
part 'widgets/showcase_coach_overlay.dart';
part 'widgets/backdrop_hole.dart';
part 'widgets/tooltip_card.dart';
part 'widgets/card_surface.dart';
part 'widgets/paged_description.dart';
part 'widgets/showcase_coach_config.dart';
part 'widgets/showcase_coach_constants.dart';
part 'widgets/showcase_coach_validator.dart';
part 'widgets/showcase_coach_error.dart';
