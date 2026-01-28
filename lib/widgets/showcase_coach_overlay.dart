part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _PulsingHighlight extends StatefulWidget {
  final Widget child;
  final ShowcaseCoachConfig? config;
  final Color primary;
  const _PulsingHighlight({
    required this.child,
    this.config,
    required this.primary,
  });

  @override
  State<_PulsingHighlight> createState() => _PulsingHighlightState();
}

class _PulsingHighlightState extends State<_PulsingHighlight>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  AnimationController? _shimmerController;
  late final CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    // Calculate duration based on pulse speed multiplier
    const baseDuration = 2400;
    final speedMultiplier = widget.config?.pulseAnimationSpeed ?? 1.0;
    final duration = (baseDuration / speedMultiplier).round();
    
    _controller = AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    );
    // Create curve once, reuse it
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    // Start animation immediately and keep it repeating
    _controller.repeat(reverse: true);

    // Shimmer controller if shimmer is enabled
    if (widget.config?.enableShimmerEffect == true) {
      _shimmerController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );
      _shimmerController!.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController?.dispose();
    super.dispose();
  }

  Border _buildBorder(double opacity, double borderWidth) {
    final borderStyle = widget.config?.borderStyle ?? HighlightBorderStyle.solid;
    final borderColor = Colors.white.withValues(alpha: opacity);

    switch (borderStyle) {
      case HighlightBorderStyle.dashed:
        return Border.all(
          color: borderColor,
          width: borderWidth,
        );
      case HighlightBorderStyle.dotted:
        return Border.all(
          color: borderColor,
          width: borderWidth,
        );
      case HighlightBorderStyle.solid:
        return Border.all(
          color: borderColor,
          width: borderWidth,
        );
    }
  }

  BorderRadius _buildBorderRadius(double borderRadius, HighlightShape shape, double width, double height) {
    switch (shape) {
      case HighlightShape.circle:
        final radius = math.min(width, height) / 2;
        return BorderRadius.circular(radius);
      case HighlightShape.rectangle:
        return BorderRadius.zero;
      case HighlightShape.roundedRectangle:
        return BorderRadius.circular(borderRadius);
    }
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
          // Apply glow intensity multiplier
          final glowMultiplier = widget.config?.glowIntensity ?? 1.0;
          final shadowMultiplier = widget.config?.shadowIntensity ?? 1.0;
          
          // Shadow intensity pulses between 0.18 and 0.42 (enhanced range)
          final baseShadowIntensity = (0.18 + (0.24 * curved)) * glowMultiplier;
          // Blur radius pulses between 20 and 36 (smoother range)
          final blurRadius = (20 + (16 * curved)) * glowMultiplier;
          // Spread radius pulses between 3.0 and 6.0 (smoother range)
          final spreadRadius = (3.0 + (3.0 * curved)) * glowMultiplier;
          // Bounce scale with customizable intensity
          final bounceMultiplier = widget.config?.bounceIntensity ?? 1.0;
          final bounceScale = 0.96 + (0.08 * curved * bounceMultiplier);
          // Slight float to give a gentle rise/fall (smoother)
          final floatOffset = -1.5 * curved;
          
          // Get border properties from config
          final borderWidth = widget.config?.borderWidth ?? 3.0;
          final borderRadius = widget.config?.borderRadius ?? 24.0;
          final highlightShape = widget.config?.highlightShape ?? HighlightShape.roundedRectangle;

          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: Transform.scale(
              scale: bounceScale,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: _buildBorderRadius(
                        borderRadius,
                        highlightShape,
                        widget.child is SizedBox
                            ? (widget.child as SizedBox).width ?? 0
                            : 0,
                        widget.child is SizedBox
                            ? (widget.child as SizedBox).height ?? 0
                            : 0,
                      ),
                      border: _buildBorder(borderOpacity, borderWidth),
                      boxShadow: [
                        if (glowMultiplier > 0)
                          BoxShadow(
                            color: widget.primary
                                .withValues(alpha: baseShadowIntensity * haloWave),
                            blurRadius: blurRadius,
                            spreadRadius: spreadRadius,
                          ),
                        if (shadowMultiplier > 0)
                          BoxShadow(
                            color: Colors.white.withValues(
                              alpha: (0.4 * borderOpacity) * shadowMultiplier,
                            ),
                            blurRadius: (12 + (5 * curved)) * shadowMultiplier,
                            spreadRadius: 1 * shadowMultiplier,
                          ),
                      ],
                    ),
                    child: widget.child,
                  ),
                  // Shimmer overlay
                  if (widget.config?.enableShimmerEffect == true && _shimmerController != null)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: _buildBorderRadius(
                          borderRadius,
                          highlightShape,
                          widget.child is SizedBox
                              ? (widget.child as SizedBox).width ?? 0
                              : 0,
                          widget.child is SizedBox
                              ? (widget.child as SizedBox).height ?? 0
                              : 0,
                        ),
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _shimmerController!,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: _ShimmerPainter(
                                  progress: _shimmerController!.value,
                                  color: widget.primary,
                                  borderRadius: borderRadius,
                                  shape: highlightShape,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
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
    this.config,
  });

  final Color primary;
  final ShowcaseCoachConfig? config;

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
        config: widget.config,
        primary: widget.primary,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(
              widget.config?.borderRadius ?? 24.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _CoachOverlay extends StatefulWidget {
  const _CoachOverlay({
    required this.step,
    required this.rect,
    required this.isLast,
    required this.onNext,
    this.onSkip,
    this.config,
    this.currentStep,
    this.totalSteps,
  });

  final CoachStep step;
  final Rect? rect;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final ShowcaseCoachConfig? config;
  final int? currentStep;
  final int? totalSteps;

  @override
  State<_CoachOverlay> createState() => _CoachOverlayState();
}

class _CoachOverlayState extends State<_CoachOverlay> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus for keyboard handling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        if (!widget.isLast) {
          widget.onNext();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onSkip?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: _CoachOverlayContent(
        step: widget.step,
        rect: widget.rect,
        isLast: widget.isLast,
        onNext: widget.onNext,
        onSkip: widget.onSkip,
        config: widget.config,
        currentStep: widget.currentStep,
        totalSteps: widget.totalSteps,
      ),
    );
  }
}

class _CoachOverlayContent extends StatelessWidget {
  const _CoachOverlayContent({
    required this.step,
    required this.rect,
    required this.isLast,
    required this.onNext,
    this.onSkip,
    this.config,
    this.currentStep,
    this.totalSteps,
  });

  final CoachStep step;
  final Rect? rect;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final ShowcaseCoachConfig? config;
  final int? currentStep;
  final int? totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = config?.primaryColor ?? colorScheme.primary;

    final blurSigma = (config?.reduceMotion ?? false) ? 0.0 : 8.0;

    // Determine if transitions should be enabled
    final transitionsEnabled =
        config?.enableTransitions ?? !(config?.reduceMotion ?? false);

    // Get transition durations with fallbacks
    final backdropDuration = transitionsEnabled
        ? (config?.backdropTransitionDuration ??
            config?.transitionDuration ??
            ShowcaseCoachConstants.overlayTransitionDuration)
        : Duration.zero;
    final gradientDuration = transitionsEnabled
        ? (config?.gradientTransitionDuration ??
            config?.transitionDuration ??
            ShowcaseCoachConstants.gradientTransitionDuration)
        : Duration.zero;
    final highlightDuration = transitionsEnabled
        ? (config?.highlightTransitionDuration ??
            config?.transitionDuration ??
            ShowcaseCoachConstants.highlightAnimationDuration)
        : Duration.zero;
    final cardDuration = transitionsEnabled
        ? (config?.cardTransitionDuration ??
            config?.transitionDuration ??
            ShowcaseCoachConstants.cardTransitionDuration)
        : Duration.zero;

    // Get transition curves with fallbacks
    final transitionCurve =
        config?.transitionCurve ?? ShowcaseCoachConstants.defaultAnimationCurve;

    final content = Stack(
      children: [
        // Tap detector for dismiss on tap outside
        if (config?.dismissOnTapOutside == true)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                onSkip?.call();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: backdropDuration,
            switchInCurve: transitionCurve,
            switchOutCurve: transitionCurve,
            transitionBuilder: (child, animation) {
              if (!transitionsEnabled) {
                return child;
              }
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
              duration: gradientDuration,
              switchInCurve: transitionCurve,
              switchOutCurve: transitionCurve,
              transitionBuilder: (child, animation) {
                if (!transitionsEnabled) {
                  return child;
                }
                // Combine fade with subtle scale for smoother appearance
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
                );

                final scale = Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: transitionCurve,
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
          Stack(
            children: [
              // Particle effect
              if (config?.enableParticleEffect == true)
                _ParticleEffect(
                  rect: rect!,
                  primary: primary,
                ),
              // Ripple effect
              if (config?.enableRippleEffect == true)
                _RippleEffect(
                  rect: rect!,
                  primary: primary,
                  duration: highlightDuration,
                ),
              // Highlight animation
              AnimatedPositioned(
                duration: highlightDuration,
                curve: transitionCurve,
                left: rect!.left,
                top: rect!.top,
                width: rect!.width,
                height: rect!.height,
                child: IgnorePointer(
                  child: _HighlightAnimation(
                    key: ValueKey('highlight_${rect!.hashCode}'),
                    primary: primary,
                    config: config,
                  ),
                ),
              ),
              // Debug mode visualization
              if (config?.debugMode == true)
                _DebugOverlay(
                  rect: rect!,
                  step: step,
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                ),
            ],
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
                              duration: cardDuration,
                              switchInCurve: transitionCurve,
                              switchOutCurve: transitionCurve,
                              transitionBuilder: (child, animation) {
                                if (!transitionsEnabled) {
                                  return child;
                                }
                                // Smooth emphasis curve for both enter/exit
                                final curved = CurvedAnimation(
                                  parent: animation,
                                  curve: transitionCurve,
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
                                  curve: const Interval(
                                    0.0,
                                    1.0,
                                    curve: Curves.easeOutQuart,
                                  ),
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
                              child: Semantics(
                                label: 'Showcase coach: ${step.title}',
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
                                  currentStep: currentStep,
                                  totalSteps: totalSteps,
                                  step: step,
                                ),
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
                        duration: cardDuration,
                        switchInCurve: transitionCurve,
                        switchOutCurve: transitionCurve,
                        transitionBuilder: (child, animation) {
                          if (!transitionsEnabled) {
                            return child;
                          }
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: transitionCurve,
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
                            curve: const Interval(
                              0.0,
                              1.0,
                              curve: Curves.easeOutQuart,
                            ),
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
                          config: config,
                          currentStep: currentStep,
                          totalSteps: totalSteps,
                          step: step,
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

/// Shimmer painter for the highlight border effect.
class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.progress,
    required this.color,
    this.borderRadius = 24.0,
    this.shape = HighlightShape.roundedRectangle,
  });

  final double progress;
  final Color color;
  final double borderRadius;
  final HighlightShape shape;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1.0 + progress * 2, 0),
        end: Alignment(1.0 + progress * 2, 0),
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.6),
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.6),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    switch (shape) {
      case HighlightShape.circle:
        final radius = math.min(size.width, size.height) / 2;
        path.addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: radius,
          ),
        );
        break;
      case HighlightShape.rectangle:
        path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
        break;
      case HighlightShape.roundedRectangle:
        path.addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(borderRadius),
          ),
        );
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Ripple effect widget that creates expanding circles from the highlight.
class _RippleEffect extends StatefulWidget {
  const _RippleEffect({
    required this.rect,
    required this.primary,
    required this.duration,
  });

  final Rect rect;
  final Color primary;
  final Duration duration;

  @override
  State<_RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<_RippleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Ripple> _ripples = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Create ripples periodically
    _controller.addListener(() {
      if (_controller.value % 0.5 < 0.01) {
        setState(() {
          _ripples.add(_Ripple(
            startTime: DateTime.now(),
            center: Offset(
              widget.rect.center.dx,
              widget.rect.center.dy,
            ),
          ),);
        });
      }

      // Remove old ripples
      final now = DateTime.now();
      _ripples.removeWhere(
        (ripple) => now.difference(ripple.startTime).inMilliseconds > 2000,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.rect.left - 50,
      top: widget.rect.top - 50,
      width: widget.rect.width + 100,
      height: widget.rect.height + 100,
      child: IgnorePointer(
        child: CustomPaint(
          painter: _RipplePainter(
            ripples: _ripples,
            color: widget.primary,
          ),
        ),
      ),
    );
  }
}

class _Ripple {
  _Ripple({
    required this.startTime,
    required this.center,
  });

  final DateTime startTime;
  final Offset center;
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.ripples,
    required this.color,
  });

  final List<_Ripple> ripples;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    for (final ripple in ripples) {
      final elapsed = now.difference(ripple.startTime).inMilliseconds;
      final progress = (elapsed / 2000.0).clamp(0.0, 1.0);
      final radius = progress * 100;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(
        ripple.center,
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.ripples.length != ripples.length;
  }
}

/// Particle effect widget that creates floating particles around the highlight.
class _ParticleEffect extends StatefulWidget {
  const _ParticleEffect({
    required this.rect,
    required this.primary,
  });

  final Rect rect;
  final Color primary;

  @override
  State<_ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<_ParticleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (var i = 0; i < 15; i++) {
      _particles.add(_Particle.random(widget.rect));
    }

    _controller.addListener(() {
      setState(() {
        for (final particle in _particles) {
          particle.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.rect.left - 50,
      top: widget.rect.top - 50,
      width: widget.rect.width + 100,
      height: widget.rect.height + 100,
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            color: widget.primary,
          ),
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });

  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;

  factory _Particle.random(Rect bounds) {
    final random = math.Random();
    return _Particle(
      x: bounds.left + random.nextDouble() * bounds.width,
      y: bounds.top + random.nextDouble() * bounds.height,
      vx: (random.nextDouble() - 0.5) * 0.5,
      vy: (random.nextDouble() - 0.5) * 0.5,
      size: 2 + random.nextDouble() * 3,
      opacity: 0.3 + random.nextDouble() * 0.5,
    );
  }

  void update() {
    x += vx;
    y += vy;
    opacity = 0.3 + (math.sin(x * 0.1) + 1) * 0.25;
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.color,
  });

  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return true;
  }
}

/// Debug overlay widget that shows visual debugging information.
class _DebugOverlay extends StatelessWidget {
  const _DebugOverlay({
    required this.rect,
    required this.step,
    required this.currentStep,
    required this.totalSteps,
  });

  final Rect rect;
  final CoachStep step;
  final int? currentStep;
  final int? totalSteps;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left,
      top: rect.top - 80,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'DEBUG MODE',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Step: $currentStep/$totalSteps',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Title: ${step.title}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Rect: ${rect.left.toStringAsFixed(1)}, ${rect.top.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Text(
              'Size: ${rect.width.toStringAsFixed(1)} x ${rect.height.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
