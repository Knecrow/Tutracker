import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/billing_cycle.dart';
import '../models/student.dart';
import '../../core/constants/app_constants.dart';
import 'attendance_repository.dart';

class CycleRepository {
  Box<BillingCycle> get _cyclesBox =>
      Hive.box<BillingCycle>(AppConstants.cyclesBox);
  Box<Student> get _studentsBox =>
      Hive.box<Student>(AppConstants.studentsBox);

  final _attendanceRepo = AttendanceRepository();
  final _uuid = const Uuid();

  BillingCycle? getActiveCycle(String studentId) {
    try {
      return _cyclesBox.values
          .firstWhere((c) => c.studentId == studentId && c.isActive);
    } catch (_) {
      return null;
    }
  }

  List<BillingCycle> getArchivedCycles(String studentId) =>
      _cyclesBox.values
          .where((c) => c.studentId == studentId && c.isArchived)
          .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

  List<BillingCycle> getAllArchivedCycles() =>
      _cyclesBox.values.where((c) => c.isArchived).toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));

  Future<BillingCycle> rollover(String studentId) async {
    final student = _studentsBox.get(studentId);
    if (student == null) throw Exception('Student not found: $studentId');

    final activeCycle = getActiveCycle(studentId);
    if (activeCycle == null) throw Exception('No active cycle for $studentId');

    final currentLog = _attendanceRepo.getLog(studentId);
    if (currentLog == null) throw Exception('No attendance log for $studentId');

    // Calculate earnings: per-session flat rate
    final attendedCount = currentLog.attendedCount;
    final perSession = student.monthlyFee / student.targetClasses;
    final totalEarned = perSession * attendedCount;

    final now = DateTime.now().toIso8601String();

    // Archive current cycle with snapshot
    final archived = activeCycle.copyWith(
      endDate: now,
      isArchived: true,
      totalEarned: totalEarned,
      archivedTimestamps: List<String>.from(currentLog.timestamps),
      archivedSlotStates: List<bool>.from(currentLog.slotStates),
    );
    await _cyclesBox.put(activeCycle.id, archived);

    // Create fresh cycle
    final newCycleId = _uuid.v4();
    final newCycle = BillingCycle(
      id: newCycleId,
      studentId: studentId,
      startDate: now,
      isArchived: false,
    );
    await _cyclesBox.put(newCycleId, newCycle);

    // Reset attendance log
    await _attendanceRepo.reset(studentId, newCycleId, student.targetClasses);

    return newCycle;
  }

  Future<void> togglePaidStatus(String cycleId) async {
    final cycle = _cyclesBox.get(cycleId);
    if (cycle != null) {
      await _cyclesBox.put(cycleId, cycle.copyWith(isPaid: !cycle.isPaid));
    }
  }
}
