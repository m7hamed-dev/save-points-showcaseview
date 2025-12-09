import 'package:flutter/material.dart';
import 'package:save_points_showcaseview/save_points_showcaseview.dart';

class ExampleCoachPage extends StatefulWidget {
  const ExampleCoachPage({super.key});

  @override
  State<ExampleCoachPage> createState() => _ExampleCoachPageState();
}

class _ExampleCoachPageState extends State<ExampleCoachPage> {
  ///! keys for the widgets to highlight
  final _cardKey = GlobalKey();
  final _ctaKey = GlobalKey();
  final _infoKey = GlobalKey();
  final _homeKey = GlobalKey();
  final _settingsKey = GlobalKey();
  final _centerTextKey = GlobalKey();

  ///
  Future<void> _startCoach() async {
    await ShowcaseCoach.show(
      context,
      config: const ShowcaseCoachConfig(
        fontFamily: 'Inter',
        primaryColor: Color.fromARGB(255, 28, 17, 233),
        overlayTintOpacity: 0.12,
        titleStyle: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        bodyStyle: TextStyle(
          fontSize: 15.5,
          height: 1.6,
        ),
        buttonTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      steps: [
        CoachStep(
          targetKey: _cardKey,
          title: 'Feature card',
          description: [
            'A simple surface that can hold any widget.',
            'Use keys to spotlight anything in your UI.',
          ],
        ),
        CoachStep(
          targetKey: _infoKey,
          title: 'Info action',
          description: ['Attach to icons, buttons, or rows.'],
        ),
        CoachStep(
          targetKey: _ctaKey,
          title: 'Primary action',
          description: ['Your main call-to-action goes here.'],
        ),
        CoachStep(
          targetKey: _homeKey,
          title: 'Home',
          description: ['Your main call-to-action goes here.'],
        ),
        CoachStep(
          targetKey: _settingsKey,
          title: 'Settings',
          description: ['Your main call-to-action goes here.'],
        ),
        CoachStep(
          targetKey: _centerTextKey,
          title: 'Center text',
          description: ['Your main call-to-action goes here.'],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example with Widgets'),
        actions: [
          IconButton(
            key: _infoKey,
            icon: const Icon(Icons.info_outline),
            onPressed: _startCoach,
            tooltip: 'Show coach overlay',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              key: _cardKey,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reusable surface',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Highlight any widget with a CoachStep: cards, buttons, '
                      'list tiles, or custom layouts.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            // const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: _ctaKey,
                onPressed: _startCoach,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start coach overlay'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              key: _centerTextKey,
              child: Center(
                child: Text(
                  'Highlight any widget with a CoachStep: cards, buttons, '
                  'list tiles, or custom layouts.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            key: _homeKey,
            icon: const Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            key: _settingsKey,
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
