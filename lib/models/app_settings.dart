import 'package:flutter/foundation.dart';

/// Represents the application settings and user preferences.
/// 
/// This model contains all configurable options that customize the user
/// experience including notifications, language, and display preferences.
@immutable
class AppSettings {
  /// Selected language code (e.g., 'en', 'es', 'fr')
  final String language;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// Whether reminder notifications are enabled
  final bool remindersEnabled;

  /// Time for daily reminder (in 24-hour format, e.g., '09:00')
  final String? reminderTime;

  /// Whether motivational quotes are enabled
  final bool motivationalQuotesEnabled;

  /// Whether data analytics/tracking is enabled
  final bool analyticsEnabled;

  /// Theme mode preference ('light', 'dark', 'system')
  final String themeMode;

  /// Whether haptic feedback is enabled
  final bool hapticFeedbackEnabled;

  /// Whether sound effects are enabled
  final bool soundEffectsEnabled;

  /// Currency symbol for cost calculations
  final String currency;

  const AppSettings({
    this.language = 'es',
    this.notificationsEnabled = true,
    this.remindersEnabled = true,
    this.reminderTime,
    this.motivationalQuotesEnabled = true,
    this.analyticsEnabled = false,
    this.themeMode = 'light',
    this.hapticFeedbackEnabled = true,
    this.soundEffectsEnabled = true,
    this.currency = '€',
  });

  /// Creates [AppSettings] from a JSON map.
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      language: json['language'] as String? ?? 'es',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
      reminderTime: json['reminderTime'] as String?,
      motivationalQuotesEnabled:
          json['motivationalQuotesEnabled'] as bool? ?? true,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? false,
      themeMode: json['themeMode'] as String? ?? 'light',
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool? ?? true,
      soundEffectsEnabled: json['soundEffectsEnabled'] as bool? ?? true,
      currency: json['currency'] as String? ?? '€',
    );
  }

  /// Converts this [AppSettings] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'remindersEnabled': remindersEnabled,
      if (reminderTime != null) 'reminderTime': reminderTime,
      'motivationalQuotesEnabled': motivationalQuotesEnabled,
      'analyticsEnabled': analyticsEnabled,
      'themeMode': themeMode,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'soundEffectsEnabled': soundEffectsEnabled,
      'currency': currency,
    };
  }

  /// Creates a copy of this [AppSettings] with the given fields replaced.
  AppSettings copyWith({
    String? language,
    bool? notificationsEnabled,
    bool? remindersEnabled,
    String? reminderTime,
    bool? motivationalQuotesEnabled,
    bool? analyticsEnabled,
    String? themeMode,
    bool? hapticFeedbackEnabled,
    bool? soundEffectsEnabled,
    String? currency,
  }) {
    return AppSettings(
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      motivationalQuotesEnabled:
          motivationalQuotesEnabled ?? this.motivationalQuotesEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      themeMode: themeMode ?? this.themeMode,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      currency: currency ?? this.currency,
    );
  }

  /// Creates default [AppSettings] with sensible defaults.
  factory AppSettings.defaultSettings() {
    return const AppSettings();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings &&
        other.language == language &&
        other.notificationsEnabled == notificationsEnabled &&
        other.remindersEnabled == remindersEnabled &&
        other.reminderTime == reminderTime &&
        other.motivationalQuotesEnabled == motivationalQuotesEnabled &&
        other.analyticsEnabled == analyticsEnabled &&
        other.themeMode == themeMode &&
        other.hapticFeedbackEnabled == hapticFeedbackEnabled &&
        other.soundEffectsEnabled == soundEffectsEnabled &&
        other.currency == currency;
  }

  @override
  int get hashCode {
    return Object.hash(
      language,
      notificationsEnabled,
      remindersEnabled,
      reminderTime,
      motivationalQuotesEnabled,
      analyticsEnabled,
      themeMode,
      hapticFeedbackEnabled,
      soundEffectsEnabled,
      currency,
    );
  }

  @override
  String toString() {
    return 'AppSettings(language: $language, notificationsEnabled: $notificationsEnabled, remindersEnabled: $remindersEnabled, reminderTime: $reminderTime, motivationalQuotesEnabled: $motivationalQuotesEnabled, analyticsEnabled: $analyticsEnabled, themeMode: $themeMode, hapticFeedbackEnabled: $hapticFeedbackEnabled, soundEffectsEnabled: $soundEffectsEnabled, currency: $currency)';
  }
}
