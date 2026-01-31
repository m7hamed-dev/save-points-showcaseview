import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_showcaseview/save_points_showcaseview.dart';

void main() {
  group('CoachStep', () {
    test('should create a CoachStep with required parameters', () {
      final key = GlobalKey();
      final step = CoachStep(
        targetKey: key,
        title: 'Test Title',
        description: ['Test description'],
      );

      expect(step.targetKey, key);
      expect(step.title, 'Test Title');
      expect(step.description, ['Test description']);
    });

    test('should default showIf to true', () {
      final key = GlobalKey();
      final step = CoachStep(
        targetKey: key,
        title: 'Test',
        description: ['Test'],
      );

      expect(step.showIf, true);
      expect(step.isVisible, true);
    });

    test('should respect showIf parameter', () {
      final key = GlobalKey();
      final step = CoachStep(
        targetKey: key,
        title: 'Test',
        description: ['Test'],
        showIf: false,
      );

      expect(step.showIf, false);
      expect(step.isVisible, false);
    });

    test('should respect shouldShow function', () {
      final key = GlobalKey();
      final step = CoachStep(
        targetKey: key,
        title: 'Test',
        description: ['Test'],
        shouldShow: () => false,
      );

      expect(step.isVisible, false);
    });

    test('shouldShow takes precedence over showIf', () {
      final key = GlobalKey();
      final step = CoachStep(
        targetKey: key,
        title: 'Test',
        description: ['Test'],
        shouldShow: () => false,
      );

      expect(step.isVisible, false);
    });
  });

  group('ShowcaseCoachConfig', () {
    test('should create config with default values', () {
      const config = ShowcaseCoachConfig();

      expect(config.cardStyle, ShowcaseCoachCardStyle.glass);
    });

    test('should create config with custom values', () {
      const config = ShowcaseCoachConfig(
        cardStyle: ShowcaseCoachCardStyle.normal,
        primaryColor: Colors.blue,
      );

      expect(config.cardStyle, ShowcaseCoachCardStyle.normal);
      expect(config.primaryColor, Colors.blue);
    });
  });
}
