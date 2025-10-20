import 'package:flutter/foundation.dart';

/// Represents an achievement or milestone in the user's quit smoking journey.
/// 
/// Achievements provide positive reinforcement and track progress markers
/// that motivate users to continue their smoke-free journey.
@immutable
class Achievement {
  /// Unique identifier for this achievement
  final String id;

  /// Display name of the achievement
  final String title;

  /// Detailed description of what this achievement represents
  final String description;

  /// Icon name or identifier for visual representation
  final String icon;

  /// Whether this achievement has been unlocked/earned
  final bool isUnlocked;

  /// Date when the achievement was unlocked (null if not yet unlocked)
  final DateTime? unlockedDate;

  /// Category of the achievement (e.g., 'time', 'health', 'savings')
  final String category;

  /// Achievement level or rarity (e.g., 'bronze', 'silver', 'gold')
  final String? level;

  /// Progress towards unlocking this achievement (0.0 to 1.0)
  final double progress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.unlockedDate,
    required this.category,
    this.level,
    this.progress = 0.0,
  });

  /// Creates an [Achievement] from a JSON map.
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool,
      unlockedDate: json['unlockedDate'] != null
          ? DateTime.parse(json['unlockedDate'] as String)
          : null,
      category: json['category'] as String,
      level: json['level'] as String?,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts this [Achievement] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      if (unlockedDate != null) 'unlockedDate': unlockedDate!.toIso8601String(),
      'category': category,
      if (level != null) 'level': level,
      'progress': progress,
    };
  }

  /// Creates a copy of this [Achievement] with the given fields replaced.
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    DateTime? unlockedDate,
    String? category,
    String? level,
    double? progress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      category: category ?? this.category,
      level: level ?? this.level,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Achievement &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.icon == icon &&
        other.isUnlocked == isUnlocked &&
        other.unlockedDate == unlockedDate &&
        other.category == category &&
        other.level == level &&
        other.progress == progress;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      icon,
      isUnlocked,
      unlockedDate,
      category,
      level,
      progress,
    );
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, icon: $icon, isUnlocked: $isUnlocked, unlockedDate: $unlockedDate, category: $category, level: $level, progress: $progress)';
  }
}
