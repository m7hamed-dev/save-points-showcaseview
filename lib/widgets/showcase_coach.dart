part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Main class for displaying showcase coach overlays.
///
/// This class provides a static [show] method to display a guided tour
/// that highlights widgets and provides step-by-step instructions.
///
/// ## Features
///
/// - Automatic validation of GlobalKeys
/// - Smart scrolling to bring widgets into view
/// - Conditional step visibility
/// - Smooth animations and transitions
/// - Accessibility support
/// - Customizable theming
///
/// ## Example
///
/// ```dart
/// await ShowcaseCoach.show(
///   context,
///   steps: [
///     CoachStep(
///       targetKey: buttonKey,
///       title: 'Welcome!',
///       description: ['This is your first step.'],
///     ),
///   ],
///   onDone: () => print('Tour completed'),
///   onSkip: () => print('Tour skipped'),
/// );
/// ```
class ShowcaseCoach {
  /// Private constructor to prevent instantiation.
  ShowcaseCoach._();

  /// Displays a showcase coach overlay with the given steps.
  ///
  /// This method will:
  /// 1. Validate that all GlobalKeys are unique and visible
  /// 2. Filter steps based on their visibility conditions
  /// 3. Display an overlay with tooltips and highlights
  /// 4. Handle navigation between steps
  ///
  /// The overlay will remain visible until the user completes the tour or
  /// skips it. The method returns a [Future] that completes when the overlay
  /// is dismissed.
  ///
  /// ## Parameters
  ///
  /// - [context]: The build context. Must have an [Overlay] available
  ///   (typically inside a [MaterialApp]).
  /// - [steps]: List of [CoachStep] objects defining the tour. Must not be
  ///   empty. Steps with `isVisible == false` will be automatically filtered.
  /// - [config]: Optional configuration for customizing appearance and behavior.
  /// - [onSkip]: Optional callback invoked when the user skips the tour.
  /// - [onDone]: Optional callback invoked when the user completes the tour.
  /// - [shouldShow]: Optional global condition function. If provided and
  ///   returns `false`, the entire tour will be skipped.
  /// - [showIf]: Simple boolean flag for global visibility. Only used if
  ///   [shouldShow] is not provided. Defaults to `true`.
  /// - [onStepChanged]: Optional callback invoked whenever the current step
  ///   changes. Provides the current step index (1-based) and total step count.
  /// - [onStepStart]: Optional callback invoked when a step becomes active.
  ///   Provides the step index (0-based) and the [CoachStep] object.
  /// - [onStepComplete]: Optional callback invoked when a step is completed
  ///   (user presses Next). Provides the step index (0-based) and the [CoachStep] object.
  ///
  /// ## Throws
  ///
  /// This method does not throw exceptions. Instead, it displays user-friendly
  /// error dialogs for validation failures (duplicate keys, missing widgets, etc.).
  ///
  /// ## Example
  ///
  /// ```dart
  /// await ShowcaseCoach.show(
  ///   context,
  ///   steps: [
  ///     CoachStep(
  ///       targetKey: _buttonKey,
  ///       title: 'Action Button',
  ///       description: ['Tap this button to perform an action.'],
  ///     ),
  ///   ],
  ///   config: ShowcaseCoachConfig(
  ///     primaryColor: Colors.blue,
  ///     reduceMotion: false,
  ///   ),
  ///   onDone: () {
  ///     print('Tour completed!');
  ///   },
  /// );
  /// ```
  ///
  /// See also:
  /// - [CoachStep] for defining tour steps
  /// - [ShowcaseCoachConfig] for customization options
  static Future<void> show(
    BuildContext context, {
    required List<CoachStep> steps,
    ShowcaseCoachConfig? config,
    VoidCallback? onSkip,
    VoidCallback? onDone,
    bool Function()? shouldShow,
    bool showIf = true,
    void Function(int currentStep, int totalSteps)? onStepChanged,
    void Function(int stepIndex, CoachStep step)? onStepStart,
    void Function(int stepIndex, CoachStep step)? onStepComplete,
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

    /// Scrolls the target widget into view if it's not visible.
    ///
    /// Checks if the widget is currently visible on screen, and if not,
    /// scrolls it into view with a smooth animation.
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
          duration: ShowcaseCoachConstants.scrollAnimationDuration,
          curve: ShowcaseCoachConstants.scrollAnimationCurve,
          alignment: ShowcaseCoachConstants.scrollAlignment,
        );
        // Wait for scroll animation to complete
        await Future.delayed(ShowcaseCoachConstants.scrollAnimationDelay);
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

    // Helper function to trigger haptic feedback
    void triggerHapticFeedback() {
      if (config?.enableHapticFeedback == true) {
        switch (config!.hapticFeedbackType) {
          case HapticFeedbackType.light:
            HapticFeedback.lightImpact();
            break;
          case HapticFeedbackType.medium:
            HapticFeedback.mediumImpact();
            break;
          case HapticFeedbackType.heavy:
            HapticFeedback.heavyImpact();
            break;
        }
      }
    }

    // Call onStepStart for the first step
    onStepStart?.call(0, visibleSteps[0]);
    onStepChanged?.call(1, visibleSteps.length);
    triggerHapticFeedback();

    entry = OverlayEntry(
      builder: (context) {
        return _ShowcaseCoachOverlayContent(
          controller: controller,
          visibleSteps: visibleSteps,
          config: config,
          onStepChanged: onStepChanged,
          onStepStart: onStepStart,
          onStepComplete: onStepComplete,
          onDone: onDone,
          onSkip: onSkip,
          close: close,
          ensureVisible: ensureVisible,
          targetRect: targetRect,
          triggerHapticFeedback: triggerHapticFeedback,
        );
      },
    );

    overlay.insert(entry);
  }
}

/// Internal widget that manages the overlay content with auto-advance and haptic feedback.
class _ShowcaseCoachOverlayContent extends StatefulWidget {
  const _ShowcaseCoachOverlayContent({
    required this.controller,
    required this.visibleSteps,
    required this.config,
    required this.onStepChanged,
    required this.onStepStart,
    required this.onStepComplete,
    required this.onDone,
    required this.onSkip,
    required this.close,
    required this.ensureVisible,
    required this.targetRect,
    required this.triggerHapticFeedback,
  });

  final ValueNotifier<int> controller;
  final List<CoachStep> visibleSteps;
  final ShowcaseCoachConfig? config;
  final void Function(int currentStep, int totalSteps)? onStepChanged;
  final void Function(int stepIndex, CoachStep step)? onStepStart;
  final void Function(int stepIndex, CoachStep step)? onStepComplete;
  final VoidCallback? onDone;
  final VoidCallback? onSkip;
  final VoidCallback close;
  final Future<void> Function(GlobalKey key) ensureVisible;
  final Rect? Function(GlobalKey key) targetRect;
  final VoidCallback triggerHapticFeedback;

  @override
  State<_ShowcaseCoachOverlayContent> createState() =>
      _ShowcaseCoachOverlayContentState();
}

class _ShowcaseCoachOverlayContentState
    extends State<_ShowcaseCoachOverlayContent> {
  Timer? _autoAdvanceTimer;

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  void _handleNext(int index) {
    // Cancel any existing auto-advance timer
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;

    // Call onStepComplete before moving to next
    widget.onStepComplete?.call(index, widget.visibleSteps[index]);

    if (index == widget.visibleSteps.length - 1) {
      widget.triggerHapticFeedback();
      widget.onDone?.call();
      widget.close();
    } else {
      widget.triggerHapticFeedback();
      widget.controller.value = index + 1;
    }
  }

  void _setupAutoAdvance(int index) {
    // Cancel any existing timer
    _autoAdvanceTimer?.cancel();

    final step = widget.visibleSteps[index];
    final autoAdvanceEnabled = widget.config?.enableAutoAdvance ?? false;
    final autoAdvanceDuration = step.autoAdvanceAfter;

    if (autoAdvanceEnabled && autoAdvanceDuration != null) {
      _autoAdvanceTimer = Timer(autoAdvanceDuration, () {
        if (mounted) {
          _handleNext(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.controller,
      builder: (context, index, _) {
        final step = widget.visibleSteps[index];

        // Call onStepChanged whenever step changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onStepChanged?.call(index + 1, widget.visibleSteps.length);
          // Call onStepStart for new step (after first)
          if (index > 0) {
            widget.onStepStart?.call(index, step);
            widget.triggerHapticFeedback();
          }
          // Setup auto-advance for this step
          _setupAutoAdvance(index);
        });

        // Ensure current step is visible when it changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.ensureVisible(step.targetKey);
        });

        final rect = widget.targetRect(step.targetKey);
        return _CoachOverlay(
          step: step,
          rect: rect,
          isLast: index == widget.visibleSteps.length - 1,
          currentStep: index + 1,
          totalSteps: widget.visibleSteps.length,
          onNext: () => _handleNext(index),
          onSkip: () {
            _autoAdvanceTimer?.cancel();
            widget.onSkip?.call();
            widget.close();
          },
          config: widget.config,
        );
      },
    );
  }
}
