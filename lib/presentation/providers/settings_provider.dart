import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';

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
  SettingsNotifier()
      : super(const SettingsState(
          currencySymbol: '৳',
          hapticsEnabled: true,
        )) {
    _loadSettings();
  }

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
    // Clear all boxes
    await Hive.box(AppConstants.studentsBox).clear();
    await Hive.box(AppConstants.attendanceBox).clear();
    await Hive.box(AppConstants.cyclesBox).clear();
    await _box.clear();
    _loadSettings();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
