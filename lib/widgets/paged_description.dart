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
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.12),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
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
            return AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutQuart,
              margin: const EdgeInsets.only(right: 10),
              height: 5,
              width: selected ? 32 : 5,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.5),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
