part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Configuration options for customizing the appearance and behavior of
/// [ShowcaseCoach].
///
/// This class provides fine-grained control over colors, typography, and
/// visual effects. All properties are optional and will fall back to sensible
/// defaults based on the current theme.
///
/// ## Example
///
/// ```dart
/// ShowcaseCoachConfig(
///   primaryColor: Colors.blue,
///   cardStyle: ShowcaseCoachCardStyle.glass,
///   reduceMotion: false,
///   titleStyle: TextStyle(fontSize: 24),
/// )
/// ```
class ShowcaseCoachConfig {
  /// Creates a new showcase coach configuration.
  ///
  /// All parameters are optional. The configuration will merge with the
  /// current theme to provide sensible defaults.
  const ShowcaseCoachConfig({
    this.fontFamily,
    this.titleStyle,
    this.bodyStyle,
    this.buttonTextStyle,
    this.primaryColor,
    this.buttonColor,
    this.overlayTintOpacity = _defaultOverlayTintOpacity,
    this.cardStyle = ShowcaseCoachCardStyle.glass,
    this.reduceMotion = false,
  });

  /// Global font family applied to all coach text.
  ///
  /// If provided, this overrides the theme's default font family for all
  /// text in the showcase coach (title, body, and buttons).
  final String? fontFamily;

  /// Optional override for the title text style.
  ///
  /// Only the specified properties will override the theme defaults.
  /// Other properties (like color) will still come from the theme.
  final TextStyle? titleStyle;

  /// Optional override for the body/description text style.
  ///
  /// Only the specified properties will override the theme defaults.
  final TextStyle? bodyStyle;

  /// Optional override for the button text style.
  ///
  /// Only the specified properties will override the theme defaults.
  final TextStyle? buttonTextStyle;

  /// Primary accent color used for glows, gradients, and highlights.
  ///
  /// If not provided, defaults to `Theme.of(context).colorScheme.primary`.
  final Color? primaryColor;

  /// Optional override for the primary CTA button color.
  ///
  /// If not provided, defaults to [primaryColor] or the theme's primary color.
  final Color? buttonColor;

  /// If `true`, disables heavier visual effects to improve performance.
  ///
  /// When enabled, this will:
  /// - Disable backdrop blur effects
  /// - Reduce animation complexity
  /// - Simplify visual effects
  ///
  /// This is useful for lower-end devices or when respecting user accessibility
  /// preferences for reduced motion.
  final bool reduceMotion;

  /// Opacity for the radial gradient overlay tint.
  ///
  /// Must be between 0.0 and 1.0. Higher values create a more pronounced
  /// tint around the highlighted widget. Defaults to 0.15.
  final double overlayTintOpacity;

  /// Visual style for the tooltip card.
  ///
  /// - [ShowcaseCoachCardStyle.glass]: Glassmorphism effect with backdrop blur
  /// - [ShowcaseCoachCardStyle.normal]: Solid card with theme colors
  ///
  /// Defaults to [ShowcaseCoachCardStyle.glass].
  final ShowcaseCoachCardStyle cardStyle;

  /// Merges a base [TextStyle] with an optional override.
  ///
  /// This is an internal method used to apply configuration overrides to
  /// theme text styles.
  ///
  /// This method is intended for internal use only.
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

/// Visual style options for the showcase coach tooltip card.
enum ShowcaseCoachCardStyle {
  /// Glassmorphism style with backdrop blur and translucent background.
  ///
  /// This creates a modern, frosted glass effect that blends with the
  /// background. Requires backdrop filters, which may impact performance
  /// on some devices.
  glass,

  /// Normal solid card style using theme colors.
  ///
  /// This is a more traditional card appearance with solid backgrounds
  /// and better performance characteristics.
  normal,
}

/// Default overlay tint opacity constant.
const double _defaultOverlayTintOpacity = 0.15;
