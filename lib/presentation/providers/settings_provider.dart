import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/student.dart';
import '../../data/models/attendance_log.dart';
import '../../data/models/billing_cycle.dart';
import 'student_provider.dart';
import 'cycle_provider.dart';

class SettingsState {
  final String currencySymbol;
  final bool hapticsEnabled;

  const SettingsState({
    required this.currencySymbol,
    required this.hapticsEnabled,
  });

  SettingsState copyWith({
    String? currencySymbol,
    bool? hapticsEnabled,
  }) {
    return SettingsState(
      currencySymbol: currencySymbol ?? this.currencySymbol,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._ref)
      : super(const SettingsState(
          currencySymbol: '৳',
          hapticsEnabled: true,
        )) {
    _loadSettings();
  }

  final Ref _ref;

  Box get _box => Hive.box(AppConstants.settingsBox);

  void _loadSettings() {
    final currency = _box.get('currency_symbol', defaultValue: '৳') as String;
    final haptics = _box.get('haptics_enabled', defaultValue: true) as bool;
    state = SettingsState(currencySymbol: currency, hapticsEnabled: haptics);
  }

  Future<void> setCurrencySymbol(String symbol) async {
    await _box.put('currency_symbol', symbol);
    state = state.copyWith(currencySymbol: symbol);
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await _box.put('haptics_enabled', enabled);
    state = state.copyWith(hapticsEnabled: enabled);
  }

  Future<void> resetAllData() async {
    // Clear typed Hive storage boxes cleanly
    await Hive.box<Student>(AppConstants.studentsBox).clear();
    await Hive.box<AttendanceLog>(AppConstants.attendanceBox).clear();
    await Hive.box<BillingCycle>(AppConstants.cyclesBox).clear();
    await _box.clear();

    // Reload settings defaults
    _loadSettings();

    // Reload all state notifiers & invalidate family providers immediately
    _ref.read(studentsProvider.notifier).load();
    _ref.read(allArchivedCyclesProvider.notifier).reload();
    _ref.invalidate(studentsProvider);
    _ref.invalidate(allArchivedCyclesProvider);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
