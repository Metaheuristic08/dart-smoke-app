import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../core/constants.dart';

/// A type-safe service for managing local data storage using SharedPreferences.
/// 
/// This service provides strongly-typed methods for storing and retrieving
/// user data, smoking history, cravings, achievements, and app settings.
/// All methods use proper data models instead of raw Map<String, dynamic>.
class TypedDataService {
  /// Singleton instance
  static final TypedDataService _instance = TypedDataService._internal();

  /// Factory constructor returns the singleton instance
  factory TypedDataService() => _instance;

  /// Private constructor for singleton pattern
  TypedDataService._internal();

  SharedPreferences? _prefs;

  /// Initialize the service by loading SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance, throws if not initialized
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError(
        'TypedDataService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  // ============================================================================
  // USER PROFILE MANAGEMENT
  // ============================================================================

  /// Retrieves the user profile from local storage.
  /// 
  /// Returns a default profile if none exists.
  Future<UserProfile> getUserProfile() async {
    await init();
    final String? profileJson = _preferences.getString(StorageKeys.userProfile);

    if (profileJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(profileJson);
        return UserProfile.fromJson(json);
      } catch (e) {
        debugPrint('Error parsing user profile: $e');
        // Return default on parse error
        return _createAndSaveDefaultProfile();
      }
    }

    return _createAndSaveDefaultProfile();
  }

  /// Creates and saves a default user profile
  Future<UserProfile> _createAndSaveDefaultProfile() async {
    final defaultProfile = UserProfile.defaultProfile();
    await saveUserProfile(defaultProfile);
    return defaultProfile;
  }

  /// Saves the user profile to local storage.
  Future<void> saveUserProfile(UserProfile profile) async {
    await init();
    final String json = jsonEncode(profile.toJson());
    await _preferences.setString(StorageKeys.userProfile, json);
  }

  /// Updates specific fields of the user profile.
  Future<void> updateUserProfile({
    String? name,
    String? email,
    DateTime? joinDate,
    DateTime? quitDate,
    String? profileImage,
    int? smokingStartAge,
    int? cigarettesPerDay,
    double? costPerPack,
    int? cigarettesPerPack,
  }) async {
    final currentProfile = await getUserProfile();
    final updatedProfile = currentProfile.copyWith(
      name: name,
      email: email,
      joinDate: joinDate,
      quitDate: quitDate,
      profileImage: profileImage,
      smokingStartAge: smokingStartAge,
      cigarettesPerDay: cigarettesPerDay,
      costPerPack: costPerPack,
      cigarettesPerPack: cigarettesPerPack,
    );
    await saveUserProfile(updatedProfile);
  }

  // ============================================================================
  // QUIT DATE MANAGEMENT
  // ============================================================================

  /// Gets the date when the user quit smoking.
  /// 
  /// Returns null if no quit date is set.
  Future<DateTime?> getQuitDate() async {
    await init();
    final String? quitDateStr = _preferences.getString(StorageKeys.quitDate);

    if (quitDateStr != null) {
      try {
        return DateTime.parse(quitDateStr);
      } catch (e) {
        debugPrint('Error parsing quit date: $e');
        return null;
      }
    }

    // Set default quit date (3 days ago for demo)
    final defaultQuitDate = DateTime.now().subtract(const Duration(days: 3));
    await setQuitDate(defaultQuitDate);
    return defaultQuitDate;
  }

  /// Sets the quit date.
  Future<void> setQuitDate(DateTime date) async {
    await init();
    await _preferences.setString(StorageKeys.quitDate, date.toIso8601String());
  }

  /// Calculates the duration since quitting.
  /// 
  /// Returns null if no quit date is set.
  Future<Duration?> getTimeSinceQuit() async {
    final quitDate = await getQuitDate();
    if (quitDate == null) return null;
    return DateTime.now().difference(quitDate);
  }

  // ============================================================================
  // SMOKING DATA MANAGEMENT
  // ============================================================================

  /// Retrieves all smoking entries from local storage.
  Future<List<SmokingEntry>> getSmokingData() async {
    await init();
    final String? dataJson = _preferences.getString(StorageKeys.smokingData);

    if (dataJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(dataJson);
        return decodedList
            .map((json) => SmokingEntry.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing smoking data: $e');
        return _createAndSaveDefaultSmokingData();
      }
    }

    return _createAndSaveDefaultSmokingData();
  }

  /// Creates and saves default smoking data for demo purposes
  Future<List<SmokingEntry>> _createAndSaveDefaultSmokingData() async {
    final defaultData = [
      SmokingEntry(
        id: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        count: 1,
        trigger: TriggerTypes.stress,
        mood: MoodTypes.anxious,
        location: LocationTypes.home,
        notes: 'Después de una reunión difícil',
      ),
      SmokingEntry(
        id: 2,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        count: 1,
        trigger: TriggerTypes.work,
        mood: MoodTypes.neutral,
        location: LocationTypes.work,
      ),
      SmokingEntry(
        id: 3,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        count: 1,
        trigger: TriggerTypes.social,
        mood: MoodTypes.happy,
        location: LocationTypes.bar,
        notes: 'Con compañeros de trabajo',
      ),
    ];

    await saveSmokingData(defaultData);
    return defaultData;
  }

  /// Saves smoking entries to local storage.
  Future<void> saveSmokingData(List<SmokingEntry> data) async {
    await init();
    final List<Map<String, dynamic>> jsonList =
        data.map((entry) => entry.toJson()).toList();
    final String json = jsonEncode(jsonList);
    await _preferences.setString(StorageKeys.smokingData, json);
  }

  /// Adds a new smoking entry.
  Future<void> addSmokingEntry(SmokingEntry entry) async {
    final currentData = await getSmokingData();
    
    // Generate new ID
    final newId = currentData.isEmpty
        ? 1
        : currentData.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newEntry = entry.copyWith(
      id: newId,
      timestamp: DateTime.now(),
    );
    
    currentData.insert(0, newEntry);
    await saveSmokingData(currentData);
  }

  /// Deletes a smoking entry by ID.
  Future<void> deleteSmokingEntry(int id) async {
    final currentData = await getSmokingData();
    currentData.removeWhere((entry) => entry.id == id);
    await saveSmokingData(currentData);
  }

  // ============================================================================
  // CRAVING HISTORY MANAGEMENT
  // ============================================================================

  /// Retrieves all craving entries from local storage.
  Future<List<CravingEntry>> getCravingHistory() async {
    await init();
    final String? historyJson =
        _preferences.getString(StorageKeys.cravingHistory);

    if (historyJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(historyJson);
        return decodedList
            .map((json) => CravingEntry.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing craving history: $e');
        return _createAndSaveDefaultCravingHistory();
      }
    }

    return _createAndSaveDefaultCravingHistory();
  }

  /// Creates and saves default craving history for demo purposes
  Future<List<CravingEntry>> _createAndSaveDefaultCravingHistory() async {
    final defaultHistory = [
      CravingEntry(
        id: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        intensity: 8,
        technique: CravingTechniques.breathing478,
        durationMinutes: 5,
        wasSuccessful: true,
        trigger: TriggerTypes.stress,
        notes: 'Ejercicio de respiración ayudó mucho',
      ),
      CravingEntry(
        id: 2,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        intensity: 6,
        technique: CravingTechniques.memoryGame,
        durationMinutes: 3,
        wasSuccessful: true,
        trigger: TriggerTypes.boredom,
      ),
    ];

    await saveCravingHistory(defaultHistory);
    return defaultHistory;
  }

  /// Saves craving history to local storage.
  Future<void> saveCravingHistory(List<CravingEntry> history) async {
    await init();
    final List<Map<String, dynamic>> jsonList =
        history.map((entry) => entry.toJson()).toList();
    final String json = jsonEncode(jsonList);
    await _preferences.setString(StorageKeys.cravingHistory, json);
  }

  /// Adds a new craving entry.
  Future<void> addCravingEntry(CravingEntry entry) async {
    final currentHistory = await getCravingHistory();
    
    // Generate new ID
    final newId = currentHistory.isEmpty
        ? 1
        : currentHistory.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newEntry = entry.copyWith(
      id: newId,
      timestamp: DateTime.now(),
    );
    
    currentHistory.insert(0, newEntry);
    await saveCravingHistory(currentHistory);
  }

  // ============================================================================
  // ACHIEVEMENTS MANAGEMENT
  // ============================================================================

  /// Retrieves all achievements from local storage.
  Future<List<Achievement>> getAchievements() async {
    await init();
    final String? achievementsJson =
        _preferences.getString(StorageKeys.achievements);

    if (achievementsJson != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(achievementsJson);
        return decodedList
            .map((json) => Achievement.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing achievements: $e');
        return _generateAndSaveAchievements();
      }
    }

    return _generateAndSaveAchievements();
  }

  /// Generates achievements based on quit date and progress
  Future<List<Achievement>> _generateAndSaveAchievements() async {
    final quitDate = await getQuitDate();
    if (quitDate == null) return [];

    final timeSinceQuit = DateTime.now().difference(quitDate);
    final daysSinceQuit = timeSinceQuit.inDays;

    final achievements = [
      Achievement(
        id: 'first_hour',
        title: 'Primera hora',
        description: '1 hora sin fumar',
        icon: 'timer',
        category: AchievementCategories.time,
        level: AchievementLevels.bronze,
        isUnlocked: daysSinceQuit >= 0,
        unlockedDate: quitDate.add(const Duration(hours: 1)),
        progress: daysSinceQuit >= 0 ? 1.0 : 0.0,
      ),
      Achievement(
        id: 'first_day',
        title: 'Primer día',
        description: '24 horas sin fumar',
        icon: 'flag',
        category: AchievementCategories.milestones,
        level: AchievementLevels.bronze,
        isUnlocked: daysSinceQuit >= 1,
        unlockedDate:
            daysSinceQuit >= 1 ? quitDate.add(const Duration(days: 1)) : null,
        progress: daysSinceQuit >= 1 ? 1.0 : daysSinceQuit / 1.0,
      ),
      Achievement(
        id: 'three_days',
        title: 'Tres días',
        description: '72 horas sin fumar - La nicotina se elimina',
        icon: 'favorite',
        category: AchievementCategories.health,
        level: AchievementLevels.silver,
        isUnlocked: daysSinceQuit >= 3,
        unlockedDate:
            daysSinceQuit >= 3 ? quitDate.add(const Duration(days: 3)) : null,
        progress: daysSinceQuit >= 3 ? 1.0 : daysSinceQuit / 3.0,
      ),
      Achievement(
        id: 'one_week',
        title: 'Una semana',
        description: '7 días sin fumar',
        icon: 'calendar_today',
        category: AchievementCategories.milestones,
        level: AchievementLevels.silver,
        isUnlocked: daysSinceQuit >= 7,
        unlockedDate:
            daysSinceQuit >= 7 ? quitDate.add(const Duration(days: 7)) : null,
        progress: daysSinceQuit >= 7 ? 1.0 : daysSinceQuit / 7.0,
      ),
      Achievement(
        id: 'money_saver',
        title: 'Ahorrador',
        description: 'Ahorraste más de €20',
        icon: 'savings',
        category: AchievementCategories.savings,
        level: AchievementLevels.gold,
        isUnlocked: daysSinceQuit >= 2,
        unlockedDate:
            daysSinceQuit >= 2 ? quitDate.add(const Duration(days: 2)) : null,
        progress: daysSinceQuit >= 2 ? 1.0 : daysSinceQuit / 2.0,
      ),
    ];

    await saveAchievements(achievements);
    return achievements;
  }

  /// Saves achievements to local storage.
  Future<void> saveAchievements(List<Achievement> achievements) async {
    await init();
    final List<Map<String, dynamic>> jsonList =
        achievements.map((achievement) => achievement.toJson()).toList();
    final String json = jsonEncode(jsonList);
    await _preferences.setString(StorageKeys.achievements, json);
  }

  // ============================================================================
  // APP SETTINGS MANAGEMENT
  // ============================================================================

  /// Retrieves app settings from local storage.
  Future<AppSettings> getSettings() async {
    await init();
    final String? settingsJson = _preferences.getString(StorageKeys.appSettings);

    if (settingsJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        return AppSettings.fromJson(json);
      } catch (e) {
        debugPrint('Error parsing settings: $e');
        return _createAndSaveDefaultSettings();
      }
    }

    return _createAndSaveDefaultSettings();
  }

  /// Creates and saves default settings
  Future<AppSettings> _createAndSaveDefaultSettings() async {
    final defaultSettings = AppSettings.defaultSettings();
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  /// Saves app settings to local storage.
  Future<void> saveSettings(AppSettings settings) async {
    await init();
    final String json = jsonEncode(settings.toJson());
    await _preferences.setString(StorageKeys.appSettings, json);
  }

  /// Updates a specific setting.
  Future<void> updateSettings({
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
  }) async {
    final currentSettings = await getSettings();
    final updatedSettings = currentSettings.copyWith(
      language: language,
      notificationsEnabled: notificationsEnabled,
      remindersEnabled: remindersEnabled,
      reminderTime: reminderTime,
      motivationalQuotesEnabled: motivationalQuotesEnabled,
      analyticsEnabled: analyticsEnabled,
      themeMode: themeMode,
      hapticFeedbackEnabled: hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled,
      currency: currency,
    );
    await saveSettings(updatedSettings);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clears all local data (useful for testing or reset functionality).
  Future<void> clearAllData() async {
    await init();
    await _preferences.clear();
  }

  /// Exports all data as a JSON map for backup purposes.
  Future<Map<String, dynamic>> exportData() async {
    final profile = await getUserProfile();
    final smokingData = await getSmokingData();
    final cravingHistory = await getCravingHistory();
    final achievements = await getAchievements();
    final settings = await getSettings();
    final quitDate = await getQuitDate();

    return {
      'exportDate': DateTime.now().toIso8601String(),
      'userProfile': profile.toJson(),
      'smokingData': smokingData.map((e) => e.toJson()).toList(),
      'cravingHistory': cravingHistory.map((e) => e.toJson()).toList(),
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'settings': settings.toJson(),
      'quitDate': quitDate?.toIso8601String(),
    };
  }
}
