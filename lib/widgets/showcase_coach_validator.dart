part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Validates showcase coach steps and their associated GlobalKeys.
///
/// This class provides static validation methods to ensure that:
/// - All GlobalKeys are unique across steps
/// - All GlobalKeys are attached to visible widgets in the widget tree
///
/// Validation failures return descriptive error messages that can be
/// displayed to users or developers.
///
/// This class is internal to the package and should not be used directly
/// by consumers.
class ShowcaseCoachValidator {
  ShowcaseCoachValidator._();

  /// Validates that all GlobalKeys in the steps are unique.
  ///
  /// Each step must use a different [GlobalKey]. If duplicate keys are
  /// found, returns a descriptive error message listing which steps share
  /// the same key.
  ///
  /// Returns `null` if validation passes, or an error message string if
  /// duplicates are found.
  static String? validateSteps(List<CoachStep> steps) {
    final keyOccurrences = <GlobalKey, List<int>>{};

    for (var i = 0; i < steps.length; i++) {
      final key = steps[i].targetKey;
      keyOccurrences.putIfAbsent(key, () => []).add(i);
    }

    final duplicates = keyOccurrences.entries
        .where((entry) => entry.value.length > 1)
        .toList();

    if (duplicates.isNotEmpty) {
      final buffer = StringBuffer(
        'Duplicate GlobalKeys detected.\n\n'
        'Each step must use a unique GlobalKey.\n\n',
      );

      for (final duplicate in duplicates) {
        final indices = duplicate.value;
        final stepTitles =
            indices.map((i) => 'Step ${i + 1}: "${steps[i].title}"').join(', ');
        buffer.writeln('• $stepTitles');
      }

      return buffer.toString();
    }

    return null;
  }

  /// Validates that all GlobalKeys are attached and visible in the widget tree.
  ///
  /// This method checks that:
  /// - Each key has a valid [BuildContext]
  /// - Each key's render object is attached to the render tree
  /// - Each key's render object has a non-zero size
  ///
  /// The method will retry validation up to [maxRetries] times with
  /// [retryDelay] between attempts, allowing widgets time to be built
  /// and laid out.
  ///
  /// Returns `null` if all keys are valid, or an error message string
  /// listing which steps have invalid or missing keys.
  static Future<String?> validateKeysVisible(
    List<CoachStep> steps, {
    int maxRetries = ShowcaseCoachConstants.maxValidationRetries,
    Duration retryDelay = ShowcaseCoachConstants.validationRetryDelay,
  }) async {
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      final missingKeys = <int>[];

      for (var i = 0; i < steps.length; i++) {
        final step = steps[i];
        final key = step.targetKey;

        // Check if the key has a context
        final context = key.currentContext;
        if (context == null) {
          missingKeys.add(i);
          continue;
        }

        // Check if the render object is attached and has size
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null ||
            !renderBox.attached ||
            !renderBox.hasSize ||
            renderBox.size == Size.zero) {
          missingKeys.add(i);
          continue;
        }
      }

      // If all keys are found, return null (success)
      if (missingKeys.isEmpty) {
        return null;
      }

      // If this is not the last attempt, wait and retry
      if (attempt < maxRetries - 1) {
        await Future.delayed(retryDelay);
        continue;
      }

      // Last attempt failed, return error message
      final buffer = StringBuffer(
        'Some target widgets are not visible or not found.\n\n'
        'Make sure all widgets with GlobalKeys are:\n'
        '• Built and visible in the widget tree\n'
        '• Not hidden or off-screen\n'
        '• Have a valid size\n\n'
        'Missing or invisible keys:\n',
      );

      for (final index in missingKeys) {
        buffer.writeln('• Step ${index + 1}: "${steps[index].title}"');
      }

      return buffer.toString();
    }

    return null;
  }
}
