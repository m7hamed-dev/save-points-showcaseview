# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2025-01-28

### Added
- **Rotation Animation**: Added optional rotation animation for highlights
  - `enableRotationAnimation` boolean in `ShowcaseCoachConfig` (default: `false`)
  - `rotationAnimationSpeed` double for controlling rotation speed (default: `1.0`, range: 0.5-3.0)
  - `rotationAngle` double for maximum rotation angle in degrees (default: `0.0`, range: 0.0-360.0)
  - Creates dynamic spinning effect for attention-grabbing highlights
- **Fade Animation Customization**: Added fine-grained control over fade animations
  - `fadeAnimationDuration` Duration for fade animation timing
  - `fadeAnimationCurve` Curve for fade animation curves
  - Customizable fade-in and fade-out effects
- **Scale Animation Customization**: Added comprehensive scale animation options
  - `scaleAnimationDuration` Duration for scale animation timing
  - `scaleAnimationCurve` Curve for scale animation curves
  - `scaleAnimationRange` ScaleRange class for defining scale begin/end values
  - Full control over scale-up and scale-down animations
- **Slide Animation Customization**: Added customizable slide animations
  - `slideAnimationDuration` Duration for slide animation timing
  - `slideAnimationCurve` Curve for slide animation curves
  - `slideAnimationOffset` Offset for custom slide starting positions
  - Flexible slide directions and distances
- **Animation Delay Options**: Added delay controls for animations
  - `animationDelay` Duration for delaying all animations
  - `staggerAnimationDelay` Duration for staggering multiple animations
  - `enableStaggerAnimations` boolean for cascading animation effects
  - Better coordination of complex multi-element animations
- **Animation Presets**: Added pre-configured animation styles
  - `AnimationPreset` enum with options: `defaultPreset`, `smooth`, `bouncy`, `quick`, `dramatic`
  - Quick way to apply common animation styles
- **Animation Direction**: Added animation direction control
  - `AnimationDirection` enum with options: `normal`, `reverse`, `alternate`
  - Control animation playback direction
- **ScaleRange Class**: Added utility class for scale animation ranges
  - `ScaleRange(begin, end)` constructor for defining scale ranges
  - Simplifies scale animation configuration

### Improved
- Enhanced animation customization with granular control over all animation types
- Better animation coordination with delay and stagger options
- More flexible animation system with presets and directions
- Improved developer experience with comprehensive animation options

## [1.3.0] - 2025-01-28

### Added
- **Particle/Sparkle Effect**: Added optional particle effect with floating particles around highlights
  - `enableParticleEffect` boolean in `ShowcaseCoachConfig` (default: `false`)
  - Creates magical floating particles for enhanced visual appeal
- **Pulse Animation Speed**: Added control over pulse animation speed
  - `pulseAnimationSpeed` double in `ShowcaseCoachConfig` (default: `1.0`, range: 0.5-3.0)
  - Allows customizing the speed of pulse animations
- **Bounce Intensity**: Added control over bounce animation intensity
  - `bounceIntensity` double in `ShowcaseCoachConfig` (default: `1.0`, range: 0.0-2.0)
  - Enables fine-tuning of bounce effect strength
- **Border Customization**: Added border width and radius customization
  - `borderWidth` double in `ShowcaseCoachConfig` (default: `3.0`)
  - `borderRadius` double in `ShowcaseCoachConfig` (default: `24.0`)
  - Full control over highlight border appearance
- **Highlight Shape Options**: Added different highlight shapes
  - `highlightShape` enum with options: `roundedRectangle`, `circle`, `rectangle`
  - `HighlightShape` enum for selecting highlight shape
  - Supports circular, rectangular, and rounded rectangular highlights
- **Touch Outside to Dismiss**: Added option to dismiss tour by tapping outside
  - `dismissOnTapOutside` boolean in `ShowcaseCoachConfig` (default: `false`)
  - Provides intuitive way to exit tours
- **Debug Mode**: Added debug visualization mode
  - `debugMode` boolean in `ShowcaseCoachConfig` (default: `false`)
  - Shows visual indicators for GlobalKey bounds, step information, and validation status
  - Useful for debugging tour setup issues

### Improved
- Enhanced visual customization with shape options
- Better animation control with speed and intensity multipliers
- More flexible highlight styling options
- Improved developer experience with debug mode

## [1.2.0] - 2025-01-28

### Added
- **Ripple Effect**: Added optional ripple effect that creates expanding circles from the highlight
  - `enableRippleEffect` boolean in `ShowcaseCoachConfig` (default: `false`)
  - Creates dynamic expanding circular ripples for enhanced visual appeal
- **Glow Intensity Customization**: Added control over glow effect intensity
  - `glowIntensity` double in `ShowcaseCoachConfig` (default: `1.0`, range: 0.0-2.0)
  - Allows fine-tuning the intensity of the glow around highlighted widgets
- **Shadow Customization**: Added control over shadow effects
  - `shadowIntensity` double in `ShowcaseCoachConfig` (default: `1.0`, range: 0.0-2.0)
  - Enables customization of shadow depth and prominence
- **Border Style Options**: Added different border styles for highlights
  - `borderStyle` enum in `ShowcaseCoachConfig` with options: `solid`, `dashed`, `dotted`
  - `HighlightBorderStyle` enum for selecting border appearance
- **Shimmer Effect**: Added optional shimmer/sparkle effect for premium look
  - `enableShimmerEffect` boolean in `ShowcaseCoachConfig` (default: `false`)
  - Creates a subtle shimmer animation across the highlight border

### Improved
- Enhanced visual customization options for highlights
- More flexible styling with intensity multipliers
- Better visual effects for premium user experiences

## [1.1.0] - 2025-01-28

### Added
- **Haptic Feedback Support**: Added optional haptic feedback for step changes
  - `enableHapticFeedback` boolean in `ShowcaseCoachConfig` (default: `false`)
  - `hapticFeedbackType` enum with options: `light`, `medium`, `heavy` (default: `medium`)
  - Provides tactile feedback when transitioning between steps and completing tours
- **Auto-Advance Feature**: Added auto-advance functionality for demo modes and kiosk displays
  - `enableAutoAdvance` boolean in `ShowcaseCoachConfig` (default: `false`)
  - `autoAdvanceAfter` duration in `CoachStep` for per-step auto-advance timing
  - Steps can automatically proceed after a specified duration
- **Image/Icon Support**: Added support for visual content in tooltip cards
  - `leading` widget property in `CoachStep` for custom icons or widgets
  - `imageUrl` property for network images
  - `imageAsset` property for local asset images
  - Images are displayed above the description with proper error handling
- **Enhanced Error Messages**: Improved validation error messages with actionable solutions
  - More descriptive error messages for duplicate keys
  - Detailed troubleshooting steps for missing/invisible widgets
  - Common causes and solutions provided for each error type
  - Error dialogs now support text selection for easier debugging

### Improved
- Better error handling with actionable suggestions and code examples
- Error dialogs now use scrollable content for long error messages
- More user-friendly error messages that help developers fix issues quickly

## [1.0.3] - 2025-01-XX

### Added
- Optional transition animation configuration in `ShowcaseCoachConfig`:
  - `enableTransitions`: Enable/disable transition animations between steps (defaults based on `reduceMotion`)
  - `transitionDuration`: Global duration for all transition animations
  - `transitionCurve`: Global curve for all transition animations
  - `backdropTransitionDuration`: Custom duration for backdrop hole transitions
  - `gradientTransitionDuration`: Custom duration for gradient overlay transitions
  - `highlightTransitionDuration`: Custom duration for highlight position transitions
  - `cardTransitionDuration`: Custom duration for tooltip card transitions
- Fine-grained control over transition animations with individual duration settings
- Automatic transition disabling when `reduceMotion` is enabled

### Improved
- Better animation control with configurable durations and curves
- Transitions now respect `reduceMotion` setting automatically

## [1.0.2] - 2025-12-14

### Added
- Comprehensive dartdoc documentation for all public APIs
- Accessibility support with semantic labels for screen readers
- Minimum tap target sizes (48x48) for better accessibility compliance
- Internal constants class for better code maintainability

### Improved
- Enhanced code organization with proper part-of directives
- Better error handling with more descriptive validation messages
- Improved type safety throughout the codebase
- Extracted magic numbers to named constants for better maintainability
- Added library-level documentation with quick start examples
- Improved documentation for all classes, methods, and parameters

### Changed
- Internal refactoring for better code organization
- Validation retry logic now uses configurable constants
- Animation durations and values now centralized in constants class

## [1.0.1] - 2024-12-10

### Fixed
- Updated repository URLs in README and pubspec.yaml to match actual GitHub repository
- Fixed image URLs to use absolute GitHub raw URLs for proper display on pub.dev
- Compressed preview GIF for better pub.dev compatibility

## [1.0.0] - 2024-12-19

### Added
- Initial release of Showcase Coach
- Beautiful glassmorphism design with backdrop blur
- Smooth animations and transitions
- Step-by-step guided tour functionality
- Conditional step visibility support
- Automatic validation of GlobalKeys
- Smart scrolling to bring widgets into view
- Dark mode support
- Multiple description pages with swipe navigation
- Pulsing highlight animations
- User-friendly error dialogs
- Customizable colors and styling

### Features
- `ShowcaseCoach.show()` - Main method to display the showcase
- `CoachStep` - Class to define showcase steps
- Automatic duplicate key detection
- Widget visibility validation
- Smooth step transitions
- Modern UI with glassmorphism effects

