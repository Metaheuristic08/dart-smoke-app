# Flutter/Dart Best Practices for SmokeTracker

## Overview

This document outlines the best practices followed in the SmokeTracker application and serves as a guide for contributors and developers working on the codebase.

## Table of Contents

1. [Type Safety](#type-safety)
2. [Immutability](#immutability)
3. [Naming Conventions](#naming-conventions)
4. [Code Organization](#code-organization)
5. [Error Handling](#error-handling)
6. [Performance](#performance)
7. [State Management](#state-management)
8. [Widget Composition](#widget-composition)
9. [Testing](#testing)
10. [Documentation](#documentation)

## Type Safety

### Use Explicit Types

❌ **Don't:**
```dart
var data = getData(); // What type is this?
dynamic value = getValue(); // Avoid dynamic
```

✅ **Do:**
```dart
final UserProfile profile = getUserProfile();
final String name = getName();
final List<SmokingEntry> entries = getEntries();
```

### Avoid `any` and `dynamic`

❌ **Don't:**
```dart
Future<dynamic> fetchData() async {
  // Returns unknown type
}

Map<String, dynamic> user = {'name': 'John'};
```

✅ **Do:**
```dart
Future<UserProfile> fetchProfile() async {
  // Returns known type
}

final UserProfile user = UserProfile(name: 'John');
```

### Use Proper Generics

❌ **Don't:**
```dart
List items = []; // List of what?
Map data = {}; // Map of what to what?
```

✅ **Do:**
```dart
final List<SmokingEntry> entries = [];
final Map<String, UserProfile> users = {};
```

## Immutability

### Use `@immutable` Annotation

❌ **Don't:**
```dart
class UserProfile {
  String name; // Mutable field
  
  UserProfile(this.name);
}
```

✅ **Do:**
```dart
@immutable
class UserProfile {
  final String name; // Immutable field
  
  const UserProfile(this.name);
}
```

### Implement `copyWith` for Updates

❌ **Don't:**
```dart
user.name = 'New Name'; // Direct mutation
```

✅ **Do:**
```dart
final updatedUser = user.copyWith(name: 'New Name');
```

### Use `const` Constructors

❌ **Don't:**
```dart
final widget = Container(
  child: Text('Hello'),
);
```

✅ **Do:**
```dart
const widget = SizedBox(
  child: Text('Hello'),
);
```

## Naming Conventions

### File Names

Use **snake_case** for all file names:

✅ **Correct:**
- `user_profile.dart`
- `smoking_entry.dart`
- `craving_management.dart`

❌ **Incorrect:**
- `UserProfile.dart`
- `smokingEntry.dart`
- `CravingManagement.dart`

### Class Names

Use **PascalCase** for class names:

✅ **Correct:**
```dart
class UserProfile {}
class SmokingEntry {}
class CravingManagementService {}
```

❌ **Incorrect:**
```dart
class userProfile {}
class smoking_entry {}
class cravingManagementService {}
```

### Variable Names

Use **camelCase** for variable names:

✅ **Correct:**
```dart
final String userName = 'John';
final DateTime quitDate = DateTime.now();
final bool isUserLoggedIn = true;
```

❌ **Incorrect:**
```dart
final String UserName = 'John';
final DateTime quit_date = DateTime.now();
final bool is_user_logged_in = true;
```

### Constants

Use **camelCase** for constant names (not SCREAMING_CASE):

✅ **Correct:**
```dart
const String apiBaseUrl = 'https://api.example.com';
const int maxRetries = 3;
```

❌ **Incorrect:**
```dart
const String API_BASE_URL = 'https://api.example.com';
const int MAX_RETRIES = 3;
```

Exception: For compile-time constants in a class, use camelCase:

```dart
class AppConstants {
  static const String appName = 'SmokeTracker';
  static const int defaultTimeout = 30;
}
```

### Boolean Variables

Use clear, affirmative names:

✅ **Correct:**
```dart
bool isLoading = false;
bool hasError = false;
bool canSubmit = true;
bool isUserLoggedIn = false;
```

❌ **Incorrect:**
```dart
bool loading = false; // Not clear it's boolean
bool notLoggedIn = true; // Double negative
bool flag = false; // Too generic
```

## Code Organization

### Import Order

1. Dart SDK imports
2. Flutter imports
3. Package imports
4. Relative imports

```dart
// Dart SDK
import 'dart:async';
import 'dart:convert';

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Packages
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

// Relative imports
import '../models/models.dart';
import '../services/typed_data_service.dart';
```

### File Structure

Organize code within files:

```dart
// 1. Imports
import 'package:flutter/material.dart';

// 2. Public constants
const int maxLength = 100;

// 3. Public classes
class MyWidget extends StatelessWidget {
  // 3a. Public static fields
  static const String routeName = '/my-widget';
  
  // 3b. Public instance fields
  final String title;
  
  // 3c. Constructor
  const MyWidget({required this.title});
  
  // 3d. Public methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 3e. Private methods
  void _handleTap() {
    // ...
  }
}

// 4. Private classes
class _InternalWidget extends StatelessWidget {
  // ...
}
```

### Directory Structure

Organize files by feature:

```
lib/
├── core/           # Shared utilities
├── models/         # Data models
├── services/       # Business logic
├── presentation/   # UI
│   ├── feature_a/
│   │   ├── feature_a.dart
│   │   └── widgets/
│   └── feature_b/
│       ├── feature_b.dart
│       └── widgets/
└── main.dart
```

## Error Handling

### Use Specific Exception Types

❌ **Don't:**
```dart
throw Exception('Something went wrong');
```

✅ **Do:**
```dart
throw StorageException.readFailure(
  key: 'user_profile',
  cause: error,
);
```

### Catch Specific Exceptions

❌ **Don't:**
```dart
try {
  // operation
} catch (e) {
  print('Error: $e');
}
```

✅ **Do:**
```dart
try {
  // operation
} on StorageException catch (e) {
  _handleStorageError(e);
} on ParseException catch (e) {
  _handleParseError(e);
} catch (e, st) {
  _handleUnknownError(e, st);
}
```

### Use Result Type for Expected Failures

❌ **Don't:**
```dart
Future<UserProfile> loadProfile() async {
  // Throws on failure
}
```

✅ **Do:**
```dart
Future<Result<UserProfile>> loadProfile() async {
  try {
    final profile = await service.getProfile();
    return Result.success(profile);
  } catch (e, st) {
    return Result.failure(
      StorageException.readFailure(cause: e, stackTrace: st),
    );
  }
}
```

### Provide Context in Error Messages

❌ **Don't:**
```dart
throw Exception('Failed');
```

✅ **Do:**
```dart
throw StorageException(
  'Failed to read user profile from SharedPreferences',
  cause: originalError,
);
```

## Performance

### Use `const` Where Possible

❌ **Don't:**
```dart
return Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
);
```

✅ **Do:**
```dart
return Container(
  padding: const EdgeInsets.all(16),
  child: const Text('Hello'),
);
```

### Use `ListView.builder` for Large Lists

❌ **Don't:**
```dart
ListView(
  children: entries.map((e) => EntryTile(e)).toList(),
);
```

✅ **Do:**
```dart
ListView.builder(
  itemCount: entries.length,
  itemBuilder: (context, index) => EntryTile(entries[index]),
);
```

### Implement `keys` for List Items

❌ **Don't:**
```dart
ListView.builder(
  itemBuilder: (context, index) => EntryTile(entries[index]),
);
```

✅ **Do:**
```dart
ListView.builder(
  itemBuilder: (context, index) {
    final entry = entries[index];
    return EntryTile(
      key: ValueKey(entry.id),
      entry: entry,
    );
  },
);
```

### Avoid Rebuilds with `const`

❌ **Don't:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Static Text'), // Rebuilds every time
        DynamicWidget(),
      ],
    );
  }
}
```

✅ **Do:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Static Text'), // Won't rebuild
        DynamicWidget(),
      ],
    );
  }
}
```

### Cache Expensive Computations

❌ **Don't:**
```dart
class MyWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final expensiveValue = _computeExpensiveValue(); // Computed on every build
    return Text('$expensiveValue');
  }
}
```

✅ **Do:**
```dart
class MyWidget extends StatefulWidget {
  late final int _cachedValue;
  
  @override
  void initState() {
    super.initState();
    _cachedValue = _computeExpensiveValue(); // Computed once
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('$_cachedValue');
  }
}
```

## State Management

### Use `StatelessWidget` When Possible

❌ **Don't:**
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Text('Static content'); // No state needed
  }
}
```

✅ **Do:**
```dart
class MyWidget extends StatelessWidget {
  const MyWidget();
  
  @override
  Widget build(BuildContext context) {
    return const Text('Static content');
  }
}
```

### Initialize State in `initState`

❌ **Don't:**
```dart
class _MyWidgetState extends State<MyWidget> {
  List<String> items = []; // Not initialized
  
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      items = loadItems(); // Loading in build
    }
    return ListView(children: items.map(Text.new).toList());
  }
}
```

✅ **Do:**
```dart
class _MyWidgetState extends State<MyWidget> {
  late List<String> items;
  
  @override
  void initState() {
    super.initState();
    items = loadItems(); // Load once in initState
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(children: items.map(Text.new).toList());
  }
}
```

### Dispose Resources

❌ **Don't:**
```dart
class _MyWidgetState extends State<MyWidget> {
  final controller = TextEditingController();
  
  // No dispose method - memory leak!
}
```

✅ **Do:**
```dart
class _MyWidgetState extends State<MyWidget> {
  late final TextEditingController controller;
  
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

## Widget Composition

### Prefer Composition Over Inheritance

❌ **Don't:**
```dart
class StyledButton extends ElevatedButton {
  StyledButton({required VoidCallback onPressed, required String text})
      : super(
          onPressed: onPressed,
          child: Text(text),
        );
}
```

✅ **Do:**
```dart
class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  
  const StyledButton({
    required this.onPressed,
    required this.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
```

### Extract Widgets for Reusability

❌ **Don't:**
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Header'),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Another Header'),
        ),
      ],
    );
  }
}
```

✅ **Do:**
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HeaderCard(text: 'Header'),
        _HeaderCard(text: 'Another Header'),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String text;
  
  const _HeaderCard({required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}
```

### Use Builder Methods for Complex Widgets

✅ **Good:**
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildContent(),
        _buildFooter(),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Container(
      // Complex header widget
    );
  }
  
  Widget _buildContent() {
    return ListView(
      // Complex content
    );
  }
  
  Widget _buildFooter() {
    return Row(
      // Complex footer
    );
  }
}
```

## Testing

### Write Tests for Models

```dart
void main() {
  group('UserProfile', () {
    test('should create from JSON', () {
      final json = {
        'name': 'John',
        'email': 'john@example.com',
        // ...
      };
      
      final profile = UserProfile.fromJson(json);
      
      expect(profile.name, 'John');
      expect(profile.email, 'john@example.com');
    });
    
    test('copyWith should create modified copy', () {
      final original = UserProfile.defaultProfile();
      final modified = original.copyWith(name: 'Jane');
      
      expect(modified.name, 'Jane');
      expect(modified.email, original.email);
    });
  });
}
```

### Test Edge Cases

```dart
test('should handle empty list', () {
  final entries = <SmokingEntry>[];
  final result = calculateAverage(entries);
  expect(result, 0.0);
});

test('should handle null values', () {
  final entry = SmokingEntry(
    id: 1,
    timestamp: DateTime.now(),
    trigger: null, // Null trigger
  );
  
  expect(entry.trigger, isNull);
});
```

### Use Descriptive Test Names

❌ **Don't:**
```dart
test('test1', () {
  // What does this test?
});
```

✅ **Do:**
```dart
test('should throw ValidationException when name is empty', () {
  // Clear what's being tested
});
```

## Documentation

### Document All Public APIs

❌ **Don't:**
```dart
class UserProfile {
  final String name;
}
```

✅ **Do:**
```dart
/// Represents a user's profile information including smoking habits
/// and quit journey details.
/// 
/// This model contains essential user data for tracking smoking cessation
/// progress and personalizing the app experience.
@immutable
class UserProfile {
  /// User's display name
  final String name;
}
```

### Use dartdoc Comments

```dart
/// Calculates the time elapsed since the user quit smoking.
/// 
/// Returns null if no quit date is set.
/// 
/// Example:
/// ```dart
/// final duration = await service.getTimeSinceQuit();
/// if (duration != null) {
///   print('${duration.inDays} days smoke-free!');
/// }
/// ```
Future<Duration?> getTimeSinceQuit() async {
  // Implementation
}
```

### Document Complex Logic

```dart
/// Generates achievements based on the quit date and progress.
/// 
/// The achievement system uses the following criteria:
/// - First Hour: Unlocked immediately after quitting
/// - First Day: Unlocked after 24 hours
/// - Three Days: Unlocked after 72 hours (nicotine elimination)
/// - One Week: Unlocked after 7 days
/// - Money Saver: Unlocked when savings exceed €20
/// 
/// Each achievement includes:
/// - Unlock status (based on time since quit)
/// - Unlock date (if unlocked)
/// - Progress value (0.0 to 1.0)
Future<List<Achievement>> _generateAchievements() async {
  // Implementation
}
```

## Summary

Following these best practices ensures:
- **Type Safety**: Compile-time error detection
- **Maintainability**: Easy to understand and modify
- **Performance**: Optimized rendering and memory usage
- **Testability**: Easy to write and maintain tests
- **Consistency**: Predictable code structure
- **Documentation**: Self-documenting code

## Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
