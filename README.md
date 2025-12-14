# Showcase Coach

<!-- ![Save Points Header](assets/screenshot.png) -->

Modern, design-forward showcase coach overlays for Flutter with smooth motion, glassmorphism, and sensible validation so you can guide users through product tours with confidence.

![Pub Version](https://img.shields.io/pub/v/save_points_showcaseview)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Showcase Coach Screenshot](https://raw.githubusercontent.com/m7hamed-dev/save-points-showcaseview/main/assets/screenshot.png)

## Preview
![Showcase Coach Preview](https://cdn.jsdelivr.net/gh/m7hamed-dev/save_points_sa_privacy_polices@main/showcaseview-video.gif)

## Why use Showcase Coach?
- **Design-first**: Glassmorphism, elevated cards, and balanced typography that fit Material 3.
- **Safe by default**: Duplicate key detection, visibility checks, and user-friendly error dialogs.
- **Flexible logic**: Per-step and global conditions (`shouldShow` / `showIf`) plus smart scrolling.
- **Motion-aware**: Reduced-motion mode to turn off blur and heavy effects.
- **Drop-in**: Simple API that works with any widget that has a `GlobalKey`.

## Installation
Add to `pubspec.yaml`:
```yaml
dependencies:
  save_points_showcaseview: ^1.0.0
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
- `ShowcaseCoachConfig` lets you tune:
  - `primaryColor`, `buttonColor`, `fontFamily`
  - `cardStyle`: `glass` (default) or `normal`
  - `overlayTintOpacity`
  - `reduceMotion`: disables blur/heavy effects
- Per-step logic:
  - `shouldShow`: function returning bool (priority)
  - `showIf`: simple bool (defaults to true)

## Validation and safety
- Duplicate GlobalKey detection before showing.
- Visibility checks ensure targets are attached and scroll into view.
- Friendly dialogs instead of silent failures or crashes.

## Tips & best practices
1) **Wait for layout** before showing:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  ShowcaseCoach.show(context, steps: steps);
});
```
2) **Unique keys**: every step needs its own `GlobalKey`.
3) **Concise copy**: short titles and descriptions improve completion.
4) **Respect motion**: use `reduceMotion: true` where needed.

## Troubleshooting
- **Nothing shows**: confirm `Overlay.of(context)` is available (e.g., use inside a `MaterialApp`), and run after the first frame.
- **Step skipped**: check `shouldShow` / `showIf` for that step.
- **Target not found**: ensure the widget has a unique `GlobalKey` and is mounted.

## Contributing
Issues and PRs are welcome! Open one at:
https://github.com/m7hamed-dev/save-points-showcaseview/issues

## License
MIT License. See `LICENSE` for details.
