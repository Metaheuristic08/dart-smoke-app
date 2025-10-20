import 'package:flutter/foundation.dart';

/// Represents a single smoking event/entry in the user's history.
/// 
/// This model tracks individual cigarette consumption instances, including
/// when they occurred, associated triggers, mood, and location context.
@immutable
class SmokingEntry {
  /// Unique identifier for this entry
  final int id;

  /// Timestamp when the smoking occurred
  final DateTime timestamp;

  /// Number of cigarettes smoked in this entry (usually 1)
  final int count;

  /// Optional trigger that led to smoking (e.g., 'stress', 'social', 'boredom')
  final String? trigger;

  /// Optional mood at the time of smoking (e.g., 'anxious', 'happy', 'angry')
  final String? mood;

  /// Optional location where smoking occurred (e.g., 'home', 'work', 'car')
  final String? location;

  /// Optional notes about this smoking instance
  final String? notes;

  const SmokingEntry({
    required this.id,
    required this.timestamp,
    this.count = 1,
    this.trigger,
    this.mood,
    this.location,
    this.notes,
  });

  /// Creates a [SmokingEntry] from a JSON map.
  factory SmokingEntry.fromJson(Map<String, dynamic> json) {
    return SmokingEntry(
      id: json['id'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      count: json['count'] as int? ?? 1,
      trigger: json['trigger'] as String?,
      mood: json['mood'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Converts this [SmokingEntry] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'count': count,
      if (trigger != null) 'trigger': trigger,
      if (mood != null) 'mood': mood,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
    };
  }

  /// Creates a copy of this [SmokingEntry] with the given fields replaced.
  SmokingEntry copyWith({
    int? id,
    DateTime? timestamp,
    int? count,
    String? trigger,
    String? mood,
    String? location,
    String? notes,
  }) {
    return SmokingEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      count: count ?? this.count,
      trigger: trigger ?? this.trigger,
      mood: mood ?? this.mood,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SmokingEntry &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.count == count &&
        other.trigger == trigger &&
        other.mood == mood &&
        other.location == location &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      timestamp,
      count,
      trigger,
      mood,
      location,
      notes,
    );
  }

  @override
  String toString() {
    return 'SmokingEntry(id: $id, timestamp: $timestamp, count: $count, trigger: $trigger, mood: $mood, location: $location, notes: $notes)';
  }
}
