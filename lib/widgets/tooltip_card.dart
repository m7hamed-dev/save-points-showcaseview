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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = config?.primaryColor ?? colorScheme.primary;
    final buttonColor = config?.buttonColor ?? primary;
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

    final useGlass = config?.cardStyle == ShowcaseCoachCardStyle.glass &&
        (config?.reduceMotion != true);

    final decorationGradient = useGlass
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

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: decorationGradient,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.8),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.08),
              blurRadius: 34,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 22,
              spreadRadius: -6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
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
                    onSkip: onSkip,
                    colorScheme: colorScheme,
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                    buttonStyle: buttonStyle,
                    currentStep: currentStep,
                    totalSteps: totalSteps,
                    showProgressIndicator:
                        config?.showProgressIndicator ?? true,
                    step: step,
                    leading: step?.leading,
                    imageUrl: step?.imageUrl,
                    imageAsset: step?.imageAsset,
                  ),
                )
              : _CardSurface(
                  primary: primary,
                  buttonColor: buttonColor,
                  title: title,
                  description: description,
                  isLast: isLast,
                  onNext: onNext,
                  onSkip: onSkip,
                  colorScheme: colorScheme,
                  titleStyle: titleStyle,
                  bodyStyle: bodyStyle,
                  buttonStyle: buttonStyle,
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  showProgressIndicator: config?.showProgressIndicator ?? true,
                  step: step,
                ),
        ),
      ),
    );
  }
}
