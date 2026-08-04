import 'package:hive_flutter/hive_flutter.dart';

part 'attendance_log.g.dart';

@HiveType(typeId: 1)
class AttendanceLog extends HiveObject {
  /// Foreign key → Student.id
  @HiveField(0)
  late String studentId;

  /// Foreign key → BillingCycle.id
  @HiveField(1)
  late String cycleId;

  /// ISO 8601 timestamps for each attended session.
  /// Length == number of attended slots.
  @HiveField(2)
  late List<String> timestamps;

  /// Index-aligned with Day 1..targetClasses grid.
  /// slotStates[i] == true means slot i is checked.
  @HiveField(3)
  late List<bool> slotStates;

  AttendanceLog({
    required this.studentId,
    required this.cycleId,
    required this.timestamps,
    required this.slotStates,
  });

  /// Number of attended classes
  int get attendedCount => slotStates.where((s) => s).length;

  /// Deep copy (used during cycle rollover)
  AttendanceLog deepCopy() => AttendanceLog(
        studentId: studentId,
        cycleId: cycleId,
        timestamps: List<String>.from(timestamps),
        slotStates: List<bool>.from(slotStates),
      );

  AttendanceLog copyWith({
    String? studentId,
    String? cycleId,
    List<String>? timestamps,
    List<bool>? slotStates,
  }) {
    return AttendanceLog(
      studentId: studentId ?? this.studentId,
      cycleId: cycleId ?? this.cycleId,
      timestamps: timestamps ?? List<String>.from(this.timestamps),
      slotStates: slotStates ?? List<bool>.from(this.slotStates),
    );
  }

  /// Returns Set of DateTime objects (start of day) from timestamps
  Set<DateTime> get attendedDays => timestamps
      .map((t) => DateTime.parse(t))
      .map((dt) => DateTime(dt.year, dt.month, dt.day))
      .toSet();
}
