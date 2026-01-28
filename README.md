# Showcase Coach

<!-- ![Save Points Header](assets/screenshot.png) -->

Modern, design-forward showcase coach overlays for Flutter with smooth motion, glassmorphism, and sensible validation so you can guide users through product tours with confidence.

![Pub Version](https://img.shields.io/pub/v/save_points_showcaseview)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
<!-- ![Showcase Coach Screenshot](https://raw.githubusercontent.com/m7hamed-dev/save-points-showcaseview/main/assets/screenshot.png) -->

## Preview
![Showcase Coach Preview](https://cdn.jsdelivr.net/gh/m7hamed-dev/save_points_sa_privacy_polices@main/showcaseview-video.gif)

### 🚀 [**Try it live → Interactive Demo**](https://helpful-beignet-1d32ca.netlify.app/)

## Why use Showcase Coach?
- **Design-first**: Glassmorphism, elevated cards, and balanced typography that fit Material 3.
- **Safe by default**: Duplicate key detection, visibility checks, and user-friendly error dialogs with actionable guidance.
- **Flexible logic**: Per-step and global conditions (`shouldShow` / `showIf`) plus smart scrolling.
- **Motion-aware**: Reduced-motion mode, customizable transition animations, and comprehensive animation controls.
- **Rich visual effects**: Ripple, shimmer, particle effects, rotation, and customizable glow/shadow effects.
- **Accessible**: Built-in accessibility support with semantic labels, proper tap targets, and keyboard navigation.
- **Well-documented**: Comprehensive API documentation with examples and best practices.
- **Drop-in**: Simple API that works with any widget that has a `GlobalKey`.
- **Developer-friendly**: Debug mode, haptic feedback, auto-advance, and extensive customization options.

## Installation
Add to `pubspec.yaml`:
```yaml
dependencies:
  save_points_showcaseview: ^1.5.0
```
Then install:
```bash
flutter pub get
```

## Quick start (3 steps)
1) Create keys:
```dart
final _buttonKey = GlobalKey();
final _cardKey = GlobalKey();
```
2) Attach keys:
```dart
FilledButton(key: _buttonKey, onPressed: () {}, child: const Text('Click me'));
Card(key: _cardKey, child: const Text('Important card'));
```
3) Show the coach:
```dart
await ShowcaseCoach.show(
  context,
  steps: [
    CoachStep(
      targetKey: _buttonKey,
      title: 'Welcome!',
      description: ['This is your first step.'],
    ),
    CoachStep(
      targetKey: _cardKey,
      title: 'Feature Card',
      description: [
        'This card contains important information.',
        'Swipe to see more tips.',
      ],
    ),
  ],
);
```

## Full example
```dart
import 'package:flutter/material.dart';
import 'package:save_points_showcaseview/save_points_showcaseview.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _buttonKey = GlobalKey();
  final _cardKey = GlobalKey();

  Future<void> _startTour() async {
    await ShowcaseCoach.show(
      context,
      steps: [
        CoachStep(
          targetKey: _buttonKey,
          title: 'Action Button',
          description: ['Tap this button to perform an action.'],
        ),
        CoachStep(
          targetKey: _cardKey,
          title: 'Information Card',
          description: ['This card displays important information.'],
        ),
      ],
      onSkip: () => debugPrint('Tour skipped'),
      onDone: () => debugPrint('Tour completed'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FilledButton(
            key: _buttonKey,
            onPressed: _startTour,
            child: const Text('Start Tour'),
          ),
          Card(
            key: _cardKey,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Card content'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Configuration highlights

### Basic Configuration
- `ShowcaseCoachConfig` lets you tune:
  - `primaryColor`, `buttonColor`, `fontFamily`
  - `cardStyle`: `glass` (default) or `normal`
  - `overlayTintOpacity`
  - `reduceMotion`: disables blur/heavy effects
  - `showProgressIndicator`: show step progress (default: `true`)
  - `skipButtonText`: global text for skip buttons (can be overridden per-step or per-tour)
  - `nextButtonText`: global text for next buttons (can be overridden per-step or per-tour)

### Visual Effects
- **Ripple Effect**: `enableRippleEffect` - Expanding circular ripples
- **Shimmer Effect**: `enableShimmerEffect` - Shimmer animation on borders
- **Particle Effect**: `enableParticleEffect` - Floating particles around highlights
- **Glow & Shadow**: `glowIntensity`, `shadowIntensity` (0.0-2.0 range)
- **Border Styles**: `borderStyle` - `solid`, `dashed`, or `dotted`
- **Border Customization**: `borderWidth`, `borderRadius`
- **Highlight Shapes**: `highlightShape` - `roundedRectangle`, `circle`, or `rectangle`

### Animation Customization
- **Transition Animations**:
  - `enableTransitions`: enable/disable (defaults based on `reduceMotion`)
  - `transitionDuration`: global duration for all transitions
  - `transitionCurve`: global curve for all transitions
  - Individual durations: `backdropTransitionDuration`, `gradientTransitionDuration`, `highlightTransitionDuration`, `cardTransitionDuration`
- **Fade Animations**: `fadeAnimationDuration`, `fadeAnimationCurve`
- **Scale Animations**: `scaleAnimationDuration`, `scaleAnimationCurve`, `scaleAnimationRange`
- **Slide Animations**: `slideAnimationDuration`, `slideAnimationCurve`, `slideAnimationOffset`
- **Rotation Animation**: `enableRotationAnimation`, `rotationAnimationSpeed`, `rotationAngle`
- **Pulse & Bounce**: `pulseAnimationSpeed`, `bounceIntensity`
- **Animation Delays**: `animationDelay`, `staggerAnimationDelay`, `enableStaggerAnimations`
- **Animation Presets**: `animationPreset` - `defaultPreset`, `smooth`, `bouncy`, `quick`, `dramatic`
- **Animation Direction**: `animationDirection` - `normal`, `reverse`, `alternate`

### Interaction & Behavior
- **Haptic Feedback**: `enableHapticFeedback`, `hapticFeedbackType` (`light`, `medium`, `heavy`)
- **Auto-Advance**: `enableAutoAdvance` (per-step `autoAdvanceAfter` duration)
- **Touch Outside**: `dismissOnTapOutside` - dismiss tour by tapping outside
- **Debug Mode**: `debugMode` - visual debugging information

### Per-Step Options
- `shouldShow`: function returning bool (priority)
- `showIf`: simple bool (defaults to true)
- `onNext`, `onSkip`: custom callbacks per step
- `nextButtonText`, `skipButtonText`: custom button labels (highest priority - overrides config and tour-level)
- `showSkipButton`: hide skip button for critical steps
- `autoAdvanceAfter`: auto-advance duration for this step
- `leading`: custom icon/widget to display
- `imageUrl`, `imageAsset`: images in tooltip cards

### Button Text Customization
Button text can be customized at three levels (priority order):
1. **Step-level** (`CoachStep.nextButtonText` / `skipButtonText`) - highest priority
2. **Tour-level** (`ShowcaseCoach.show()` parameters) - medium priority
3. **Config-level** (`ShowcaseCoachConfig.nextButtonText` / `skipButtonText`) - default for all tours
4. **Built-in defaults** - "Next"/"Done" and "Skip" if none specified

### Advanced Configuration Examples

#### Visual Effects
```dart
ShowcaseCoachConfig(
  // Enable visual effects
  enableRippleEffect: true,
  enableShimmerEffect: true,
  enableParticleEffect: true,
  
  // Customize glow and shadows
  glowIntensity: 1.5,
  shadowIntensity: 0.8,
  
  // Border customization
  borderStyle: HighlightBorderStyle.dashed,
  borderWidth: 4.0,
  borderRadius: 16.0,
  highlightShape: HighlightShape.circle,
)
```

#### Animation Customization
```dart
ShowcaseCoachConfig(
  // Transition animations
  enableTransitions: true,
  transitionDuration: Duration(milliseconds: 300),
  transitionCurve: Curves.easeInOut,
  
  // Fade animations
  fadeAnimationDuration: Duration(milliseconds: 500),
  fadeAnimationCurve: Curves.easeInOut,
  
  // Scale animations
  scaleAnimationDuration: Duration(milliseconds: 800),
  scaleAnimationCurve: Curves.elasticOut,
  scaleAnimationRange: ScaleRange(0.5, 1.2),
  
  // Slide animations
  slideAnimationDuration: Duration(milliseconds: 600),
  slideAnimationCurve: Curves.easeInOutBack,
  slideAnimationOffset: Offset(50, 0),
  
  // Rotation animation
  enableRotationAnimation: true,
  rotationAnimationSpeed: 1.5,
  rotationAngle: 15.0,
  
  // Pulse and bounce
  pulseAnimationSpeed: 1.2,
  bounceIntensity: 1.5,
  
  // Animation delays and presets
  animationDelay: Duration(milliseconds: 200),
  staggerAnimationDelay: Duration(milliseconds: 100),
  enableStaggerAnimations: true,
  animationPreset: AnimationPreset.bouncy,
  animationDirection: AnimationDirection.alternate,
)
```

#### Interaction & Behavior
```dart
ShowcaseCoachConfig(
  // Haptic feedback
  enableHapticFeedback: true,
  hapticFeedbackType: HapticFeedbackType.medium,
  
  // Auto-advance
  enableAutoAdvance: true,
  
  // Touch outside to dismiss
  dismissOnTapOutside: true,
  
  // Debug mode
  debugMode: true,
  
  // Custom button text (global defaults)
  skipButtonText: 'Maybe Later',
  nextButtonText: 'Continue',
)
```

#### Per-Step Customization
```dart
CoachStep(
  targetKey: _buttonKey,
  title: 'Action Button',
  description: ['Tap this button to perform an action.'],
  
  // Custom callbacks
  onNext: () => print('Moving to next step'),
  onSkip: () => print('Skipping step'),
  
  // Custom button text (overrides config and tour-level)
  nextButtonText: 'Continue',
  skipButtonText: 'Maybe Later',
  showSkipButton: true,
  
  // Auto-advance
  autoAdvanceAfter: Duration(seconds: 5),
  
  // Visual content
  leading: Icon(Icons.settings, size: 48),
  imageUrl: 'https://example.com/screenshot.png',
  // or
  imageAsset: 'assets/images/guide.png',
)
```

#### Tour-Level Button Text Override
```dart
await ShowcaseCoach.show(
  context,
  steps: steps,
  // Override button text for this entire tour
  skipButtonText: 'Not Now',
  nextButtonText: 'Got it!',
  config: ShowcaseCoachConfig(
    // Config-level defaults (used if not overridden)
    skipButtonText: 'Maybe Later',
    nextButtonText: 'Continue',
  ),
);
```

## Validation and safety
- **Duplicate GlobalKey detection** before showing with clear error messages.
- **Visibility checks** ensure targets are attached and scroll into view automatically.
- **User-friendly error dialogs** instead of silent failures or crashes.
- **Comprehensive error messages** with actionable guidance and code examples.
- **Retry logic** for widgets that may not be immediately available.
- **Debug mode** for visualizing key bounds and validation status.

## Accessibility
- **Semantic labels** for screen readers on all interactive elements.
- **Minimum tap target sizes** (48x48) for better touch accessibility.
- **Proper button semantics** for assistive technologies.
- **Full keyboard navigation** support (arrow keys, Enter, Escape).
- **Reduced motion support** via `reduceMotion` flag.
- **Haptic feedback** for tactile confirmation (optional).

## Tips & best practices
1) **Wait for layout** before showing:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  ShowcaseCoach.show(context, steps: steps);
});
```

2) **Unique keys**: every step needs its own `GlobalKey`.

3) **Concise copy**: short titles and descriptions improve completion.

4) **Respect motion**: use `reduceMotion: true` where needed, or customize transition animations with `enableTransitions` and duration/curve options.

5) **Accessibility**: The library includes built-in accessibility support, but ensure your target widgets are also accessible.

6) **Visual effects**: Use effects sparingly - too many effects can be overwhelming. Start with subtle effects and increase intensity as needed.

7) **Animation presets**: Use `AnimationPreset` for quick styling - `smooth` for subtle, `bouncy` for playful, `quick` for snappy interactions.

8) **Debug mode**: Enable `debugMode: true` during development to visualize key bounds and troubleshoot issues.

9) **Haptic feedback**: Add haptic feedback for better mobile UX, especially for important steps.

10) **Image support**: Use `leading`, `imageUrl`, or `imageAsset` to add visual context to your tooltips.

## Troubleshooting
- **Nothing shows**: 
  - Confirm `Overlay.of(context)` is available (e.g., use inside a `MaterialApp`)
  - Run after the first frame using `WidgetsBinding.instance.addPostFrameCallback`
  - Check that steps are not filtered out by `shouldShow` / `showIf`
  
- **Step skipped**: 
  - Check `shouldShow` / `showIf` for that step
  - Verify the step's `isVisible` getter returns `true`
  
- **Target not found**: 
  - Ensure the widget has a unique `GlobalKey` and is mounted
  - Check for duplicate keys using `debugMode: true`
  - Verify the widget is visible and not hidden by conditional rendering
  
- **Animation errors**: 
  - Ensure `fadeAnimationDuration` is not longer than `scaleAnimationDuration` when using both
  - Check that `Interval` end values don't exceed 1.0
  - Use `reduceMotion: true` if experiencing performance issues
  
- **Visual effects not showing**: 
  - Check that `reduceMotion` is not enabled (disables many effects)
  - Verify effect flags are set to `true` in config
  - Ensure device supports the effects (some older devices may have limitations)

## Features Overview

### ✨ Visual Effects
- Ripple effects with expanding circles
- Shimmer/sparkle animations on borders
- Particle effects with floating particles
- Customizable glow and shadow intensities
- Multiple border styles (solid, dashed, dotted)
- Flexible highlight shapes (rounded rectangle, circle, rectangle)

### 🎬 Animation System
- Comprehensive animation customization (fade, scale, slide, rotation)
- Animation presets for quick styling
- Animation delays and stagger effects
- Configurable animation directions
- Pulse and bounce intensity controls

### 🎯 Interaction Features
- Haptic feedback support
- Auto-advance functionality
- Touch outside to dismiss
- Keyboard navigation
- Step callbacks (`onStepStart`, `onStepComplete`, `onStepChanged`)

### 🛠️ Developer Tools
- Debug mode with visual indicators
- Enhanced error messages with actionable guidance
- Image/icon support in tooltips
- Custom button actions per step
- Progress indicators

### ♿ Accessibility
- Screen reader support
- Keyboard navigation
- Reduced motion support
- Proper semantic labels
- Minimum tap target sizes

## Version History

- **v1.5.0**: Customizable button text at config, tour, and step levels
- **v1.4.0**: Advanced animation customization, rotation, presets, delays
- **v1.3.0**: Particle effects, shape customization, debug mode, touch outside dismiss
- **v1.2.0**: Ripple, shimmer, glow/shadow customization, border styles
- **v1.1.0**: Haptic feedback, auto-advance, image support, improved errors
- **v1.0.3**: Transition animation controls
- **v1.0.2**: Comprehensive documentation, accessibility support
- **v1.0.0**: Initial release

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Contributing
Issues and PRs are welcome! Open one at:
https://github.com/m7hamed-dev/save-points-showcaseview/issues

## License
MIT License. See `LICENSE` for details.
