part of 'package:save_points_showcaseview/save_points_showcaseview.dart';

/// Utility class for displaying showcase coach error dialogs.
///
/// This class provides a consistent way to display validation errors
/// and other issues to users in a friendly, non-technical format.
///
/// This class is internal to the package and should not be used directly
/// by consumers.
class ShowcaseCoachError {
  ShowcaseCoachError._();

  /// Shows an error dialog to the user with the given message.
  ///
  /// The dialog displays a standard error icon and allows the user to
  /// dismiss it. This is used for validation failures and other issues
  /// that prevent the showcase coach from displaying.
  ///
  /// The dialog will only be shown if [context] is still mounted.
  static Future<void> showErrorDialog(
    BuildContext context,
    String message,
  ) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 32),
        title: const Text(
          'Showcase Coach Error',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            message,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
