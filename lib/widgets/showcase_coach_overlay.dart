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
  late final CurvedAnimation _curvedAnimation;
  late final ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    );
    // Create curve once, reuse it
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    // Start animation immediately and keep it repeating
    _controller.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache colorScheme to avoid Theme lookups
    _colorScheme = Theme.of(context).colorScheme;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Use cached curved animation value
          final curved = _curvedAnimation.value;

          // Pre-calculate constants to reduce math operations
          final controllerValue = _controller.value;
          final twoPiValue = controllerValue * 2 * math.pi;
          final haloWave = 0.5 + (0.5 * math.sin(twoPiValue));

          // Border opacity pulses between 0.75 and 1.0 (smoother range)
          final borderOpacity = 0.75 + (0.25 * curved);
          // Shadow intensity pulses between 0.18 and 0.42 (enhanced range)
          final shadowIntensity = 0.18 + (0.24 * curved);
          // Blur radius pulses between 20 and 36 (smoother range)
          final blurRadius = 20 + (16 * curved);
          // Spread radius pulses between 3.0 and 6.0 (smoother range)
          final spreadRadius = 3.0 + (3.0 * curved);
          // Bounce scale between 0.96 and 1.04 (subtler bounce)
          final bounceScale = 0.96 + (0.08 * curved);
          // Slight float to give a gentle rise/fall (smoother)
          final floatOffset = -1.5 * curved;

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
                      color: _colorScheme.primary
                          .withValues(alpha: shadowIntensity * haloWave),
                      blurRadius: blurRadius,
                      spreadRadius: spreadRadius,
                    ),
                    BoxShadow(
                      color:
                          Colors.white.withValues(alpha: 0.4 * borderOpacity),
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
        child: widget.child,
      ),
    );
  }
}

class _HighlightAnimation extends StatefulWidget {
  const _HighlightAnimation({
    super.key,
    required this.primary,
  });

  final Color primary;

  @override
  State<_HighlightAnimation> createState() => _HighlightAnimationState();
}

class _HighlightAnimationState extends State<_HighlightAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Spring-like scale animation with bounce
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 75,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_controller);

    // Smooth fade in with faster start - use Interval to prevent overshoot
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutQuart),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Clamp opacity to [0, 1] to prevent errors
        final opacity = _opacityAnimation.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: child,
          ),
        );
      },
      child: _PulsingHighlight(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
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
            duration: const Duration(milliseconds: 450),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              // Smooth fade with slight scale for depth
              final fade = CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.9, curve: Curves.easeOut),
              );

              return FadeTransition(
                opacity: fade,
                child: child,
              );
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
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                // Combine fade with subtle scale for smoother appearance
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
                );

                final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );

                return FadeTransition(
                  opacity: fade,
                  child: ScaleTransition(
                    scale: scale,
                    child: child,
                  ),
                );
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
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            left: rect!.left,
            top: rect!.top,
            width: rect!.width,
            height: rect!.height,
            child: IgnorePointer(
              child: _HighlightAnimation(
                key: ValueKey('highlight_${rect!.hashCode}'),
                primary: primary,
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
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                // Smooth emphasis curve for both enter/exit
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                );

                                // More dynamic vertical travel
                                final slide = Tween<Offset>(
                                  begin: Offset(0.0, placeAbove ? -0.2 : 0.2),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
                                  ),
                                );

                                // Bouncy pop-in with spring-like effect
                                final scale = TweenSequence<double>([
                                  TweenSequenceItem(
                                    tween: Tween(begin: 0.8, end: 1.1).chain(
                                      CurveTween(curve: Curves.easeOutBack),
                                    ),
                                    weight: 70,
                                  ),
                                  TweenSequenceItem(
                                    tween: Tween(begin: 1.1, end: 1.0).chain(
                                      CurveTween(curve: Curves.easeInOut),
                                    ),
                                    weight: 30,
                                  ),
                                ]).animate(curved);

                                // Faster fade with smooth curve - clamp to prevent overshoot
                                final fade = CurvedAnimation(
                                  parent: animation,
                                  curve: const Interval(0.0, 1.0,
                                      curve: Curves.easeOutQuart),
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
                        duration: const Duration(milliseconds: 600),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );

                          // Bouncy scale animation with spring effect
                          final scale = TweenSequence<double>([
                            TweenSequenceItem(
                              tween: Tween(begin: 0.8, end: 1.1).chain(
                                CurveTween(curve: Curves.easeOutBack),
                              ),
                              weight: 70,
                            ),
                            TweenSequenceItem(
                              tween: Tween(begin: 1.1, end: 1.0).chain(
                                CurveTween(curve: Curves.easeInOut),
                              ),
                              weight: 30,
                            ),
                          ]).animate(curvedAnimation);

                          // Faster fade - clamp to prevent overshoot
                          final fade = CurvedAnimation(
                            parent: animation,
                            curve: const Interval(0.0, 1.0,
                                curve: Curves.easeOutQuart),
                          );

                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.15),
                              end: Offset.zero,
                            ).animate(curvedAnimation),
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
