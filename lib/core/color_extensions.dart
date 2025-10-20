import 'package:flutter/material.dart';

extension ColorWithValues on Color {
  Color withValues({double? alpha}) {
    // alpha expected 0.0 to 1.0
    if (alpha != null) {
      final clamped = alpha.clamp(0.0, 1.0);
      return withAlpha((clamped * 255).round());
    }
    return this;
  }
}
