part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Configurable theming for ShowcaseCoach.
class ShowcaseCoachConfig {
  const ShowcaseCoachConfig({
    this.fontFamily,
    this.titleStyle,
    this.bodyStyle,
    this.buttonTextStyle,
    this.primaryColor,
    this.buttonColor,
    this.overlayTintOpacity = 0.15,
    this.cardStyle = ShowcaseCoachCardStyle.glass,
    this.reduceMotion = false,
  });

  /// Global font family applied to coach text (overrides theme family).
  final String? fontFamily;

  /// Optional overrides for title/body/button text.
  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;
  final TextStyle? buttonTextStyle;

  /// Primary accent used for glow and gradients. Defaults to theme primary.
  final Color? primaryColor;

  /// Optional override for the primary CTA button color.
  final Color? buttonColor;

  /// If true, disables heavier effects (e.g. blur) to improve perf.
  final bool reduceMotion;

  /// Opacity for the overlay radial tint.
  final double overlayTintOpacity;

  /// Visual style for the tooltip card.
  final ShowcaseCoachCardStyle cardStyle;

  TextStyle merge(TextStyle base, TextStyle? override) {
    return base.copyWith(
      fontFamily: fontFamily ?? base.fontFamily,
      color: override?.color ?? base.color,
      fontSize: override?.fontSize ?? base.fontSize,
      fontWeight: override?.fontWeight ?? base.fontWeight,
      letterSpacing: override?.letterSpacing ?? base.letterSpacing,
      height: override?.height ?? base.height,
    );
  }
}

/// Preset card styles.
enum ShowcaseCoachCardStyle {
  glass,
  normal,
}

