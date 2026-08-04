import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../constants/app_constants.dart';

class HapticService {
  HapticService._();

  static bool get _enabled {
    try {
      final box = Hive.box(AppConstants.settingsBox);
      return box.get('haptics_enabled', defaultValue: true) as bool;
    } catch (_) {
      return true;
    }
  }

  /// Light tap — used for navigation, toggle switches
  static Future<void> light() async {
    if (_enabled) await HapticFeedback.lightImpact();
  }

  /// Medium impact — used for attendance card check/uncheck
  static Future<void> medium() async {
    if (_enabled) await HapticFeedback.mediumImpact();
  }

  /// Heavy impact — used for cycle rollover confirmation
  static Future<void> heavy() async {
    if (_enabled) await HapticFeedback.heavyImpact();
  }

  /// Selection click — used for color picker, chip selection
  static Future<void> selection() async {
    if (_enabled) await HapticFeedback.selectionClick();
  }
}
