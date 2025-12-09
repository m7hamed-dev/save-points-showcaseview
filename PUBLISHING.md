# Publishing to pub.dev

## Prerequisites

1. Create a pub.dev account at https://pub.dev
2. Verify your email address
3. Get your API token from https://pub.dev/account/tokens

## Steps to Publish

### 1. Update Version

Update the version in `pubspec.yaml` following semantic versioning:
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### 2. Update CHANGELOG.md

Document all changes in `CHANGELOG.md` for the new version.

### 3. Verify Package

Run these commands to verify your package:

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests (if you have any)
flutter test

# Dry run publish (checks without publishing)
dart pub publish --dry-run
```

### 4. Publish

```bash
# Publish to pub.dev
dart pub publish
```

Enter your API token when prompted.

### 5. Verify Publication

Check your package at:
`https://pub.dev/packages/save_points_showcaseview`

## Important Notes

- **Package Name**: The package name `save_points_showcaseview` must be available on pub.dev
- **Version**: Each version can only be published once
- **Breaking Changes**: Use major version bumps for breaking changes
- **Documentation**: Ensure README.md is comprehensive
- **Example**: The example app should demonstrate key features

## Updating the Package

1. Make your changes
2. Update version in `pubspec.yaml`
3. Update `CHANGELOG.md`
4. Run `dart pub publish --dry-run` to verify
5. Run `dart pub publish` to publish

## Troubleshooting

- **Name Conflict**: If the package name is taken, choose a different name
- **Validation Errors**: Fix all issues reported by `dart pub publish --dry-run`
- **Missing Files**: Ensure all necessary files are included (not in .pubignore)

