import 'package:hive_flutter/hive_flutter.dart';
import '../models/attendance_log.dart';
import '../../core/constants/app_constants.dart';

class AttendanceRepository {
  Box<AttendanceLog> get _box =>
      Hive.box<AttendanceLog>(AppConstants.attendanceBox);

  AttendanceLog? getLog(String studentId) => _box.get(studentId);

  Future<AttendanceLog> toggleSlot(String studentId, int slotIndex, {DateTime? selectedDate}) async {
    final log = _box.get(studentId);
    if (log == null) throw Exception('No attendance log for student $studentId');

    final states = List<bool>.from(log.slotStates);
    final timestamps = List<String>.from(log.timestamps);
    final now = (selectedDate ?? DateTime.now()).toIso8601String();

    if (states[slotIndex]) {
      // Un-check: remove the last timestamp associated with this slot.
      // We track slot index by appending "|slotIndex" to each timestamp string.
      final idxToRemove = timestamps.lastIndexWhere((t) => t.endsWith('|$slotIndex'));
      if (idxToRemove != -1) timestamps.removeAt(idxToRemove);
      states[slotIndex] = false;
    } else {
      // Check: record timestamp with slot index suffix
      timestamps.add('$now|$slotIndex');
      states[slotIndex] = true;
    }

    final updated = log.copyWith(timestamps: timestamps, slotStates: states);
    await _box.put(studentId, updated);
    return updated;
  }

  Future<void> reset(String studentId, String newCycleId, int targetClasses) async {
    final fresh = AttendanceLog(
      studentId: studentId,
      cycleId: newCycleId,
      timestamps: [],
      slotStates: List.filled(targetClasses, false),
    );
    await _box.put(studentId, fresh);
  }

  /// Returns all attended DateTime objects (plain ISO, no slot suffix) for calendar
  List<DateTime> getAttendedDates(String studentId) {
    final log = _box.get(studentId);
    if (log == null) return [];
    return log.timestamps
        .map((t) => t.split('|').first) // strip slot index suffix
        .map((iso) => DateTime.parse(iso))
        .toList();
  }
}
