/// Application-wide constants for the SmokeTracker app.
/// 
/// This file contains all hardcoded values used throughout the application,
/// making them easy to maintain and modify in one central location.
library constants;

/// SharedPreferences storage keys
class StorageKeys {
  StorageKeys._();

  static const String smokingData = 'smoking_data';
  static const String userProfile = 'user_profile';
  static const String appSettings = 'app_settings';
  static const String achievements = 'achievements';
  static const String cravingHistory = 'craving_history';
  static const String quitDate = 'quit_date';
}

/// Default user profile values
class DefaultUserProfile {
  DefaultUserProfile._();

  static const String name = 'María';
  static const String email = 'carlos.rodriguez@email.com';
  static const int smokingStartAge = 18;
  static const int cigarettesPerDay = 20;
  static const double costPerPack = 5.50;
  static const int cigarettesPerPack = 20;
  static const String defaultProfileImage =
      'https://images.unsplash.com/photo-1494790108755-2616b612b17c?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150';
}

/// Health milestone thresholds
class HealthMilestones {
  HealthMilestones._();

  static const int twentyMinutes = 20;
  static const int oneHour = 60;
  static const int twentyFourHours = 1440;
  static const int fortyEightHours = 2880;
  static const int seventyTwoHours = 4320;
  static const int oneWeek = 10080;
  static const int oneMonth = 43200;
  static const int threeMonths = 129600;
}

/// Craving management technique identifiers
class CravingTechniques {
  CravingTechniques._();

  static const String breathing478 = 'breathing_4_7_8';
  static const String quickWalk = 'physical_walk';
  static const String memoryGame = 'distraction_game';
  static const String callFriend = 'social_call';
  static const String guidedMeditation = 'mindfulness_meditation';
  static const String stretchingExercises = 'physical_stretching';
}

/// Achievement categories
class AchievementCategories {
  AchievementCategories._();

  static const String time = 'time';
  static const String health = 'health';
  static const String savings = 'savings';
  static const String social = 'social';
  static const String milestones = 'milestones';
}

/// Achievement levels
class AchievementLevels {
  AchievementLevels._();

  static const String bronze = 'bronze';
  static const String silver = 'silver';
  static const String gold = 'gold';
  static const String platinum = 'platinum';
}

/// Application theme modes
class ThemeModes {
  ThemeModes._();

  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';
}

/// Supported languages
class SupportedLanguages {
  SupportedLanguages._();

  static const String english = 'en';
  static const String spanish = 'es';
  static const String french = 'fr';
  static const String german = 'de';
}

/// Common trigger types for smoking/cravings
class TriggerTypes {
  TriggerTypes._();

  static const String stress = 'stress';
  static const String social = 'social';
  static const String boredom = 'boredom';
  static const String alcohol = 'alcohol';
  static const String coffee = 'coffee';
  static const String afterMeal = 'after_meal';
  static const String morning = 'morning';
  static const String work = 'work';
}

/// Mood types
class MoodTypes {
  MoodTypes._();

  static const String anxious = 'anxious';
  static const String happy = 'happy';
  static const String angry = 'angry';
  static const String sad = 'sad';
  static const String calm = 'calm';
  static const String excited = 'excited';
  static const String frustrated = 'frustrated';
  static const String neutral = 'neutral';
}

/// Location types
class LocationTypes {
  LocationTypes._();

  static const String home = 'home';
  static const String work = 'work';
  static const String car = 'car';
  static const String outdoors = 'outdoors';
  static const String bar = 'bar';
  static const String restaurant = 'restaurant';
  static const String other = 'other';
}

/// Currency symbols
class CurrencySymbols {
  CurrencySymbols._();

  static const String euro = '€';
  static const String dollar = '\$';
  static const String pound = '£';
  static const String yen = '¥';
}

/// Time duration constants (in minutes)
class TimeDurations {
  TimeDurations._();

  static const int cravingTimerDefault = 10;
  static const int breathingExercise = 2;
  static const int quickWalk = 5;
  static const int guidedMeditation = 10;
  static const int stretchingExercises = 5;
}

/// App-wide animation durations (in milliseconds)
class AnimationDurations {
  AnimationDurations._();

  static const int fast = 200;
  static const int normal = 300;
  static const int slow = 500;
  static const int breathingCycle = 3000;
}

/// Export file name templates
class ExportFileNames {
  ExportFileNames._();

  static const String jsonTemplate = 'smoketracker_data';
  static const String csvTemplate = 'smoketracker_data';
}
