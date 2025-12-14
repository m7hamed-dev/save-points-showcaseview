part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Constants used throughout the showcase coach implementation.
///
/// This class is internal to the package and should not be used directly
/// by consumers.
class ShowcaseCoachConstants {
  ShowcaseCoachConstants._();

  // Animation durations
  static const Duration scrollAnimationDuration = Duration(milliseconds: 400);
  static const Duration scrollAnimationDelay = Duration(milliseconds: 450);
  static const Duration backdropAnimationDuration = Duration(milliseconds: 500);
  static const Duration overlayTransitionDuration = Duration(milliseconds: 450);
  static const Duration gradientTransitionDuration = Duration(milliseconds: 500);
  static const Duration highlightAnimationDuration = Duration(milliseconds: 700);
  static const Duration cardTransitionDuration = Duration(milliseconds: 600);
  static const Duration pulsingAnimationDuration = Duration(milliseconds: 2400);
  static const Duration highlightScaleAnimationDuration =
      Duration(milliseconds: 800);

  // Validation retry settings
  static const int maxValidationRetries = 10;
  static const Duration validationRetryDelay = Duration(milliseconds: 50);

  // Spacing and layout
  static const double cardSpacing = 20.0;
  static const double horizontalPadding = 20.0;
  static const double maxCardWidth = 480.0;
  static const double borderRadius = 24.0;
  static const double cardBorderRadius = 28.0;
  static const double borderWidth = 3.0;
  static const double cardBorderWidth = 1.4;

  // Animation curves
  static const Curve defaultAnimationCurve = Curves.easeOutCubic;
  static const Curve scrollAnimationCurve = Curves.easeInOutCubic;
  static const Curve highlightAnimationCurve = Curves.easeInOutCubic;

  // Blur and effects
  static const double defaultBlurSigma = 8.0;
  static const double cardBlurSigma = 20.0;
  static const double backdropBlurMax = 5.0;

  // Opacity values
  static const double defaultOverlayTintOpacity = 0.15;
  static const double borderOpacityMin = 0.75;
  static const double borderOpacityMax = 1.0;
  static const double shadowIntensityMin = 0.18;
  static const double shadowIntensityMax = 0.42;
  static const double whiteShadowOpacity = 0.4;

  // Highlight animation values
  static const double blurRadiusMin = 20.0;
  static const double blurRadiusMax = 36.0;
  static const double spreadRadiusMin = 3.0;
  static const double spreadRadiusMax = 6.0;
  static const double bounceScaleMin = 0.96;
  static const double bounceScaleMax = 1.04;
  static const double floatOffsetMax = -1.5;

  // Scale animation values
  static const double scaleBegin = 0.75;
  static const double scalePeak = 1.08;
  static const double scaleEnd = 1.0;
  static const double cardScaleBegin = 0.8;
  static const double cardScalePeak = 1.1;

  // Alignment
  static const double scrollAlignment = 0.5;
  static const double gradientRadius = 0.72;
}

