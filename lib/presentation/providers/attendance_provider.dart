import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/attendance_log.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../core/haptics/haptic_service.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository();
});

/// Family provider: one AttendanceNotifier per student ID
final attendanceProvider =
    StateNotifierProvider.family<AttendanceNotifier, AttendanceLog?, String>(
  (ref, studentId) => AttendanceNotifier(
    studentId,
    ref.watch(attendanceRepositoryProvider),
  ),
);

class AttendanceNotifier extends StateNotifier<AttendanceLog?> {
  AttendanceNotifier(this.studentId, this._repo) : super(null) {
    _load();
  }

  final String studentId;
  final AttendanceRepository _repo;

  void _load() {
    state = _repo.getLog(studentId);
  }

  Future<void> toggleSlot(int slotIndex, {DateTime? selectedDate}) async {
    // 1. Native haptic feedback
    await HapticService.medium();

    // 2. Persist and update state
    final updated = await _repo.toggleSlot(studentId, slotIndex, selectedDate: selectedDate);
    state = updated;
  }

  List<DateTime> get attendedDates => _repo.getAttendedDates(studentId);

  void reload() => _load();
}
