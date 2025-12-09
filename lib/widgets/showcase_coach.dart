part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

class ShowcaseCoach {
  static Future<void> show(
    BuildContext context, {
    required List<CoachStep> steps,
    ShowcaseCoachConfig? config,
    VoidCallback? onSkip,
    VoidCallback? onDone,
    bool Function()? shouldShow,
    bool showIf = true,
  }) async {
    if (steps.isEmpty) return;

    // Check global condition to determine if showcase should be shown
    final shouldDisplay = shouldShow?.call() ?? showIf;
    if (!shouldDisplay) {
      return;
    }

    // Filter steps based on their individual conditions
    final visibleSteps = steps.where((step) => step.isVisible).toList();
    if (visibleSteps.isEmpty) {
      return;
    }

    // Validate for duplicate keys before proceeding (only check visible steps)
    final duplicateError = ShowcaseCoachValidator.validateSteps(visibleSteps);
    if (duplicateError != null) {
      if (context.mounted) {
        await ShowcaseCoachError.showErrorDialog(context, duplicateError);
      }
      return;
    }

    // Validate that all keys are visible and attached (with retries)
    final visibilityError = await ShowcaseCoachValidator.validateKeysVisible(
      visibleSteps,
    );
    if (visibilityError != null) {
      if (context.mounted) {
        await ShowcaseCoachError.showErrorDialog(context, visibilityError);
      }
      return;
    }

    if (!context.mounted) return;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      await ShowcaseCoachError.showErrorDialog(
        context,
        'Unable to show showcase coach.\n\n'
        'No overlay found in the current context.',
      );
      return;
    }

    final controller = ValueNotifier<int>(0);
    late OverlayEntry entry;

    /// Scrolls the target widget into view if it's not visible
    Future<void> ensureVisible(GlobalKey key) async {
      final context = key.currentContext;
      if (context == null) return;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) return;

      // Check if widget is visible on screen
      final screenSize = MediaQuery.sizeOf(context);
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      final isVisible = position.dy >= 0 &&
          position.dy + size.height <= screenSize.height &&
          position.dx >= 0 &&
          position.dx + size.width <= screenSize.width;

      if (!isVisible) {
        // Scroll into view
        await Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          alignment: 0.5, // Center the widget
        );
        // Wait a bit for scroll animation to complete
        await Future.delayed(const Duration(milliseconds: 450));
      }
    }

    Rect? targetRect(GlobalKey key) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) return null;
      final offset = renderBox.localToGlobal(Offset.zero);
      return offset & renderBox.size;
    }

    void close() {
      controller.dispose();
      entry.remove();
    }

    // Ensure first step is visible before showing overlay
    await ensureVisible(visibleSteps[0].targetKey);

    entry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<int>(
          valueListenable: controller,
          builder: (context, index, _) {
            final step = visibleSteps[index];

            // Ensure current step is visible when it changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ensureVisible(step.targetKey);
            });

            final rect = targetRect(step.targetKey);
            return _CoachOverlay(
              step: step,
              rect: rect,
              isLast: index == visibleSteps.length - 1,
              onNext: () {
                if (index == visibleSteps.length - 1) {
                  onDone?.call();
                  close();
                } else {
                  controller.value = index + 1;
                }
              },
              onSkip: () {
                onSkip?.call();
                close();
              },
              config: config,
            );
          },
        );
      },
    );

    overlay.insert(entry);
  }
}
