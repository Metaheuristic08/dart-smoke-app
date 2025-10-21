import 'package:flutter/foundation.dart';

/// Represents a craving episode and how it was managed.
/// 
/// This model tracks when cravings occur, their intensity, the technique
/// used to manage them, and whether the management was successful.
@immutable
class CravingEntry {
  /// Unique identifier for this craving entry
  final int id;

  /// Timestamp when the craving started
  final DateTime timestamp;

  /// Intensity of the craving on a scale (typically 1-10)
  final int intensity;

  /// Technique used to manage the craving (e.g., 'breathing', 'distraction')
  final String technique;

  /// Duration of the craving in minutes
  final int durationMinutes;

  /// Whether the craving was successfully managed without smoking
  final bool wasSuccessful;

  /// Optional trigger that caused the craving
  final String? trigger;

  /// Optional notes about the craving and management
  final String? notes;

  const CravingEntry({
    required this.id,
    required this.timestamp,
    required this.intensity,
    required this.technique,
    required this.durationMinutes,
    required this.wasSuccessful,
    this.trigger,
    this.notes,
  });

  /// Creates a [CravingEntry] from a JSON map.
  factory CravingEntry.fromJson(Map<String, dynamic> json) {
    return CravingEntry(
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      intensity: json['intensity'] as int,
      technique: json['technique'] as String,
      durationMinutes: json['durationMinutes'] as int,
      wasSuccessful: json['wasSuccessful'] as bool,
      trigger: json['trigger'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Converts this [CravingEntry] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'intensity': intensity,
      'technique': technique,
      'durationMinutes': durationMinutes,
      'wasSuccessful': wasSuccessful,
      if (trigger != null) 'trigger': trigger,
      if (notes != null) 'notes': notes,
    };
  }

  /// Creates a copy of this [CravingEntry] with the given fields replaced.
  CravingEntry copyWith({
    int? id,
    DateTime? timestamp,
    int? intensity,
    String? technique,
    int? durationMinutes,
    bool? wasSuccessful,
    String? trigger,
    String? notes,
  }) {
    return CravingEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      intensity: intensity ?? this.intensity,
      technique: technique ?? this.technique,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      wasSuccessful: wasSuccessful ?? this.wasSuccessful,
      trigger: trigger ?? this.trigger,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CravingEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.intensity == intensity &&
        other.technique == technique &&
        other.durationMinutes == durationMinutes &&
        other.wasSuccessful == wasSuccessful &&
        other.trigger == trigger &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      timestamp,
      intensity,
      technique,
      durationMinutes,
      wasSuccessful,
      trigger,
      notes,
    );
  }

  @override
  String toString() {
    return 'CravingEntry(id: $id, timestamp: $timestamp, intensity: $intensity, technique: $technique, durationMinutes: $durationMinutes, wasSuccessful: $wasSuccessful, trigger: $trigger, notes: $notes)';
  }
}
