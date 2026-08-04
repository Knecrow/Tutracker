import 'package:hive_flutter/hive_flutter.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late double monthlyFee;

  @HiveField(3)
  late int targetClasses;

  @HiveField(4)
  late String createdAt;

  @HiveField(5)
  late int avatarColorValue; // stored as int (Color.value)

  @HiveField(6)
  String? subject; // optional subject / notes

  Student({
    required this.id,
    required this.name,
    required this.monthlyFee,
    required this.targetClasses,
    required this.createdAt,
    required this.avatarColorValue,
    this.subject,
  });

  Student copyWith({
    String? id,
    String? name,
    double? monthlyFee,
    int? targetClasses,
    String? createdAt,
    int? avatarColorValue,
    String? subject,
    bool clearSubject = false,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      targetClasses: targetClasses ?? this.targetClasses,
      createdAt: createdAt ?? this.createdAt,
      avatarColorValue: avatarColorValue ?? this.avatarColorValue,
      subject: clearSubject ? null : (subject ?? this.subject),
    );
  }

  @override
  String toString() =>
      'Student(id: $id, name: $name, fee: $monthlyFee, target: $targetClasses)';
}
