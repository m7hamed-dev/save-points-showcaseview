# Enhancement Implementation Examples

This document provides code examples for implementing the proposed enhancements.

## Example 1: Step Change Callbacks

### Updated `ShowcaseCoach.show()` Method

```dart
static Future<void> show(
  BuildContext context, {
  required List<CoachStep> steps,
  ShowcaseCoachConfig? config,
  VoidCallback? onSkip,
  VoidCallback? onDone,
  bool Function()? shouldShow,
  bool showIf = true,
  // NEW: Step lifecycle callbacks
  void Function(int currentStep, int totalSteps)? onStepChanged,
  void Function(int stepIndex, CoachStep step)? onStepStart,
  void Function(int stepIndex, CoachStep step)? onStepComplete,
}) async {
  // ... existing validation code ...

  final controller = ValueNotifier<int>(0);
  late OverlayEntry entry;

  // Call onStepStart when tour begins
  onStepStart?.call(0, visibleSteps[0]);

  entry = OverlayEntry(
    builder: (context) {
      return ValueListenableBuilder<int>(
        valueListenable: controller,
        builder: (context, index, _) {
          final step = visibleSteps[index];
          
          // Call onStepChanged whenever step changes
          onStepChanged?.call(index + 1, visibleSteps.length);
          
          // Call onStepStart for new step (after first)
          if (index > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onStepStart?.call(index, step);
            });
          }

          final rect = targetRect(step.targetKey);
          return _CoachOverlay(
            step: step,
            rect: rect,
            isLast: index == visibleSteps.length - 1,
            onNext: () {
              // Call onStepComplete before moving to next
              onStepComplete?.call(index, step);
              
              if (index == visibleSteps.length - 1) {
                onDone?.call();
                close();
              } else {
                controller.value = index + 1;
              }
            },
            onSkip: () {
              onSkip?.call();
              close();
            },
            config: config,
          );
        },
      );
    },
  );

  overlay.insert(entry);
}
```

### Usage Example

```dart
await ShowcaseCoach.show(
  context,
  steps: steps,
  onStepChanged: (current, total) {
    print('Step $current of $total');
    // Track analytics
    analytics.logEvent('showcase_step_viewed', {
      'step': current,
      'total': total,
    });
  },
  onStepStart: (index, step) {
    print('Started step: ${step.title}');
    // Trigger custom animations
    // Preload resources for next step
  },
  onStepComplete: (index, step) {
    print('Completed step: ${step.title}');
    // Save progress
    // Update UI state
  },
);
```

---

## Example 2: Step Progress Indicator

### Updated `ShowcaseCoachConfig`

```dart
class ShowcaseCoachConfig {
  // ... existing fields ...
  
  /// Whether to show a progress indicator (e.g., "Step 2 of 5").
  /// Defaults to `true`.
  final bool showProgressIndicator;
  
  /// Position of the progress indicator.
  /// Defaults to [ProgressIndicatorPosition.header].
  final ProgressIndicatorPosition progressIndicatorPosition;
  
  /// Custom progress indicator widget builder.
  /// If provided, this overrides the default progress indicator.
  final Widget Function(int current, int total)? progressIndicatorBuilder;
}

enum ProgressIndicatorPosition {
  header,  // In tooltip card header
  footer,  // Below tooltip card
  overlay,  // Top of overlay
}
```

### Updated `_TooltipCard` Widget

```dart
class _TooltipCard extends StatelessWidget {
  const _TooltipCard({
    // ... existing params ...
    required this.currentStep,
    required this.totalSteps,
    this.config,
  });

  final int currentStep;
  final int totalSteps;
  final ShowcaseCoachConfig? config;

  @override
  Widget build(BuildContext context) {
    // ... existing build code ...
    
    Widget progressWidget = _buildProgressIndicator();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (config?.progressIndicatorPosition == ProgressIndicatorPosition.overlay)
          progressWidget,
        // ... existing card widget ...
        if (config?.progressIndicatorPosition == ProgressIndicatorPosition.footer)
          progressWidget,
      ],
    );
  }
  
  Widget _buildProgressIndicator() {
    if (config?.showProgressIndicator == false) {
      return const SizedBox.shrink();
    }
    
    if (config?.progressIndicatorBuilder != null) {
      return config!.progressIndicatorBuilder!(currentStep, totalSteps);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Step $currentStep of $totalSteps',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                config?.primaryColor ?? Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Example 3: Tour Persistence

### New `ShowcaseCoachPersistence` Class

```dart
import 'package:shared_preferences/shared_preferences.dart';

class ShowcaseCoachPersistence {
  static const String _keyPrefix = 'showcase_coach_';
  
  /// Save tour completion state
  static Future<void> saveTourCompletion(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_keyPrefix$tourId', true);
  }
  
  /// Check if tour has been completed
  static Future<bool> isTourCompleted(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_keyPrefix$tourId') ?? false;
  }
  
  /// Save tour progress (last completed step)
  static Future<void> saveTourProgress(String tourId, int lastStep) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_keyPrefix}progress_$tourId', lastStep);
  }
  
  /// Get last completed step
  static Future<int> getTourProgress(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('${_keyPrefix}progress_$tourId') ?? -1;
  }
  
  /// Clear tour data
  static Future<void> clearTour(String tourId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$tourId');
    await prefs.remove('${_keyPrefix}progress_$tourId');
  }
}
```

### Updated `ShowcaseCoach.show()` Method

```dart
static Future<void> show(
  BuildContext context, {
  required List<CoachStep> steps,
  ShowcaseCoachConfig? config,
  // ... existing params ...
  String? tourId,  // NEW: Unique tour identifier
  bool persistProgress = false,  // NEW: Whether to save progress
  int? startFromStep,  // NEW: Resume from specific step
}) async {
  // ... existing validation ...
  
  // Check if tour should be shown
  if (tourId != null && persistProgress) {
    final isCompleted = await ShowcaseCoachPersistence.isTourCompleted(tourId);
    if (isCompleted && startFromStep == null) {
      // Tour already completed, don't show again
      return;
    }
    
    // Resume from last step if not specified
    if (startFromStep == null) {
      final lastStep = await ShowcaseCoachPersistence.getTourProgress(tourId);
      if (lastStep >= 0 && lastStep < visibleSteps.length) {
        startFromStep = lastStep;
      }
    }
  }
  
  final initialStep = startFromStep ?? 0;
  final controller = ValueNotifier<int>(initialStep);
  
  // ... rest of implementation ...
  
  // Save progress on step change
  onStepChanged: (current, total) {
    if (tourId != null && persistProgress) {
      ShowcaseCoachPersistence.saveTourProgress(tourId, current - 1);
    }
  },
  
  // Save completion on done
  onDone: () {
    if (tourId != null && persistProgress) {
      ShowcaseCoachPersistence.saveTourCompletion(tourId);
    }
    onDone?.call();
  },
}
```

### Usage Example

```dart
// Show tour with persistence
await ShowcaseCoach.show(
  context,
  steps: steps,
  tourId: 'onboarding_v1',
  persistProgress: true,
  onDone: () {
    print('Onboarding completed!');
  },
);

// Check if tour should be shown
final shouldShow = !await ShowcaseCoachPersistence.isTourCompleted('onboarding_v1');

// Resume from last step
await ShowcaseCoach.show(
  context,
  steps: steps,
  tourId: 'onboarding_v1',
  persistProgress: true,
  startFromStep: 3,  // Resume from step 4
);
```

---

## Example 4: Custom Button Actions Per Step

### Updated `CoachStep` Class

```dart
class CoachStep {
  // ... existing fields ...
  
  /// Custom action to execute when "Next" button is pressed.
  /// If provided, this is called before advancing to the next step.
  final VoidCallback? onNext;
  
  /// Custom action to execute when "Skip" button is pressed.
  /// If provided, this is called before skipping the tour.
  final VoidCallback? onSkip;
  
  /// Custom text for the "Next" button.
  /// If not provided, defaults to "Next" or "Done" for the last step.
  final String? nextButtonText;
  
  /// Custom text for the "Skip" button.
  /// If not provided, defaults to "Skip".
  final String? skipButtonText;
  
  /// Whether to show the skip button for this step.
  /// Defaults to `true`.
  final bool showSkipButton;
}
```

### Updated `_CardSurface` Widget

```dart
class _CardSurface extends StatelessWidget {
  const _CardSurface({
    // ... existing params ...
    required this.step,  // Pass full step object
  });
  
  final CoachStep step;
  
  @override
  Widget build(BuildContext context) {
    // ... existing build code ...
    
    final nextText = step.nextButtonText ?? 
        (isLast ? 'Done' : 'Next');
    final skipText = step.skipButtonText ?? 'Skip';
    
    return Column(
      children: [
        // ... existing content ...
        Row(
          children: [
            if (step.showSkipButton)
              TextButton(
                onPressed: () {
                  step.onSkip?.call();
                  onSkip?.call();
                },
                child: Text(skipText),
              ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                step.onNext?.call();
                onNext();
              },
              child: Text(nextText),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Usage Example

```dart
CoachStep(
  targetKey: _buttonKey,
  title: 'Action Button',
  description: ['Tap this button to perform an action.'],
  onNext: () {
    // Navigate to next screen
    Navigator.push(context, MaterialPageRoute(builder: (_) => NextScreen()));
  },
  nextButtonText: 'Continue',
  showSkipButton: false,  // Hide skip for important steps
),
```

---

## Example 5: Image/Icon Support

### Updated `CoachStep` Class

```dart
class CoachStep {
  // ... existing fields ...
  
  /// Optional leading widget (icon or image) to display in the tooltip card.
  final Widget? leading;
  
  /// Optional network image URL to display in the tooltip card.
  final String? imageUrl;
  
  /// Optional asset image to display in the tooltip card.
  final String? imageAsset;
  
  /// Alignment of the image/icon.
  /// Defaults to [Alignment.topCenter].
  final Alignment imageAlignment;
}
```

### Updated `_CardSurface` Widget

```dart
Widget _buildLeading() {
  if (step.leading != null) {
    return step.leading!;
  }
  
  if (step.imageUrl != null) {
    return Image.network(
      step.imageUrl!,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }
  
  if (step.imageAsset != null) {
    return Image.asset(
      step.imageAsset!,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }
  
  return const SizedBox.shrink();
}

@override
Widget build(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (step.leading != null || step.imageUrl != null || step.imageAsset != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildLeading(),
        ),
      // ... rest of card content ...
    ],
  );
}
```

### Usage Example

```dart
CoachStep(
  targetKey: _featureKey,
  title: 'New Feature',
  description: ['Check out this amazing new feature!'],
  leading: Icon(Icons.star, size: 48, color: Colors.amber),
  // OR
  imageUrl: 'https://example.com/feature-preview.png',
  // OR
  imageAsset: 'assets/images/feature.png',
),
```

---

## Example 6: Keyboard Navigation

### Updated `_CoachOverlay` Widget

```dart
class _CoachOverlay extends StatefulWidget {
  // ... existing params ...
  
  @override
  State<_CoachOverlay> createState() => _CoachOverlayState();
}

class _CoachOverlayState extends State<_CoachOverlay> {
  @override
  void initState() {
    super.initState();
    // Focus node for keyboard handling
    FocusScope.of(context).requestFocus(FocusNode());
  }
  
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowRight:
            case LogicalKeyboardKey.enter:
              if (!widget.isLast) {
                widget.onNext();
              } else {
                widget.onDone?.call();
              }
              break;
            case LogicalKeyboardKey.arrowLeft:
              // Go to previous step (if implemented)
              break;
            case LogicalKeyboardKey.escape:
              widget.onSkip?.call();
              break;
          }
        }
      },
      child: // ... existing overlay widget ...
    );
  }
}
```

---

## Summary

These examples demonstrate how to implement the proposed enhancements while maintaining:
- Backward compatibility
- Clean API design
- Type safety
- Good documentation
- Performance considerations

Each enhancement can be implemented independently, allowing for incremental improvements to the package.

