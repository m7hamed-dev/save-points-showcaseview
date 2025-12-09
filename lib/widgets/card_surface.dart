part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _CardSurface extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.04),
            primary.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle.copyWith(
                letterSpacing: -0.8,
                height: 1.2,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (description.length == 1)
              Text(
                description.first,
                style: bodyStyle.copyWith(
                  height: 1.65,
                  letterSpacing: -0.2,
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              )
            else
              _PagedDescription(descriptions: description),
            const SizedBox(height: 24),
            Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    colorScheme.outline.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                if (onSkip != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onSkip,
                      borderRadius: BorderRadius.circular(14),
                      splashColor: colorScheme.primary.withValues(alpha: 0.08),
                      highlightColor:
                          colorScheme.primary.withValues(alpha: 0.05),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Text(
                          'Skip',
                          style: buttonStyle.copyWith(
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.65),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        buttonColor,
                        buttonColor.withValues(alpha: 0.85),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onNext,
                      borderRadius: BorderRadius.circular(16),
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.white.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLast ? 'Done' : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                            if (!isLast) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ] else ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

