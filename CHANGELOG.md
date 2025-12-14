# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-12-14

### Added
- Comprehensive dartdoc documentation for all public APIs
- Accessibility support with semantic labels for screen readers
- Minimum tap target sizes (48x48) for better accessibility compliance
- Internal constants class for better code maintainability

### Improved
- Enhanced code organization with proper part-of directives
- Better error handling with more descriptive validation messages
- Improved type safety throughout the codebase
- Extracted magic numbers to named constants for better maintainability
- Added library-level documentation with quick start examples
- Improved documentation for all classes, methods, and parameters

### Changed
- Internal refactoring for better code organization
- Validation retry logic now uses configurable constants
- Animation durations and values now centralized in constants class

## [1.0.1] - 2024-12-10

### Fixed
- Updated repository URLs in README and pubspec.yaml to match actual GitHub repository
- Fixed image URLs to use absolute GitHub raw URLs for proper display on pub.dev
- Compressed preview GIF for better pub.dev compatibility

## [1.0.0] - 2024-12-19

### Added
- Initial release of Showcase Coach
- Beautiful glassmorphism design with backdrop blur
- Smooth animations and transitions
- Step-by-step guided tour functionality
- Conditional step visibility support
- Automatic validation of GlobalKeys
- Smart scrolling to bring widgets into view
- Dark mode support
- Multiple description pages with swipe navigation
- Pulsing highlight animations
- User-friendly error dialogs
- Customizable colors and styling

### Features
- `ShowcaseCoach.show()` - Main method to display the showcase
- `CoachStep` - Class to define showcase steps
- Automatic duplicate key detection
- Widget visibility validation
- Smooth step transitions
- Modern UI with glassmorphism effects

