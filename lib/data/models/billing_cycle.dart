import 'package:hive_flutter/hive_flutter.dart';

part 'billing_cycle.g.dart';

@HiveType(typeId: 2)
class BillingCycle extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String studentId;

  @HiveField(2)
  late String startDate; // ISO 8601

  @HiveField(3)
  String? endDate; // null = still active

  @HiveField(4)
  late bool isArchived;

  @HiveField(5)
  double? totalEarned; // calculated at rollover

  @HiveField(6)
  List<String>? archivedTimestamps; // deep copy of timestamps at rollover

  @HiveField(7)
  List<bool>? archivedSlotStates; // deep copy of slot states at rollover

  @HiveField(8)
  bool isPaid; // Track if the cycle salary has been received

  BillingCycle({
    required this.id,
    required this.studentId,
    required this.startDate,
    this.endDate,
    required this.isArchived,
    this.totalEarned,
    this.archivedTimestamps,
    this.archivedSlotStates,
    this.isPaid = false,
  });

  bool get isActive => !isArchived && endDate == null;

  int get archivedAttendedCount =>
      archivedSlotStates?.where((s) => s).length ?? 0;

  BillingCycle copyWith({
    String? id,
    String? studentId,
    String? startDate,
    String? endDate,
    bool? isArchived,
    double? totalEarned,
    List<String>? archivedTimestamps,
    List<bool>? archivedSlotStates,
    bool? isPaid,
  }) {
    return BillingCycle(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isArchived: isArchived ?? this.isArchived,
      totalEarned: totalEarned ?? this.totalEarned,
      archivedTimestamps: archivedTimestamps ?? this.archivedTimestamps,
      archivedSlotStates: archivedSlotStates ?? this.archivedSlotStates,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
