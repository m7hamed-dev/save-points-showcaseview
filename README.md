# Showcase Coach

A beautiful, modern showcase coach overlay for Flutter with smooth animations, glassmorphism effects, and step-by-step guided tours. Perfect for onboarding flows, feature highlights, and user guidance.

![Showcase Coach](https://img.shields.io/pub/v/save_points_showcaseview)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

✨ **Modern Design**
- Glassmorphism effects with backdrop blur
- Smooth animations and transitions
- Dark mode support
- Customizable colors and styling

🎯 **Easy to Use**
- Simple API with minimal setup
- Automatic validation of GlobalKeys
- Smart scrolling to bring widgets into view
- Conditional step visibility

🎨 **Beautiful Animations**
- Smooth step transitions
- Pulsing highlight borders
- Fade and slide animations
- Customizable animation curves

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  save_points_showcaseview: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Create GlobalKeys for your widgets

```dart
final _buttonKey = GlobalKey();
final _cardKey = GlobalKey();
```

### 2. Assign keys to your widgets

```dart
FilledButton(
  key: _buttonKey,
  onPressed: () {},
  child: Text('Click me'),
)

Card(
  key: _cardKey,
  child: Text('Important card'),
)
```

### 3. Show the showcase coach

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

## Usage

### Basic Example

```dart
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
      onDone: () {
        print('Tour completed!');
      },
      onSkip: () {
        print('Tour skipped!');
      },
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
            child: Text('Start Tour'),
          ),
          Card(
            key: _cardKey,
            child: Text('Card content'),
          ),
        ],
      ),
    );
  }
}
```

### Conditional Steps

You can conditionally show steps based on your app's state:

```dart
CoachStep(
  targetKey: _premiumKey,
  title: 'Premium Feature',
  description: ['This is a premium feature.'],
  shouldShow: () => user.isPremium, // Only show for premium users
),
```

Or use a simple boolean:

```dart
CoachStep(
  targetKey: _featureKey,
  title: 'New Feature',
  description: ['Check out this new feature!'],
  showIf: hasNewFeature,
),
```

### Multiple Descriptions

For longer explanations, you can provide multiple descriptions that users can swipe through:

```dart
CoachStep(
  targetKey: _complexKey,
  title: 'Complex Feature',
  description: [
    'This feature has multiple aspects.',
    'Swipe to learn more about each one.',
    'You can add as many descriptions as needed.',
  ],
),
```

### Global Conditions

Control whether the entire showcase should be shown:

```dart
await ShowcaseCoach.show(
  context,
  steps: steps,
  shouldShow: () => !hasSeenTourBefore,
  // or
  showIf: shouldShowTour,
);
```

## API Reference

### `ShowcaseCoach.show()`

Displays the showcase coach overlay.

**Parameters:**
- `context` (required): BuildContext
- `steps` (required): List of CoachStep objects
- `onSkip` (optional): Callback when user skips the tour
- `onDone` (optional): Callback when tour is completed
- `shouldShow` (optional): Function that returns bool to conditionally show
- `showIf` (optional): Simple boolean to conditionally show (defaults to true)

### `CoachStep`

Represents a single step in the showcase.

**Properties:**
- `targetKey` (required): GlobalKey of the widget to highlight
- `title` (required): Title text displayed in the tooltip
- `description` (required): List of description strings (supports multiple pages)
- `shouldShow` (optional): Function that returns bool to conditionally show this step
- `showIf` (optional): Simple boolean to conditionally show this step (defaults to true)

## Validation

The package automatically validates:

- ✅ **Duplicate Keys**: Ensures each step uses a unique GlobalKey
- ✅ **Visible Widgets**: Checks that all target widgets are visible and attached
- ✅ **User-Friendly Errors**: Shows helpful error dialogs instead of crashing

## Styling

The showcase coach automatically adapts to your app's theme:

- Uses your `ThemeData.colorScheme.primary` for accents
- Supports both light and dark themes
- Respects Material 3 design system

## Best Practices

1. **Wait for Layout**: Ensure widgets are built before showing the showcase:
   ```dart
   WidgetsBinding.instance.addPostFrameCallback((_) {
     ShowcaseCoach.show(context, steps: steps);
   });
   ```

2. **Unique Keys**: Always use unique GlobalKeys for each step

3. **Descriptive Titles**: Use clear, concise titles for each step

4. **Keep Descriptions Short**: For better UX, keep descriptions brief and actionable

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues or have feature requests, please file them on the [GitHub issue tracker](https://github.com/yourusername/save_points_showcaseview/issues).
