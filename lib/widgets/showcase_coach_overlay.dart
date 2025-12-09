part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _PulsingHighlight extends StatefulWidget {
  const _PulsingHighlight({required this.child});

  final Widget child;

  @override
  State<_PulsingHighlight> createState() => _PulsingHighlightState();
}

class _PulsingHighlightState extends State<_PulsingHighlight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    // Start animation immediately and keep it repeating
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Use a curved wave for a softer ease-in/out pulse.
        final curved = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubic,
        ).value;

        // Secondary wave to subtly vary the glow strength.
        final haloWave = 0.5 + (0.5 * math.sin(_controller.value * 2 * math.pi));

        // Border opacity pulses between 0.7 and 1.0
        final borderOpacity = 0.7 + (0.3 * curved);
        // Shadow intensity pulses between 0.15 and 0.38
        final shadowIntensity = 0.15 + (0.23 * curved);
        // Blur radius pulses between 18 and 32
        final blurRadius = 18 + (14 * curved);
        // Spread radius pulses between 2.5 and 5.5
        final spreadRadius = 2.5 + (3 * curved);
        // Bounce scale between 0.95 and 1.05 to draw focus
        final bounceScale = 0.95 + (0.10 * curved);
        // Slight float to give a gentle rise/fall
        final floatOffset = -2 * curved;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: bounceScale,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: borderOpacity),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary
                        .withValues(alpha: shadowIntensity * haloWave),
                    blurRadius: blurRadius,
                    spreadRadius: spreadRadius,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.4 * borderOpacity),
                    blurRadius: 12 + (5 * curved),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class _CoachOverlay extends StatelessWidget {
  const _CoachOverlay({
    required this.step,
    required this.rect,
    required this.isLast,
    required this.onNext,
    this.onSkip,
    this.config,
  });

  final CoachStep step;
  final Rect? rect;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final ShowcaseCoachConfig? config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = config?.primaryColor ?? colorScheme.primary;

    final blurSigma = (config?.reduceMotion ?? false) ? 0.0 : 8.0;

    final content = Stack(
      children: [
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            switchInCurve: Curves.easeInOutCubicEmphasized,
            switchOutCurve: Curves.easeInOutCubicEmphasized,
            transitionBuilder: (child, animation) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubicEmphasized,
              );
              return FadeTransition(opacity: curved, child: child);
            },
            child: _BackdropHole(
              key: ValueKey(rect?.hashCode ?? 0),
              rect: rect,
            ),
          ),
        ),

        /// Gradient
        if (rect != null)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeInOutCubicEmphasized,
              switchOutCurve: Curves.easeInOutCubicEmphasized,
              transitionBuilder: (child, animation) {
                final curved = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubicEmphasized,
                );
                return FadeTransition(opacity: curved, child: child);
              },
              child: DecoratedBox(
                key: ValueKey('gradient_${rect!.hashCode}'),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      (rect!.center.dx / MediaQuery.sizeOf(context).width -
                              0.5) *
                          2,
                      (rect!.center.dy / MediaQuery.sizeOf(context).height -
                              0.5) *
                          2,
                    ),
                    radius: 0.72,
                    colors: [
                      primary.withValues(
                        alpha: config?.overlayTintOpacity ?? 0.15,
                      ),
                      primary.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

        /// Highlight
        if (rect != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart,
            left: rect!.left,
            top: rect!.top,
            width: rect!.width,
            height: rect!.height,
            child: IgnorePointer(
              child: TweenAnimationBuilder<double>(
                key: ValueKey('highlight_${rect!.hashCode}'),
                tween: Tween(begin: 0.90, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutQuart,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: _PulsingHighlight(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
          ),

        /// Card positioned above widget
        if (rect != null)
          Builder(
            builder: (context) {
              const spacing = 20.0;
              const horizontalPadding = 20.0;
              final size = MediaQuery.sizeOf(context);
              final safe = MediaQuery.paddingOf(context);

              final spaceAbove = rect!.top - safe.top - spacing;
              final spaceBelow =
                  size.height - rect!.bottom - safe.bottom - spacing;
              final placeAbove = spaceAbove >= spaceBelow;

              final positioned = Positioned(
                left: 0,
                right: 0,
                bottom: placeAbove
                    ? math.max(
                        safe.bottom + spacing,
                        size.height - rect!.top + spacing,
                      )
                    : null,
                top: placeAbove ? null : rect!.bottom + spacing,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final cardMaxWidth = math.min(
                      screenWidth - (horizontalPadding * 2),
                      480.0,
                    );

                    return SafeArea(
                      top: false,
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: RepaintBoundary(
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 480),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                // Smooth emphasis curve for both enter/exit
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutCubicEmphasized,
                                );

                                // Subtle vertical travel depending on placement
                                final slide = Tween<Offset>(
                                  begin: Offset(0.0, placeAbove ? -0.08 : 0.08),
                                  end: Offset.zero,
                                ).animate(curved);

                                // Soft pop-in with a slight overshoot then settle
                                final scale = TweenSequence<double>([
                                  TweenSequenceItem(
                                    tween: Tween(begin: 0.95, end: 1.04).chain(
                                      CurveTween(curve: Curves.easeOutCubic),
                                    ),
                                    weight: 60,
                                  ),
                                  TweenSequenceItem(
                                    tween: Tween(begin: 1.04, end: 1.0).chain(
                                      CurveTween(curve: Curves.easeInCubic),
                                    ),
                                    weight: 40,
                                  ),
                                ]).animate(curved);

                                final fade = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                );

                                return SlideTransition(
                                  position: slide,
                                  child: FadeTransition(
                                    opacity: fade,
                                    child: ScaleTransition(
                                      scale: scale,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: _TooltipCard(
                                key: ValueKey(
                                  'tooltip_${step.title}_${step.targetKey.hashCode}',
                                ),
                                maxWidth: cardMaxWidth,
                                title: step.title,
                                description: step.description,
                                isLast: isLast,
                                onNext: onNext,
                                onSkip: onSkip,
                                config: config,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );

              return positioned;
            },
          )
        else
          // Fallback to bottom if rect is null
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                const horizontalPadding = 20.0;
                final cardMaxWidth = math.min(
                  screenWidth - (horizontalPadding * 2),
                  480.0,
                );

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: horizontalPadding,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        switchInCurve: Curves.easeOutQuart,
                        switchOutCurve: Curves.easeInQuart,
                        transitionBuilder: (child, animation) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutQuart,
                          );
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.1),
                              end: Offset.zero,
                            ).animate(curvedAnimation),
                            child: FadeTransition(
                              opacity: curvedAnimation,
                              child: ScaleTransition(
                                scale: Tween<double>(
                                  begin: 0.92,
                                  end: 1.0,
                                ).animate(curvedAnimation),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: _TooltipCard(
                          key: ValueKey(
                            'tooltip_${step.title}_${step.targetKey.hashCode}',
                          ),
                          maxWidth: cardMaxWidth,
                          title: step.title,
                          description: step.description,
                          isLast: isLast,
                          onNext: onNext,
                          onSkip: onSkip,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );

    if (blurSigma > 0) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: content,
        ),
      );
    }

    return content;
  }
}
