part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class _PagedDescription extends StatefulWidget {
  const _PagedDescription({required this.descriptions});

  final List<String> descriptions;

  @override
  State<_PagedDescription> createState() => _PagedDescriptionState();
}

class _PagedDescriptionState extends State<_PagedDescription> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 52,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.descriptions.length,
            onPageChanged: (i) => setState(() => _index = i),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, i) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final fade = CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.0, 0.85, curve: Curves.easeOutQuart),
                );
                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: Align(
                key: ValueKey(i),
                alignment: Alignment.topLeft,
                child: Text(
                  widget.descriptions[i],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.65,
                        fontSize: 16,
                        letterSpacing: -0.2,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.descriptions.length, (i) {
            final selected = i == _index;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: selected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, progress, child) {
                final width = 5.0 + (27.0 * progress);
                final opacity = 0.3 + (0.7 * progress);
                final shadowOpacity = 0.5 * progress;

                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 5,
                  width: width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(
                          alpha: opacity,
                        ),
                    borderRadius: BorderRadius.circular(2.5),
                    boxShadow: progress > 0.5
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: shadowOpacity),
                              blurRadius: 8 * progress,
                              spreadRadius: 1 * progress,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
