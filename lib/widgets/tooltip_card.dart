part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _TooltipCard extends StatelessWidget {
  const _TooltipCard({
    super.key,
    required this.title,
    required this.description,
    required this.isLast,
    required this.onNext,
    this.onSkip,
    required this.maxWidth,
    this.config,
    this.currentStep,
    this.totalSteps,
    this.step,
    this.skipButtonText,
    this.nextButtonText,
    this.tooltipPlaceAbove,
  });

  final String title;
  final List<String> description;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback? onSkip;
  final double maxWidth;
  final ShowcaseCoachConfig? config;
  final int? currentStep;
  final int? totalSteps;
  final CoachStep? step;
  final String? skipButtonText;
  final String? nextButtonText;

  /// When true, card is above target so pointer on bottom; when false, pointer on top.
  final bool? tooltipPlaceAbove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = config?.primaryColor ?? colorScheme.primary;
    final buttonColor = config?.effectiveButtonColor ?? primary;
    final isDark = theme.brightness == Brightness.dark;

    final titleStyleBase = theme.textTheme.titleLarge ??
        const TextStyle(fontSize: 22, fontWeight: FontWeight.w900);
    final bodyStyleBase =
        theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16, height: 1.6);
    final buttonStyleBase = theme.textTheme.labelLarge ??
        const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

    TextStyle withFont(TextStyle base, TextStyle? override) =>
        config?.merge(base, override) ?? base;

    final titleStyle = withFont(titleStyleBase, config?.titleStyle);
    final bodyStyle = withFont(bodyStyleBase, config?.bodyStyle);
    final buttonStyle = withFont(buttonStyleBase, config?.buttonTextStyle);

    final isClassic = config?.overlayStyle == ShowcaseOverlayStyle.classic;
    final useGlass = !isClassic &&
        config?.cardStyle == ShowcaseCoachCardStyle.glass;

    final decorationGradient = isClassic
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFAFAFA)],
          )
        : useGlass
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.06),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.96),
                        Colors.white.withValues(alpha: 0.9),
                      ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                ],
              );

    final borderRadius = isClassic ? 16.0 : 28.0;
    final cardContent = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: decorationGradient,
        border: isClassic
            ? null
            : Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.white.withValues(alpha: 0.8),
                width: 1.4,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: isClassic ? 0.12 : (isDark ? 0.24 : 0.08)),
            blurRadius: isClassic ? 20 : 34,
            offset: const Offset(0, 8),
            spreadRadius: isClassic ? 0 : -4,
          ),
          if (!isClassic)
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 22,
              spreadRadius: -6,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: useGlass
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: _CardSurface(
                  primary: primary,
                  buttonColor: buttonColor,
                  title: title,
                  description: description,
                  isLast: isLast,
                  onNext: onNext,
                  onSkip: isClassic ? null : onSkip,
                  colorScheme: colorScheme,
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  buttonStyle: buttonStyle,
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  showProgressIndicator: config?.showProgressIndicator ?? true,
                  step: step,
                  leading: step?.leading,
                  imageUrl: step?.imageUrl,
                  imageAsset: step?.imageAsset,
                  config: config,
                  skipButtonText: skipButtonText,
                  nextButtonText: nextButtonText,
                ),
              )
            : _CardSurface(
                primary: primary,
                buttonColor: buttonColor,
                title: title,
                description: description,
                isLast: isLast,
                onNext: onNext,
                onSkip: isClassic ? null : onSkip,
                colorScheme: colorScheme,
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
                buttonStyle: buttonStyle,
                currentStep: currentStep,
                totalSteps: totalSteps,
                showProgressIndicator: config?.showProgressIndicator ?? true,
                step: step,
                config: config,
                skipButtonText: skipButtonText,
                nextButtonText: nextButtonText,
              ),
      ),
    );

    if (isClassic &&
        tooltipPlaceAbove != null &&
        config?.overlayStyle == ShowcaseOverlayStyle.classic) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            cardContent,
            Positioned(
              left: 0,
              right: 0,
              bottom: tooltipPlaceAbove! ? -10 : null,
              top: tooltipPlaceAbove! ? null : -10,
              height: 14,
              child: Center(
                child: CustomPaint(
                  size: const Size(24, 14),
                  painter: _SpeechBubblePointerPainter(
                    pointUp: !tooltipPlaceAbove!,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: cardContent,
    );
  }
}

/// Paints a small triangular pointer for the classic speech-bubble tooltip.
class _SpeechBubblePointerPainter extends CustomPainter {
  _SpeechBubblePointerPainter({
    required this.pointUp,
    required this.color,
  });

  final bool pointUp;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePointerPainter oldDelegate) {
    return oldDelegate.pointUp != pointUp || oldDelegate.color != color;
  }
}

class _CompactTooltipBubble extends StatelessWidget {
  const _CompactTooltipBubble({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.nextText,
    required this.isLast,
    required this.placeAbove,
    required this.pointerX,
    required this.onNext,
  });

  final String text;
  final Color buttonColor;
  final String nextText;
  final bool isLast;
  final bool placeAbove;
  final double pointerX;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const bodyHeight = 44.0;
    const pointerHeight = 10.0;
    const radius = 12.0;

    final body = Container(
      height: bodyHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                nextText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onNext,
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: placeAbove ? null : pointerHeight,
              bottom: placeAbove ? pointerHeight : null,
              child: body,
            ),
            Positioned(
              left: (pointerX - 10).clamp(0.0, double.infinity),
              top: placeAbove ? null : 0,
              bottom: placeAbove ? 0 : null,
              width: 20,
              height: pointerHeight,
              child: CustomPaint(
                painter: _CompactPointerPainter(
                  pointUp: !placeAbove,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactPointerPainter extends CustomPainter {
  _CompactPointerPainter({
    required this.pointUp,
    required this.color,
  });

  final bool pointUp;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointUp) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _CompactPointerPainter oldDelegate) {
    return oldDelegate.pointUp != pointUp || oldDelegate.color != color;
  }
}
