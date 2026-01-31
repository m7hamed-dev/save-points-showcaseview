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
    this.showProgressIndicator = true,
    this.enableTransitions,
    this.transitionDuration,
    this.transitionCurve,
    this.backdropTransitionDuration,
    this.gradientTransitionDuration,
    this.highlightTransitionDuration,
    this.cardTransitionDuration,
    this.enableHapticFeedback = false,
    this.hapticFeedbackType = HapticFeedbackType.medium,
    this.enableAutoAdvance = false,
    this.enableRippleEffect = false,
    this.glowIntensity = 1.0,
    this.shadowIntensity = 1.0,
    this.borderStyle = HighlightBorderStyle.solid,
    this.enableShimmerEffect = false,
    this.enableParticleEffect = false,
    this.pulseAnimationSpeed = 1.0,
    this.bounceIntensity = 1.0,
    this.borderWidth = 3.0,
    this.borderRadius = 24.0,
    this.highlightShape = HighlightShape.roundedRectangle,
    this.dismissOnTapOutside = false,
    this.debugMode = false,
    this.enableRotationAnimation = false,
    this.rotationAnimationSpeed = 1.0,
    this.rotationAngle = 0.0,
    this.fadeAnimationDuration,
    this.fadeAnimationCurve,
    this.scaleAnimationDuration,
    this.scaleAnimationCurve,
    this.scaleAnimationRange = const ScaleRange(0.8, 1.0),
    this.slideAnimationDuration,
    this.slideAnimationCurve,
    this.slideAnimationOffset,
    this.animationDelay = Duration.zero,
    this.staggerAnimationDelay = Duration.zero,
    this.enableStaggerAnimations = false,
    this.animationPreset = AnimationPreset.defaultPreset,
    this.animationDirection = AnimationDirection.normal,
    this.skipButtonText,
    this.nextButtonText,
    this.overlayStyle = ShowcaseOverlayStyle.modern,
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

  /// Returns the effective button color without needing a BuildContext.
  ///
  /// This guarantees that if [buttonColor] is null, [primaryColor] is used.
  /// Widgets can still fall back to the theme primary color if both are null.
  Color? get effectiveButtonColor => buttonColor ?? primaryColor;

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
  /// If not provided, defaults to `true`.
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

  /// Whether to enable haptic feedback on step changes.
  ///
  /// When enabled, provides tactile feedback when transitioning between steps
  /// and when completing the tour. This improves mobile UX and accessibility.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableHapticFeedback: true  // Enable haptic feedback
  /// ```
  final bool enableHapticFeedback;

  /// Type of haptic feedback to use.
  ///
  /// - [HapticFeedbackType.light]: Light impact (for subtle feedback)
  /// - [HapticFeedbackType.medium]: Medium impact (default, balanced)
  /// - [HapticFeedbackType.heavy]: Heavy impact (for important transitions)
  ///
  /// Only used when [enableHapticFeedback] is `true`.
  ///
  /// Defaults to [HapticFeedbackType.medium].
  final HapticFeedbackType hapticFeedbackType;

  /// Whether to enable auto-advance functionality.
  ///
  /// When enabled globally, steps can auto-advance if they have an
  /// [autoAdvanceAfter] duration set. This is useful for demo modes
  /// or kiosk displays.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableAutoAdvance: true  // Allow steps to auto-advance
  /// ```
  final bool enableAutoAdvance;

  /// Whether to enable ripple effect on the highlight.
  ///
  /// When enabled, expanding circular ripples emanate from the highlighted
  /// widget, creating a more dynamic visual effect.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableRippleEffect: true  // Enable ripple animations
  /// ```
  final bool enableRippleEffect;

  /// Intensity multiplier for the glow effect around the highlight.
  ///
  /// Values between 0.0 and 2.0. Higher values create a more intense glow.
  /// Set to 0.0 to disable glow entirely.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// glowIntensity: 1.5  // 50% more intense glow
  /// ```
  final double glowIntensity;

  /// Intensity multiplier for shadow effects.
  ///
  /// Values between 0.0 and 2.0. Higher values create deeper, more pronounced
  /// shadows. Set to 0.0 to disable shadows entirely.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// shadowIntensity: 0.5  // Softer shadows
  /// ```
  final double shadowIntensity;

  /// Border style for the highlight.
  ///
  /// - [HighlightBorderStyle.solid]: Solid border (default)
  /// - [HighlightBorderStyle.dashed]: Dashed border
  /// - [HighlightBorderStyle.dotted]: Dotted border
  ///
  /// Defaults to [HighlightBorderStyle.solid].
  ///
  /// ```dart
  /// borderStyle: HighlightBorderStyle.dashed  // Dashed border
  /// ```
  final HighlightBorderStyle borderStyle;

  /// Whether to enable shimmer/sparkle effect on the highlight.
  ///
  /// When enabled, a subtle shimmer animation runs across the highlight border,
  /// creating a premium, polished look.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableShimmerEffect: true  // Enable shimmer animation
  /// ```
  final bool enableShimmerEffect;

  /// Whether to enable particle/sparkle effect around the highlight.
  ///
  /// When enabled, floating particles appear around the highlighted widget,
  /// creating a magical, attention-grabbing effect.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableParticleEffect: true  // Enable particle animations
  /// ```
  final bool enableParticleEffect;

  /// Speed multiplier for pulse animation.
  ///
  /// Values between 0.5 and 3.0. Higher values make the pulse animation faster.
  /// Lower values make it slower and more subtle.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// pulseAnimationSpeed: 1.5  // 50% faster pulse
  /// ```
  final double pulseAnimationSpeed;

  /// Intensity multiplier for bounce animation.
  ///
  /// Values between 0.0 and 2.0. Higher values create more pronounced bounce.
  /// Set to `0.0` to disable bounce entirely.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// bounceIntensity: 1.5  // More pronounced bounce
  /// ```
  final double bounceIntensity;

  /// Width of the highlight border in pixels.
  ///
  /// Must be greater than 0. Defaults to `3.0`.
  ///
  /// ```dart
  /// borderWidth: 4.0  // Thicker border
  /// ```
  final double borderWidth;

  /// Border radius for the highlight in pixels.
  ///
  /// Must be greater than or equal to 0. Defaults to `24.0`.
  /// Set to `0.0` for sharp corners.
  ///
  /// ```dart
  /// borderRadius: 16.0  // Less rounded corners
  /// ```
  final double borderRadius;

  /// Shape of the highlight border.
  ///
  /// - [HighlightShape.roundedRectangle]: Rounded rectangle (default)
  /// - [HighlightShape.circle]: Perfect circle
  /// - [HighlightShape.rectangle]: Sharp rectangle (no rounding)
  ///
  /// Defaults to [HighlightShape.roundedRectangle].
  ///
  /// ```dart
  /// highlightShape: HighlightShape.circle  // Circular highlight
  /// ```
  final HighlightShape highlightShape;

  /// Whether to dismiss the tour when tapping outside the highlight area.
  ///
  /// When enabled, users can tap anywhere outside the highlighted widget
  /// to dismiss the tour. This provides a more intuitive way to exit.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// dismissOnTapOutside: true  // Allow tap outside to dismiss
  /// ```
  final bool dismissOnTapOutside;

  /// Whether to enable debug mode visualization.
  ///
  /// When enabled, displays visual indicators showing:
  /// - GlobalKey bounds and positions
  /// - Validation status
  /// - Step information
  ///
  /// Useful for debugging tour setup issues.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// debugMode: true  // Show debug information
  /// ```
  final bool debugMode;

  /// Whether to enable rotation animation on the highlight.
  ///
  /// When enabled, the highlight rotates continuously, creating a dynamic
  /// spinning effect. Useful for drawing attention to important elements.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableRotationAnimation: true  // Enable rotation
  /// ```
  final bool enableRotationAnimation;

  /// Speed multiplier for rotation animation.
  ///
  /// Values between 0.5 and 3.0. Higher values rotate faster.
  /// Only used when [enableRotationAnimation] is `true`.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// rotationAnimationSpeed: 1.5  // 50% faster rotation
  /// ```
  final double rotationAnimationSpeed;

  /// Maximum rotation angle in degrees.
  ///
  /// Values between 0.0 and 360.0. The highlight will rotate between
  /// -angle and +angle. Set to 0.0 for no rotation.
  ///
  /// Defaults to `0.0`.
  ///
  /// ```dart
  /// rotationAngle: 15.0  // Rotate ±15 degrees
  /// ```
  final double rotationAngle;

  /// Duration for fade animations.
  ///
  /// Controls fade-in and fade-out animations. If not provided, uses
  /// [transitionDuration] or defaults to 400ms.
  ///
  /// ```dart
  /// fadeAnimationDuration: Duration(milliseconds: 500)  // Slower fade
  /// ```
  final Duration? fadeAnimationDuration;

  /// Curve for fade animations.
  ///
  /// If not provided, uses [transitionCurve] or defaults to [Curves.easeOut].
  ///
  /// ```dart
  /// fadeAnimationCurve: Curves.easeInOut  // Smoother fade
  /// ```
  final Curve? fadeAnimationCurve;

  /// Duration for scale animations.
  ///
  /// Controls scale-up and scale-down animations. If not provided, uses
  /// [transitionDuration] or defaults to 600ms.
  ///
  /// ```dart
  /// scaleAnimationDuration: Duration(milliseconds: 800)  // Slower scale
  /// ```
  final Duration? scaleAnimationDuration;

  /// Curve for scale animations.
  ///
  /// If not provided, uses [transitionCurve] or defaults to [Curves.easeOutBack].
  ///
  /// ```dart
  /// scaleAnimationCurve: Curves.elasticOut  // Bouncy scale
  /// ```
  final Curve? scaleAnimationCurve;

  /// Range for scale animations (begin, end).
  ///
  /// Controls the scale range for animations. Defaults to (0.8, 1.0).
  ///
  /// ```dart
  /// scaleAnimationRange: ScaleRange(0.5, 1.2)  // More dramatic scale
  /// ```
  final ScaleRange scaleAnimationRange;

  /// Duration for slide animations.
  ///
  /// Controls slide-in and slide-out animations. If not provided, uses
  /// [transitionDuration] or defaults to 500ms.
  ///
  /// ```dart
  /// slideAnimationDuration: Duration(milliseconds: 600)  // Slower slide
  /// ```
  final Duration? slideAnimationDuration;

  /// Curve for slide animations.
  ///
  /// If not provided, uses [transitionCurve] or defaults to [Curves.easeOutCubic].
  ///
  /// ```dart
  /// slideAnimationCurve: Curves.easeInOutBack  // Bouncy slide
  /// ```
  final Curve? slideAnimationCurve;

  /// Offset for slide animations.
  ///
  /// Controls the starting offset for slide animations. If not provided,
  /// uses default offsets based on position.
  ///
  /// ```dart
  /// slideAnimationOffset: Offset(50, 0)  // Slide from right
  /// ```
  final Offset? slideAnimationOffset;

  /// Delay before starting animations.
  ///
  /// Adds a delay before any animations begin. Useful for coordinating
  /// multiple animations or waiting for other UI updates.
  ///
  /// Defaults to [Duration.zero].
  ///
  /// ```dart
  /// animationDelay: Duration(milliseconds: 200)  // 200ms delay
  /// ```
  final Duration animationDelay;

  /// Delay between staggered animations.
  ///
  /// When [enableStaggerAnimations] is `true`, this controls the delay
  /// between each animation element.
  ///
  /// Defaults to [Duration.zero].
  ///
  /// ```dart
  /// staggerAnimationDelay: Duration(milliseconds: 100)  // 100ms between elements
  /// ```
  final Duration staggerAnimationDelay;

  /// Whether to enable staggered animations.
  ///
  /// When enabled, animations are staggered (started sequentially with delays),
  /// creating a cascading effect. Useful for complex multi-element animations.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// enableStaggerAnimations: true  // Enable stagger effect
  /// ```
  final bool enableStaggerAnimations;

  /// Animation preset to use.
  ///
  /// Pre-configured animation styles for common use cases:
  /// - [AnimationPreset.defaultPreset]: Standard animations (default)
  /// - [AnimationPreset.smooth]: Smooth, gentle animations
  /// - [AnimationPreset.bouncy]: Bouncy, energetic animations
  /// - [AnimationPreset.quick]: Fast, snappy animations
  /// - [AnimationPreset.dramatic]: Dramatic, attention-grabbing animations
  ///
  /// Defaults to [AnimationPreset.defaultPreset].
  ///
  /// ```dart
  /// animationPreset: AnimationPreset.bouncy  // Use bouncy preset
  /// ```
  final AnimationPreset animationPreset;

  /// Direction for animations.
  ///
  /// Controls the direction of animations:
  /// - [AnimationDirection.normal]: Standard direction
  /// - [AnimationDirection.reverse]: Reverse direction
  /// - [AnimationDirection.alternate]: Alternate between normal and reverse
  ///
  /// Defaults to [AnimationDirection.normal].
  ///
  /// ```dart
  /// animationDirection: AnimationDirection.reverse  // Reverse animations
  /// ```
  final AnimationDirection animationDirection;

  /// Custom text for the "Skip" button.
  ///
  /// If provided, this will be used as the default text for all skip buttons
  /// unless overridden by a step's [CoachStep.skipButtonText].
  ///
  /// If not provided, defaults to "Skip".
  ///
  /// ```dart
  /// skipButtonText: 'Maybe Later'  // Global skip button text
  /// ```
  final String? skipButtonText;

  /// Custom text for the "Next" button.
  ///
  /// If provided, this will be used as the default text for all next buttons
  /// unless overridden by a step's [CoachStep.nextButtonText].
  ///
  /// If not provided, defaults to "Next" or "Done" for the last step.
  ///
  /// ```dart
  /// nextButtonText: 'Continue'  // Global next button text
  /// ```
  final String? nextButtonText;

  /// Optional showcase overlay style for a different look.
  ///
  /// - [ShowcaseOverlayStyle.modern]: Current design (gradient overlay,
  ///   glass/solid card, inline Skip/Next).
  /// - [ShowcaseOverlayStyle.classic]: Dark semi-transparent overlay,
  ///   white speech-bubble tooltip with pointer, Skip fixed at bottom-left,
  ///   red-accent Next button (use [primaryColor]/[buttonColor] for red).
  ///
  /// Defaults to [ShowcaseOverlayStyle.modern].
  ///
  /// ```dart
  /// overlayStyle: ShowcaseOverlayStyle.classic  // Email-app style onboarding
  /// ```
  final ShowcaseOverlayStyle overlayStyle;

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

/// Type of haptic feedback to provide.
enum HapticFeedbackType {
  /// Light haptic feedback - subtle and gentle.
  light,

  /// Medium haptic feedback - balanced and standard.
  medium,

  /// Heavy haptic feedback - strong and noticeable.
  heavy,
}

/// Border style options for the highlight.
enum HighlightBorderStyle {
  /// Solid border - continuous line.
  solid,

  /// Dashed border - broken line segments.
  dashed,

  /// Dotted border - small dots.
  dotted,
}

/// Shape options for the highlight border.
enum HighlightShape {
  /// Rounded rectangle with customizable border radius.
  roundedRectangle,

  /// Perfect circle (uses the smaller dimension as diameter).
  circle,

  /// Sharp rectangle with no rounding.
  rectangle,
}

/// Scale range for animations.
class ScaleRange {
  /// Creates a scale range with begin and end values.
  const ScaleRange(this.begin, this.end);

  /// Starting scale value (typically between 0.0 and 1.0).
  final double begin;

  /// Ending scale value (typically 1.0 or higher for bounce effects).
  final double end;
}

/// Animation preset options for common animation styles.
enum AnimationPreset {
  /// Default preset with balanced animations.
  defaultPreset,

  /// Smooth, gentle animations with ease curves.
  smooth,

  /// Bouncy, energetic animations with elastic curves.
  bouncy,

  /// Quick, snappy animations with fast durations.
  quick,

  /// Dramatic, attention-grabbing animations with large scales and bounces.
  dramatic,
}

/// Animation direction options.
enum AnimationDirection {
  /// Normal animation direction (forward).
  normal,

  /// Reverse animation direction (backward).
  reverse,

  /// Alternate between normal and reverse.
  alternate,
}

/// Overlay style for the showcase coach (optional effect).
enum ShowcaseOverlayStyle {
  /// Modern style: gradient overlay, glass/solid card, inline buttons.
  modern,

  /// Classic onboarding style: dark overlay, white speech-bubble tooltip
  /// with pointer, Skip at bottom-left, prominent Next button.
  classic,

  /// Compact onboarding style: dark overlay, small tooltip bubble near the
  /// highlighted widget, with an inline Next pill and Skip at bottom-left.
  ///
  /// This is useful when you want a lightweight, email-app-style tooltip
  /// instead of a large coach card.
  compact,
}
