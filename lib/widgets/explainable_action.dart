import 'package:flutter/material.dart';

import 'package:save_points_showcaseview/models/phase.dart';
import 'package:save_points_showcaseview/save_points_showcaseview.dart';

class PhaseExplainer {
  static Future<int?> showContextMenu(
    BuildContext context, {
    required GlobalKey anchorKey,
    required List<Phase> phases,
  }) async {
    final renderBox =
        anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items: List.generate(phases.length, (index) {
        final phase = phases[index];
        return PopupMenuItem<int>(
          value: index,
          child: _MiniPhaseTile(phase: phase),
        );
      }),
    );
  }
}

class ExplainableAction extends StatefulWidget {
  const ExplainableAction({
    super.key,
    required this.child,
    required this.phases,
    required this.explainerTitle,
    this.helperText,
    this.initialIndex = 0,
    this.onPressed,
    this.showExplainerOnFirstTap = false,
  });

  final Widget child;
  final List<Phase> phases;
  final String explainerTitle;
  final String? helperText;
  final int initialIndex;
  final VoidCallback? onPressed;
  final bool showExplainerOnFirstTap;

  @override
  State<ExplainableAction> createState() => _ExplainableActionState();
}

class _ExplainableActionState extends State<ExplainableAction> {
  bool _shownOnce = false;
  final GlobalKey _anchorKey = GlobalKey();

  Future<void> _showExplainer() async {
    await ShowcaseCoach.show(
      context,
      steps: widget.phases
          .map(
            (phase) => CoachStep(
              targetKey: _anchorKey,
              title: phase.title,
              description: [phase.description],
            ),
          )
          .toList(),
    );
  }

  void _handlePrimaryTap() {
    if (widget.showExplainerOnFirstTap && !_shownOnce) {
      setState(() => _shownOnce = true);
      _showExplainer();
      return;
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: _handlePrimaryTap,
                behavior: HitTestBehavior.opaque,
                child: AbsorbPointer(
                  key: _anchorKey,
                  child: widget.child,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: () => _showExplainer(),
              icon: const Icon(Icons.info_outline),
              tooltip: 'Explain this',
            ),
          ],
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _MiniPhaseTile extends StatelessWidget {
  const _MiniPhaseTile({required this.phase});

  final Phase phase;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(phase.icon, color: Colors.indigo),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                phase.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                phase.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
