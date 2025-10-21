# SmokeTracker Refactoring Guide

## Overview

This document describes the comprehensive refactoring performed on the SmokeTracker Flutter application to improve type safety, maintainability, and adherence to Flutter/Dart best practices.

## Refactoring Objectives

1. **Type Safety**: Replace all `Map<String, dynamic>` usage with strongly-typed data models
2. **Immutability**: Use immutable data structures throughout the application
3. **Error Handling**: Implement proper error handling with custom exceptions and Result types
4. **Documentation**: Add comprehensive documentation for all public APIs
5. **Constants**: Extract all hardcoded values to centralized constants
6. **Clean Architecture**: Separate concerns between models, services, and UI

## Changes Made

### 1. Data Models (lib/models/)

Created immutable, type-safe models to replace raw Map usage:

#### UserProfile (`user_profile.dart`)
```dart
@immutable
class UserProfile {
  final String name;
  final String email;
  final DateTime joinDate;
  final DateTime? quitDate;
  // ... other fields
}
```

**Features:**
- Immutable with `@immutable` annotation
- Type-safe fields with proper null safety
- `fromJson` and `toJson` for serialization
- `copyWith` for creating modified copies
- Equality operators for value comparison
- Factory constructor for default profile

#### SmokingEntry (`smoking_entry.dart`)
Represents individual smoking events with:
- Timestamp
- Count of cigarettes
- Optional trigger, mood, location
- Notes field

#### CravingEntry (`craving_entry.dart`)
Tracks craving episodes with:
- Intensity level
- Management technique used
- Duration
- Success status
- Optional trigger and notes

#### Achievement (`achievement.dart`)
Represents milestones with:
- Title and description
- Category (time, health, savings, etc.)
- Level (bronze, silver, gold, platinum)
- Unlock status and date
- Progress tracking (0.0 to 1.0)

#### AppSettings (`app_settings.dart`)
User preferences including:
- Language selection
- Notification preferences
- Theme mode
- Currency
- Various toggle options

### 2. Constants (lib/core/constants.dart)

Extracted all hardcoded values to named constants:

```dart
class StorageKeys {
  static const String smokingData = 'smoking_data';
  static const String userProfile = 'user_profile';
  // ... other keys
}

class DefaultUserProfile {
  static const String name = 'María';
  static const String email = 'carlos.rodriguez@email.com';
  // ... other defaults
}

class HealthMilestones {
  static const int twentyMinutes = 20;
  static const int oneHour = 60;
  // ... other milestones
}
```

**Categories:**
- Storage keys
- Default values
- Health milestones
- Craving techniques
- Achievement categories and levels
- Theme modes
- Supported languages
- Trigger types
- Mood types
- Location types
- Currency symbols
- Time durations
- Animation durations
- Export file names

### 3. Custom Exceptions (lib/core/exceptions.dart)

Implemented a hierarchy of custom exception types:

```dart
abstract class AppException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
}
```

**Exception Types:**
- `StorageException` - For storage operation failures
- `ParseException` - For JSON parsing errors
- `ValidationException` - For data validation errors
- `InitializationException` - For service initialization failures
- `NotFoundException` - For missing resources
- `StateException` - For invalid state operations
- `NetworkException` - For network-related failures
- `FileException` - For file operation failures

Each exception type includes factory constructors for common scenarios.

### 4. Result Type (lib/core/result.dart)

Implemented a functional Result/Either pattern for explicit error handling:

```dart
sealed class Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(AppException exception) = Failure<T>;
}
```

**Features:**
- Explicit success/failure representation
- Pattern matching support with `when`
- Transformation methods (`map`, `flatMap`)
- Error transformation (`mapError`)
- Side effect methods (`onSuccess`, `onFailure`)
- Async extensions for Future<Result<T>>
- Helper functions (`runCatching`, `runCatchingAsync`)

**Usage Example:**
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

final result = await loadProfile();
result.when(
  success: (profile) => print('Loaded: ${profile.name}'),
  failure: (error) => print('Error: $error'),
);
```

### 5. Type-Safe Service Layer (lib/services/typed_data_service.dart)

Created a new service that uses typed models instead of Map<String, dynamic>:

**Old Approach:**
```dart
Future<List<Map<String, dynamic>>> getSmokingData() async {
  // Returns raw maps
}
```

**New Approach:**
```dart
Future<List<SmokingEntry>> getSmokingData() async {
  // Returns typed models
}
```

**Service Features:**
- Singleton pattern
- Proper initialization checks
- Type-safe CRUD operations
- Comprehensive error handling
- Debug logging
- Data export functionality
- Maintains backward compatibility with storage keys

**Methods:**
- User Profile: `getUserProfile()`, `saveUserProfile()`, `updateUserProfile()`
- Quit Date: `getQuitDate()`, `setQuitDate()`, `getTimeSinceQuit()`
- Smoking Data: `getSmokingData()`, `saveSmokingData()`, `addSmokingEntry()`, `deleteSmokingEntry()`
- Craving History: `getCravingHistory()`, `saveCravingHistory()`, `addCravingEntry()`
- Achievements: `getAchievements()`, `saveAchievements()`
- Settings: `getSettings()`, `saveSettings()`, `updateSettings()`
- Utility: `clearAllData()`, `exportData()`

### 6. Barrel Exports

Created centralized export files for clean imports:

**lib/models/models.dart:**
```dart
export 'achievement.dart';
export 'app_settings.dart';
export 'craving_entry.dart';
export 'smoking_entry.dart';
export 'user_profile.dart';
```

**lib/core/app_export.dart:**
Updated to include all core exports (models, constants, exceptions, result).

## Migration Guide

### For Developers Using the Old Service

**Step 1: Import the new service**
```dart
import 'package:smoketracker/services/typed_data_service.dart';
import 'package:smoketracker/models/models.dart';
```

**Step 2: Replace old service calls**

**Before:**
```dart
final service = LocalDataService();
final Map<String, dynamic> profile = await service.getUserProfile();
final String name = profile['name'] as String;
```

**After:**
```dart
final service = TypedDataService();
final UserProfile profile = await service.getUserProfile();
final String name = profile.name; // Type-safe!
```

**Step 3: Update data usage**

**Before:**
```dart
final smokingData = await service.getSmokingData();
for (var entry in smokingData) {
  final timestamp = DateTime.parse(entry['timestamp'] as String);
  final location = entry['location'] as String?;
  // ... more parsing
}
```

**After:**
```dart
final smokingData = await service.getSmokingData();
for (var entry in smokingData) {
  final timestamp = entry.timestamp; // Already a DateTime!
  final location = entry.location; // Already typed!
  // No parsing needed
}
```

**Step 4: Handle errors properly**

**Before:**
```dart
try {
  final profile = await service.getUserProfile();
  // use profile
} catch (e) {
  print('Error: $e'); // Generic error handling
}
```

**After (Option 1 - Traditional):**
```dart
try {
  final profile = await service.getUserProfile();
  // use profile
} on StorageException catch (e) {
  print('Storage error: ${e.message}');
} on ParseException catch (e) {
  print('Parse error: ${e.message}');
}
```

**After (Option 2 - Result type):**
```dart
Future<Result<UserProfile>> loadProfile() async {
  try {
    final profile = await service.getUserProfile();
    return Result.success(profile);
  } catch (e, st) {
    if (e is AppException) {
      return Result.failure(e);
    }
    return Result.failure(
      AppException('Unexpected error', cause: e, stackTrace: st),
    );
  }
}

final result = await loadProfile();
result.when(
  success: (profile) => updateUI(profile),
  failure: (error) => showError(error.message),
);
```

## Best Practices

### 1. Always Use Typed Models
❌ **Don't:**
```dart
Map<String, dynamic> user = {'name': 'John', 'age': 30};
```

✅ **Do:**
```dart
UserProfile user = UserProfile(name: 'John', age: 30);
```

### 2. Use Constants for Hardcoded Values
❌ **Don't:**
```dart
if (category == 'time') { ... }
```

✅ **Do:**
```dart
if (category == AchievementCategories.time) { ... }
```

### 3. Handle Errors Explicitly
❌ **Don't:**
```dart
final data = await service.getData(); // What if it fails?
```

✅ **Do:**
```dart
try {
  final data = await service.getData();
  // handle success
} on StorageException catch (e) {
  // handle storage failure
} on ParseException catch (e) {
  // handle parse failure
}
```

### 4. Use copyWith for Updates
❌ **Don't:**
```dart
// Mutating data (if it were mutable)
profile.name = 'New Name';
```

✅ **Do:**
```dart
final updatedProfile = profile.copyWith(name: 'New Name');
```

### 5. Leverage Pattern Matching
❌ **Don't:**
```dart
if (result.isSuccess) {
  final value = result.valueOrNull;
  if (value != null) {
    process(value);
  }
} else {
  final error = result.exceptionOrNull;
  if (error != null) {
    handleError(error);
  }
}
```

✅ **Do:**
```dart
result.when(
  success: (value) => process(value),
  failure: (error) => handleError(error),
);
```

## Testing

### Unit Testing Models

```dart
void main() {
  group('UserProfile', () {
    test('should create from JSON', () {
      final json = {
        'name': 'John',
        'email': 'john@example.com',
        // ... other fields
      };
      
      final profile = UserProfile.fromJson(json);
      
      expect(profile.name, 'John');
      expect(profile.email, 'john@example.com');
    });

    test('should serialize to JSON', () {
      final profile = UserProfile(
        name: 'John',
        email: 'john@example.com',
        // ... other fields
      );
      
      final json = profile.toJson();
      
      expect(json['name'], 'John');
      expect(json['email'], 'john@example.com');
    });

    test('copyWith should create modified copy', () {
      final original = UserProfile.defaultProfile();
      final modified = original.copyWith(name: 'Jane');
      
      expect(modified.name, 'Jane');
      expect(modified.email, original.email); // Unchanged
    });
  });
}
```

### Testing Service

```dart
void main() {
  late TypedDataService service;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    service = TypedDataService();
    await service.init();
  });

  group('TypedDataService', () {
    test('should save and retrieve user profile', () async {
      final profile = UserProfile.defaultProfile();
      
      await service.saveUserProfile(profile);
      final retrieved = await service.getUserProfile();
      
      expect(retrieved, profile);
    });

    test('should add smoking entry', () async {
      final entry = SmokingEntry(
        id: 0, // Will be overwritten
        timestamp: DateTime.now(),
        count: 1,
      );
      
      await service.addSmokingEntry(entry);
      final data = await service.getSmokingData();
      
      expect(data.length, greaterThan(0));
      expect(data.first.count, 1);
    });
  });
}
```

## Performance Considerations

### 1. Use Const Constructors
All model classes support const constructors when possible:
```dart
const profile = UserProfile(...); // Compile-time constant
```

### 2. Minimize Serialization
Cache deserialized objects when possible:
```dart
// Bad: Deserializing on every access
String getName() => (json['name'] as String);

// Good: Deserialize once
final name = json['name'] as String;
```

### 3. Use Lazy Loading
Don't load all data at once if not needed:
```dart
// Load only what's needed
final recentEntries = (await service.getSmokingData())
    .where((e) => e.timestamp.isAfter(DateTime.now().subtract(Duration(days: 7))))
    .toList();
```

## Future Improvements

1. **State Management**: Integrate with Provider, Riverpod, or Bloc
2. **Caching**: Add in-memory caching layer
3. **Validation**: Add validation methods to models
4. **Serialization**: Consider using json_serializable for code generation
5. **Testing**: Achieve >80% code coverage
6. **Documentation**: Add more usage examples
7. **Performance**: Profile and optimize hot paths
8. **Logging**: Add structured logging

## Conclusion

This refactoring significantly improves the codebase's:
- **Type Safety**: Compile-time error detection
- **Maintainability**: Clear data structures and error handling
- **Testability**: Easier to test with typed models
- **Developer Experience**: Better IDE support and autocomplete
- **Documentation**: Self-documenting code with types

The new architecture provides a solid foundation for future development while maintaining backward compatibility with existing storage.

## Support

For questions or issues with the refactored code:
1. Check this guide for common patterns
2. Review the inline documentation (dartdoc comments)
3. Look at the unit tests for usage examples
4. Consult Flutter/Dart best practices documentation
