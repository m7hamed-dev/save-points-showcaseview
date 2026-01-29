part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _CardSurface extends StatefulWidget {
  const _CardSurface({
    required this.primary,
    required this.buttonColor,
    required this.title,
    required this.description,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
    required this.colorScheme,
    required this.titleStyle,
    required this.bodyStyle,
    required this.buttonStyle,
    this.currentStep,
    this.totalSteps,
    this.showProgressIndicator = true,
    this.step,
    this.leading,
    this.imageUrl,
    this.imageAsset,
    this.config,
    this.skipButtonText,
    this.nextButtonText,
  });

  final Color primary;
  final Color buttonColor;
  final String title;
  final List<String> description;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final ColorScheme colorScheme;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final TextStyle buttonStyle;
  final int? currentStep;
  final int? totalSteps;
  final bool showProgressIndicator;
  final CoachStep? step;
  final Widget? leading;
  final String? imageUrl;
  final String? imageAsset;
  final ShowcaseCoachConfig? config;
  final String? skipButtonText;
  final String? nextButtonText;

  @override
  State<_CardSurface> createState() => _CardSurfaceState();
}

class _CardSurfaceState extends State<_CardSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.85, curve: Curves.easeOutQuart),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.primary.withValues(alpha: 0.04),
            widget.primary.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showProgressIndicator &&
                    widget.currentStep != null &&
                    widget.totalSteps != null &&
                    widget.totalSteps! > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          'Step ${widget.currentStep} of ${widget.totalSteps}',
                          style: widget.bodyStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: widget.colorScheme.outline
                                  .withValues(alpha: 0.15),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  widget.currentStep! / widget.totalSteps!,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.primary,
                                      widget.primary.withValues(alpha: 0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Leading widget (icon or image)
                if (widget.leading != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: widget.leading!,
                  ),
                ],
                // Image from URL or asset
                if (widget.imageUrl != null || widget.imageAsset != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: widget.imageUrl != null
                            ? Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: widget
                                        .colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: widget.colorScheme.onSurface
                                          .withValues(alpha: 0.3),
                                      size: 48,
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                widget.imageAsset!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: widget
                                        .colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: widget.colorScheme.onSurface
                                          .withValues(alpha: 0.3),
                                      size: 48,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
                Text(
                  widget.title,
                  style: widget.titleStyle.copyWith(
                    letterSpacing: -0.8,
                    height: 1.2,
                    color: widget.config?.overlayStyle ==
                            ShowcaseOverlayStyle.classic
                        ? const Color(0xFF0F172A)
                        : widget.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.description.length == 1)
                  Text(
                    widget.description.first,
                    style: widget.bodyStyle.copyWith(
                      height: 1.65,
                      letterSpacing: -0.2,
                      color: widget.config?.overlayStyle ==
                              ShowcaseOverlayStyle.classic
                          ? const Color(0xFF475569)
                          : widget.colorScheme.onSurface
                              .withValues(alpha: 0.75),
                    ),
                  )
                else
                  _PagedDescription(descriptions: widget.description),
                const SizedBox(height: 24),
                Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        widget.colorScheme.outline.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    if (widget.onSkip != null &&
                        (widget.step?.showSkipButton ?? true) &&
                        widget.config?.overlayStyle !=
                            ShowcaseOverlayStyle.classic)
                      Material(
                        color: Colors.transparent,
                        child: Semantics(
                          button: true,
                          label: 'Skip tour',
                          child: InkWell(
                            onTap: () {
                              widget.step?.onSkip?.call();
                              widget.onSkip?.call();
                            },
                            borderRadius: BorderRadius.circular(14),
                            splashColor: widget.colorScheme.primary
                                .withValues(alpha: 0.08),
                            highlightColor: widget.colorScheme.primary
                                .withValues(alpha: 0.05),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              child: Text(
                                widget.step?.skipButtonText ??
                                    widget.skipButtonText ??
                                    widget.config?.skipButtonText ??
                                    'Skip',
                                style: widget.buttonStyle.copyWith(
                                  color: widget.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    _AnimatedButton(
                      buttonColor: widget.buttonColor,
                      isLast: widget.isLast,
                      onNext: () {
                        widget.step?.onNext?.call();
                        widget.onNext();
                      },
                      buttonText: widget.step?.nextButtonText ??
                          widget.nextButtonText ??
                          widget.config?.nextButtonText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  const _AnimatedButton({
    required this.buttonColor,
    required this.isLast,
    required this.onNext,
    this.buttonText,
  });

  final Color buttonColor;
  final bool isLast;
  final VoidCallback onNext;
  final String? buttonText;

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
      // Small delay to ensure visual feedback is seen
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          widget.onNext();
        }
      });
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: () {
              // Direct tap handler for better responsiveness
              if (!_isPressed) {
                setState(() => _isPressed = true);
                _controller.forward();
                Future.delayed(const Duration(milliseconds: 150), () {
                  if (mounted) {
                    setState(() => _isPressed = false);
                    _controller.reverse();
                    widget.onNext();
                  }
                });
              }
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Semantics(
              button: true,
              label: widget.isLast ? 'Done' : 'Next',
              child: Container(
                // Ensure minimum tap target size (48x48 for accessibility)
                constraints: const BoxConstraints(
                  minHeight: 48,
                  minWidth: 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.buttonColor,
                      widget.buttonColor.withValues(alpha: 0.85),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.buttonColor
                          .withValues(alpha: _isPressed ? 0.25 : 0.35),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.buttonText ?? (widget.isLast ? 'Done' : 'Next'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (!widget.isLast) ...[
                      const SizedBox(width: 8),
                      const _IconAnimation(
                        key: ValueKey('arrow'),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(width: 8),
                      const _IconAnimation(
                        key: ValueKey('check'),
                        isCheck: true,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconAnimation extends StatefulWidget {
  const _IconAnimation({
    super.key,
    required this.child,
    this.isCheck = false,
  });

  final Widget child;
  final bool isCheck;

  @override
  State<_IconAnimation> createState() => _IconAnimationState();
}

class _IconAnimationState extends State<_IconAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _transformAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.isCheck) {
      _transformAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
    } else {
      _transformAnimation = Tween<double>(begin: 4.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.isCheck
          ? ScaleTransition(
              scale: _transformAnimation,
              child: widget.child,
            )
          : AnimatedBuilder(
              animation: _transformAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_transformAnimation.value, 0),
                  child: child,
                );
              },
              child: widget.child,
            ),
    );
  }
}
