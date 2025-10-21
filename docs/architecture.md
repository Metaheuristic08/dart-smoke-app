# SmokeTracker Architecture Documentation

## Overview

SmokeTracker is a Flutter mobile application designed to help users track their journey to quit smoking. The application follows Flutter/Dart best practices with a focus on type safety, immutability, and clean architecture.

## Architecture Pattern

The application follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Widgets, Screens, UI Components)  │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│        Service Layer                │
│  (Business Logic, Data Management)  │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│         Data Layer                  │
│  (Local Storage, SharedPreferences) │
└─────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── core/                      # Core utilities and shared code
│   ├── app_export.dart       # Barrel exports for common imports
│   ├── color_extensions.dart # Color utility extensions
│   ├── constants.dart        # Application-wide constants
│   ├── exceptions.dart       # Custom exception types
│   └── result.dart           # Result/Either type for error handling
│
├── models/                    # Data models
│   ├── achievement.dart      # Achievement/milestone model
│   ├── app_settings.dart     # User settings model
│   ├── craving_entry.dart    # Craving episode model
│   ├── smoking_entry.dart    # Smoking event model
│   ├── user_profile.dart     # User profile model
│   └── models.dart           # Barrel export for all models
│
├── presentation/              # UI layer
│   ├── dashboard_home/       # Home dashboard screen
│   │   ├── dashboard_home.dart
│   │   └── widgets/          # Dashboard-specific widgets
│   ├── craving_management/   # Craving management screen
│   ├── progress_analytics/   # Analytics and charts screen
│   ├── quit_timer/           # Quit timer and milestones screen
│   ├── settings_profile/     # Settings and profile screen
│   └── splash_screen/        # Initial loading screen
│
├── routes/                    # Navigation
│   └── app_routes.dart       # Route definitions and navigation
│
├── services/                  # Business logic and data services
│   ├── local_data_service.dart  # Legacy data service (Map-based)
│   └── typed_data_service.dart  # New type-safe data service
│
├── theme/                     # Theming
│   └── app_theme.dart        # Material theme configuration
│
├── widgets/                   # Reusable widgets
│   ├── custom_error_widget.dart  # Error display widget
│   ├── custom_icon_widget.dart   # Icon widget with fallbacks
│   └── custom_image_widget.dart  # Image widget with caching
│
└── main.dart                  # Application entry point
```

## Layer Details

### 1. Core Layer

The core layer contains fundamental utilities and types used throughout the application.

#### Constants (`constants.dart`)
Centralized storage for all hardcoded values:
- Storage keys
- Default values
- Health milestones
- Craving techniques
- Achievement categories
- Time durations
- Animation durations

#### Exceptions (`exceptions.dart`)
Hierarchy of custom exception types:
- `AppException` - Base exception
- `StorageException` - Storage failures
- `ParseException` - JSON parsing errors
- `ValidationException` - Data validation errors
- `NotFoundException` - Missing resources
- `StateException` - Invalid state
- And more...

#### Result (`result.dart`)
Functional error handling pattern:
```dart
Result<T> = Success<T> | Failure
```

Provides:
- Explicit success/failure representation
- Pattern matching
- Transformation methods
- Error handling utilities

### 2. Models Layer

Immutable, type-safe data models that represent the domain entities.

#### Design Principles
- **Immutability**: All models are immutable with `@immutable` annotation
- **Type Safety**: No `Map<String, dynamic>` in public APIs
- **Serialization**: `fromJson` and `toJson` methods
- **Value Semantics**: Proper `==` and `hashCode` implementations
- **Copyability**: `copyWith` methods for creating modified copies
- **Documentation**: Comprehensive dartdoc comments

#### Key Models

**UserProfile**
```dart
@immutable
class UserProfile {
  final String name;
  final String email;
  final DateTime joinDate;
  final DateTime? quitDate;
  final String? profileImage;
  final int smokingStartAge;
  final int cigarettesPerDay;
  final double costPerPack;
  final int cigarettesPerPack;
}
```

**SmokingEntry**
Represents a single smoking event with timestamp, count, and context (trigger, mood, location).

**CravingEntry**
Tracks craving episodes with intensity, management technique, duration, and success status.

**Achievement**
Represents unlockable achievements with progress tracking and unlock dates.

**AppSettings**
User preferences including language, notifications, theme, and other settings.

### 3. Service Layer

The service layer handles business logic and data persistence.

#### TypedDataService

The new type-safe service that uses models instead of raw maps.

**Features:**
- Singleton pattern for global access
- Async initialization
- Type-safe CRUD operations
- Error handling with try-catch
- Default data generation
- Data export functionality

**Methods by Category:**

**User Profile**
```dart
Future<UserProfile> getUserProfile()
Future<void> saveUserProfile(UserProfile profile)
Future<void> updateUserProfile({...})
```

**Quit Date**
```dart
Future<DateTime?> getQuitDate()
Future<void> setQuitDate(DateTime date)
Future<Duration?> getTimeSinceQuit()
```

**Smoking Data**
```dart
Future<List<SmokingEntry>> getSmokingData()
Future<void> saveSmokingData(List<SmokingEntry> data)
Future<void> addSmokingEntry(SmokingEntry entry)
Future<void> deleteSmokingEntry(int id)
```

**Craving History**
```dart
Future<List<CravingEntry>> getCravingHistory()
Future<void> saveCravingHistory(List<CravingEntry> history)
Future<void> addCravingEntry(CravingEntry entry)
```

**Achievements**
```dart
Future<List<Achievement>> getAchievements()
Future<void> saveAchievements(List<Achievement> achievements)
```

**Settings**
```dart
Future<AppSettings> getSettings()
Future<void> saveSettings(AppSettings settings)
Future<void> updateSettings({...})
```

**Utility**
```dart
Future<void> clearAllData()
Future<Map<String, dynamic>> exportData()
```

### 4. Presentation Layer

The UI layer built with Flutter widgets.

#### Screen Structure

Each major screen follows this pattern:
```
screen_name/
├── screen_name.dart          # Main screen StatefulWidget
└── widgets/                  # Screen-specific widgets
    ├── widget_one.dart
    ├── widget_two.dart
    └── ...
```

#### Key Screens

**Dashboard Home** (`/dashboard-home`)
- Welcome card with current streak
- Today's smoking count
- Health metrics (money saved, time gained)
- Weekly progress chart
- Quick access to craving techniques
- Achievement badges

**Craving Management** (`/craving-management`)
- Craving intensity slider
- Countdown timer (10 minutes)
- Six management techniques:
  - 4-7-8 breathing
  - Quick walk
  - Memory game
  - Call a friend
  - Guided meditation
  - Stretching exercises
- Emergency contacts
- Craving history

**Progress Analytics** (`/progress-analytics`)
- Consumption chart with fl_chart
- Date range selector
- Category filters
- Scrollable insights
- Detailed statistics

**Quit Timer** (`/quit-timer`)
- Timer since quit date
- 8 health milestones:
  - 20 minutes
  - 1 hour
  - 24 hours
  - 48 hours
  - 72 hours
  - 1 week
  - 1 month
  - 3 months
- Share achievements
- Emergency support

**Settings Profile** (`/settings-profile`)
- Edit user profile
- Language selector
- Notification settings
- Privacy settings
- Export data (JSON/CSV)
- App information

**Splash Screen** (`/splash-screen`)
- Animated breathing logo
- Loading progress bar
- Offline indicator
- Initialization simulation

### 5. Theme Layer

Material Design 3 theme implementation with:

**Color Palette**
- Primary: `#2E7D5A` (Deep forest green)
- Secondary: `#F4F7F5` (Soft sage)
- Accent: `#E8B86D` (Warm gold)
- Error: `#C5524A` (Muted red)
- Success: `#4A8B6B` (Harmonious green)

**Typography**
- Font family: Inter (via Google Fonts)
- Responsive sizing with Sizer package
- Fixed text scale factor (1.0)

**Design Philosophy**
- Therapeutic Minimalism
- Calm Authority
- Medical credibility
- Full dark mode support

## Data Flow

### Reading Data

```
┌─────────────┐
│   Widget    │
└──────┬──────┘
       │ 1. Request data
       ▼
┌─────────────────┐
│ TypedDataService│
└──────┬──────────┘
       │ 2. Read from storage
       ▼
┌─────────────────┐
│SharedPreferences│
└──────┬──────────┘
       │ 3. Return JSON
       ▼
┌─────────────────┐
│ Parse to Model  │
└──────┬──────────┘
       │ 4. Return typed model
       ▼
┌─────────────┐
│   Widget    │
└─────────────┘
```

### Writing Data

```
┌─────────────┐
│   Widget    │
└──────┬──────┘
       │ 1. Create/update model
       ▼
┌─────────────────┐
│ TypedDataService│
└──────┬──────────┘
       │ 2. Serialize to JSON
       ▼
┌─────────────────┐
│SharedPreferences│
└──────┬──────────┘
       │ 3. Persist to disk
       ▼
┌─────────────┐
│   Widget    │
└─────────────┘
```

## State Management

Currently using **StatefulWidget** with local state management.

### Future State Management Options

**Provider**
- Pros: Simple, officially recommended
- Cons: Requires context, boilerplate

**Riverpod**
- Pros: Type-safe, no context needed, testable
- Cons: Learning curve

**Bloc**
- Pros: Explicit state transitions, testable, scalable
- Cons: More boilerplate, steeper learning curve

## Error Handling Strategy

### Three Levels of Error Handling

#### 1. Local Try-Catch
For immediate error handling:
```dart
try {
  final profile = await service.getUserProfile();
  setState(() => _profile = profile);
} on StorageException catch (e) {
  _showError('Failed to load profile: ${e.message}');
} on ParseException catch (e) {
  _showError('Invalid data format');
}
```

#### 2. Result Type
For functional error handling:
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

result.when(
  success: (profile) => updateUI(profile),
  failure: (error) => showError(error.message),
);
```

#### 3. Global Error Handler
For unhandled errors:
```dart
ErrorWidget.builder = (FlutterErrorDetails details) {
  return CustomErrorWidget(errorDetails: details);
};
```

## Testing Strategy

### Unit Tests
- Models: Serialization, equality, copyWith
- Services: CRUD operations, error handling
- Utilities: Helper functions, extensions

### Widget Tests
- Individual widgets
- Screen components
- User interactions

### Integration Tests
- End-to-end flows
- Navigation
- Data persistence

### Test Coverage Goal
- Minimum: 70%
- Target: 85%

## Performance Considerations

### Optimization Techniques

1. **Const Constructors**
   - Use `const` for immutable widgets
   - Reduces rebuild overhead

2. **ListView.builder**
   - Lazy loading for large lists
   - Only builds visible items

3. **Computed Properties**
   - Cache expensive calculations
   - Avoid redundant computations

4. **Image Caching**
   - Use CachedNetworkImage
   - Reduce network requests

5. **Debouncing**
   - Debounce text input
   - Reduce unnecessary operations

## Security Considerations

### Data Privacy
- All data stored locally
- No server communication
- No tracking or analytics by default

### Data Protection
- SharedPreferences encryption (future)
- Biometric authentication (future)
- Secure data export

## Accessibility

### Features
- Semantic labels on all interactive elements
- Screen reader support
- High contrast mode support
- Configurable text sizes (future)
- Voice input support (future)

## Localization

### Current Support
- Spanish (default)

### Planned Support
- English
- French
- German
- Portuguese

### Implementation
- Use Flutter's intl package
- Extract all strings to localization files
- Support right-to-left languages

## Deployment

### Platforms
- Android (primary)
- iOS (secondary)
- Web (future)

### Build Variants
- Development
- Staging
- Production

### CI/CD
- GitHub Actions (planned)
- Automated testing
- Automated builds
- Version management

## Future Enhancements

### Short-term (1-3 months)
1. Migrate all screens to TypedDataService
2. Implement comprehensive testing
3. Add state management (Provider/Riverpod)
4. Improve error handling UI
5. Add data backup/restore

### Medium-term (3-6 months)
1. Cloud sync (optional)
2. Social features (community support)
3. Advanced analytics
4. Gamification enhancements
5. Push notifications

### Long-term (6-12 months)
1. Health kit integration
2. Wearable device support
3. AI-powered insights
4. Professional counseling integration
5. Multi-language support

## Contributing

### Code Style
- Follow Flutter/Dart style guide
- Use dartfmt for formatting
- Run flutter analyze before committing
- Write tests for new features

### Pull Request Process
1. Create feature branch
2. Implement changes
3. Add/update tests
4. Update documentation
5. Run all checks
6. Submit PR with clear description

## Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

### Packages Used
- `sizer` - Responsive design
- `google_fonts` - Typography
- `shared_preferences` - Local storage
- `fl_chart` - Charts and graphs
- `flutter_svg` - SVG support
- `cached_network_image` - Image caching

## Conclusion

SmokeTracker follows modern Flutter/Dart best practices with a focus on:
- **Type Safety**: Compile-time error detection
- **Immutability**: Predictable state management
- **Clean Architecture**: Clear separation of concerns
- **Error Handling**: Explicit error types and patterns
- **Testing**: Comprehensive test coverage
- **Documentation**: Self-documenting code
- **Performance**: Optimized rendering and data handling
- **Accessibility**: Inclusive design
- **Maintainability**: Easy to understand and extend

The architecture provides a solid foundation for current functionality while being flexible enough to accommodate future enhancements.
