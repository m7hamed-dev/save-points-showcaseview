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
    this.showProgressIndicator = true,
    this.enableTransitions,
    this.transitionDuration,
    this.transitionCurve,
    this.backdropTransitionDuration,
    this.gradientTransitionDuration,
    this.highlightTransitionDuration,
    this.cardTransitionDuration,
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

  /// Whether to show a progress indicator (e.g., "Step 2 of 5").
  ///
  /// When enabled, displays the current step number and total steps
  /// in the tooltip card header.
  ///
  /// Defaults to `true`.
  final bool showProgressIndicator;

  /// Whether to enable transition animations between steps.
  ///
  /// When `true`, smooth animations are used when transitioning between steps.
  /// When `false`, transitions are instant.
  ///
  /// If not provided, defaults to `true` unless [reduceMotion] is `true`,
  /// in which case it defaults to `false`.
  ///
  /// ```dart
  /// enableTransitions: false  // Instant transitions
  /// ```
  final bool? enableTransitions;

  /// Duration for all transition animations.
  ///
  /// If not provided, uses default durations for each transition type.
  /// This is a convenience option; for fine-grained control, use the
  /// specific duration properties.
  ///
  /// ```dart
  /// transitionDuration: Duration(milliseconds: 300)  // Faster transitions
  /// ```
  final Duration? transitionDuration;

  /// Curve for transition animations.
  ///
  /// If not provided, defaults to [Curves.easeOutCubic].
  ///
  /// ```dart
  /// transitionCurve: Curves.easeInOut  // Smoother transitions
  /// ```
  final Curve? transitionCurve;

  /// Duration for backdrop hole transitions.
  ///
  /// Controls how long it takes for the backdrop hole to animate when
  /// moving between highlighted widgets.
  ///
  /// If not provided, uses [transitionDuration] or defaults to 450ms.
  final Duration? backdropTransitionDuration;

  /// Duration for gradient overlay transitions.
  ///
  /// Controls how long it takes for the radial gradient overlay to animate
  /// when moving between highlighted widgets.
  ///
  /// If not provided, uses [transitionDuration] or defaults to 500ms.
  final Duration? gradientTransitionDuration;

  /// Duration for highlight position transitions.
  ///
  /// Controls how long it takes for the highlight border to animate to
  /// a new position when moving between highlighted widgets.
  ///
  /// If not provided, uses [transitionDuration] or defaults to 700ms.
  final Duration? highlightTransitionDuration;

  /// Duration for tooltip card transitions.
  ///
  /// Controls how long it takes for the tooltip card to animate when
  /// transitioning between steps.
  ///
  /// If not provided, uses [transitionDuration] or defaults to 600ms.
  final Duration? cardTransitionDuration;

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
