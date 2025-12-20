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
        primaryColor: Color(0xFF4C4AE8),
        overlayTintOpacity: 0.12,
        cardStyle: ShowcaseCoachCardStyle.normal, // higher-contrast card
        reduceMotion: true, // disables blur behind overlay for clarity
        showProgressIndicator: true, // Show step progress
        titleStyle: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          color: Color(0xFF0F172A),
        ),
        bodyStyle: TextStyle(
          fontSize: 15.5,
          height: 1.6,
          color: Color(0xFF1F2937),
        ),
        buttonTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      // Step change callbacks for analytics/tracking
      onStepChanged: (current, total) {
        debugPrint('Step $current of $total');
      },
      onStepStart: (index, step) {
        debugPrint('Started step: ${step.title}');
      },
      onStepComplete: (index, step) {
        debugPrint('Completed step: ${step.title}');
      },
      steps: [
        CoachStep(
          targetKey: _cardKey,
          title: 'Context card',
          description: [
            'Use a friendly, elevated card to explain what the user is seeing.',
            'Any widget can be targeted as long as it has a unique GlobalKey.',
          ],
        ),
        CoachStep(
          targetKey: _infoKey,
          title: 'Quick info icon',
          description: [
            'Attach steps to icons, chips, or any tappable element.',
          ],
          // Custom button text example
          nextButtonText: 'Got it!',
        ),
        CoachStep(
          targetKey: _ctaKey,
          title: 'Primary call-to-action',
          description: ['Highlight the action you want users to take next.'],
          // Custom action on next
          onNext: () {
            debugPrint('Custom action: User proceeding to CTA step');
          },
        ),
        CoachStep(
          targetKey: _homeKey,
          title: 'Navigation item',
          description: ['Bottom navigation items can also be showcased.'],
        ),
        CoachStep(
          targetKey: _settingsKey,
          title: 'Another navigation item',
          description: ['You can guide users through multiple destinations.'],
          // Hide skip button for important step
          showSkipButton: false,
        ),
        CoachStep(
          targetKey: _centerTextKey,
          title: 'Content highlight',
          description: [
            'Call attention to messaging or tips inside the layout.',
          ],
          // Custom button text for last step
          nextButtonText: 'Finish',
        ),
      ],
      onDone: () {
        debugPrint('Tour completed!');
      },
      onSkip: () {
        debugPrint('Tour skipped');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Save Points',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Guided product tour',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: _infoKey,
            icon: const Icon(Icons.info_outline),
            onPressed: _startCoach,
            tooltip: 'Show coach overlay',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF4F3FF),
                    Color(0xFFE8EEFF),
                    Color(0xFFFDFBFF),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Showcase ready',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _startCoach,
                        icon: const Icon(Icons.play_circle),
                        label: const Text('Preview'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Design-first coach overlays',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Blend in with your product while guiding users through the key moments of your experience.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  _HighlightCard(
                    key: _cardKey,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _InfoChip(
                        label: 'Microcopy',
                        icon: Icons.chat_bubble_outline,
                        background: colorScheme.secondaryContainer,
                        foreground: colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        label: 'Focus',
                        icon: Icons.center_focus_strong,
                        background: colorScheme.tertiaryContainer,
                        foreground: colorScheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        label: 'Motion-safe',
                        icon: Icons.reduce_capacity,
                        background: colorScheme.surfaceContainerHighest,
                        foreground: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: _ctaKey,
                      onPressed: _startCoach,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Start guided overlay'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 14,
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _startCoach,
                    child: const Text('Replay last tour'),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    key: _centerTextKey,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why this works',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Each step blends with your UI, keeps copy concise, and avoids overwhelming the user.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Adaptive overlay respects motion settings',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Readable typography and balanced spacing',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
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

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.route,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Step through complex journeys with clarity.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(Icons.drag_handle, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Transparent overlays keep the UI readable while focusing attention.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoStat(
                label: 'Delay',
                value: '50 ms',
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              _InfoStat(
                label: 'Steps',
                value: '6',
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              _InfoStat(
                label: 'Motion',
                value: 'Reduced',
                color: colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  const _InfoStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
