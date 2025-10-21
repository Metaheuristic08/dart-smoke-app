import 'package:flutter/foundation.dart';

/// Represents a user's profile information including smoking habits and quit journey details.
/// 
/// This model contains essential user data for tracking smoking cessation progress
/// and personalizing the app experience.
@immutable
class UserProfile {
  /// User's display name
  final String name;

  /// User's email address
  final String email;

  /// Date when the user joined the app
  final DateTime joinDate;

  /// Date when the user quit smoking (if applicable)
  final DateTime? quitDate;

  /// URL or path to the user's profile image
  final String? profileImage;

  /// Age when the user started smoking
  final int smokingStartAge;

  /// Average number of cigarettes smoked per day before quitting
  final int cigarettesPerDay;

  /// Cost per pack of cigarettes in local currency
  final double costPerPack;

  /// Number of cigarettes in a pack
  final int cigarettesPerPack;

  const UserProfile({
    required this.name,
    required this.email,
    required this.joinDate,
    this.quitDate,
    this.profileImage,
    required this.smokingStartAge,
    required this.cigarettesPerDay,
    required this.costPerPack,
    required this.cigarettesPerPack,
  });

  /// Creates a [UserProfile] from a JSON map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      email: json['email'] as String,
      joinDate: DateTime.parse(json['joinDate'] as String),
      quitDate: json['quitDate'] != null
          ? DateTime.parse(json['quitDate'] as String)
          : null,
      profileImage: json['profileImage'] as String?,
      smokingStartAge: json['smokingStartAge'] as int,
      cigarettesPerDay: json['cigarettesPerDay'] as int,
      costPerPack: (json['costPerPack'] as num).toDouble(),
      cigarettesPerPack: json['cigarettesPerPack'] as int,
    );
  }

  /// Converts this [UserProfile] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'joinDate': joinDate.toIso8601String(),
      'quitDate': quitDate?.toIso8601String(),
      'profileImage': profileImage,
      'smokingStartAge': smokingStartAge,
      'cigarettesPerDay': cigarettesPerDay,
      'costPerPack': costPerPack,
      'cigarettesPerPack': cigarettesPerPack,
    };
  }

  /// Creates a copy of this [UserProfile] with the given fields replaced.
  UserProfile copyWith({
    String? name,
    String? email,
    DateTime? joinDate,
    DateTime? quitDate,
    String? profileImage,
    int? smokingStartAge,
    int? cigarettesPerDay,
    double? costPerPack,
    int? cigarettesPerPack,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      joinDate: joinDate ?? this.joinDate,
      quitDate: quitDate ?? this.quitDate,
      profileImage: profileImage ?? this.profileImage,
      smokingStartAge: smokingStartAge ?? this.smokingStartAge,
      cigarettesPerDay: cigarettesPerDay ?? this.cigarettesPerDay,
      costPerPack: costPerPack ?? this.costPerPack,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
    );
  }

  /// Creates a default [UserProfile] with placeholder values.
  factory UserProfile.defaultProfile() {
    return UserProfile(
      name: 'María',
      email: 'carlos.rodriguez@email.com',
      joinDate: DateTime.now().subtract(const Duration(days: 30)),
      quitDate: DateTime.now().subtract(const Duration(days: 3)),
      profileImage:
          'https://images.unsplash.com/photo-1494790108755-2616b612b17c?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&h=150',
      smokingStartAge: 18,
      cigarettesPerDay: 20,
      costPerPack: 5.50,
      cigarettesPerPack: 20,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.name == name &&
        other.email == email &&
        other.joinDate == joinDate &&
        other.quitDate == quitDate &&
        other.profileImage == profileImage &&
        other.smokingStartAge == smokingStartAge &&
        other.cigarettesPerDay == cigarettesPerDay &&
        other.costPerPack == costPerPack &&
        other.cigarettesPerPack == cigarettesPerPack;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      email,
      joinDate,
      quitDate,
      profileImage,
      smokingStartAge,
      cigarettesPerDay,
      costPerPack,
      cigarettesPerPack,
    );
  }

  @override
  String toString() {
    return 'UserProfile(name: $name, email: $email, joinDate: $joinDate, quitDate: $quitDate, profileImage: $profileImage, smokingStartAge: $smokingStartAge, cigarettesPerDay: $cigarettesPerDay, costPerPack: $costPerPack, cigarettesPerPack: $cigarettesPerPack)';
  }
}
