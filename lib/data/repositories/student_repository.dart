import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../../core/constants/app_constants.dart';
import '../models/attendance_log.dart';
import '../models/billing_cycle.dart';

class StudentRepository {
  Box<Student> get _box => Hive.box<Student>(AppConstants.studentsBox);
  Box<AttendanceLog> get _attendanceBox =>
      Hive.box<AttendanceLog>(AppConstants.attendanceBox);
  Box<BillingCycle> get _cyclesBox =>
      Hive.box<BillingCycle>(AppConstants.cyclesBox);

  final _uuid = const Uuid();

  List<Student> getAll() => _box.values.toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Student? getById(String id) => _box.get(id);

  Future<Student> add({
    required String name,
    required double monthlyFee,
    required int targetClasses,
    required int avatarColorValue,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toIso8601String();

    final student = Student(
      id: id,
      name: name,
      monthlyFee: monthlyFee,
      targetClasses: targetClasses,
      createdAt: now,
      avatarColorValue: avatarColorValue,
    );
    await _box.put(id, student);

    // Initialize empty attendance log
    final cycleId = _uuid.v4();
    final log = AttendanceLog(
      studentId: id,
      cycleId: cycleId,
      timestamps: [],
      slotStates: List.filled(targetClasses, false),
    );
    await _attendanceBox.put(id, log);

    // Initialize first billing cycle
    final cycle = BillingCycle(
      id: cycleId,
      studentId: id,
      startDate: now,
      isArchived: false,
    );
    await _cyclesBox.put(cycleId, cycle);

    return student;
  }

  Future<void> update(Student student) async {
    await _box.put(student.id, student);
    // If targetClasses changed, resize slotStates
    final log = _attendanceBox.get(student.id);
    if (log != null && log.slotStates.length != student.targetClasses) {
      final newStates = List<bool>.filled(student.targetClasses, false);
      for (var i = 0; i < log.slotStates.length && i < student.targetClasses; i++) {
        newStates[i] = log.slotStates[i];
      }
      final updated = log.copyWith(slotStates: newStates);
      await _attendanceBox.put(student.id, updated);
    }
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
    await _attendanceBox.delete(id);
    // Archive cycles are kept for history
  }
}
