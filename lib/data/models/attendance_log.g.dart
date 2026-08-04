// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceLogAdapter extends TypeAdapter<AttendanceLog> {
  @override
  final int typeId = 1;

  @override
  AttendanceLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceLog(
      studentId: fields[0] as String,
      cycleId: fields[1] as String,
      timestamps: (fields[2] as List).cast<String>(),
      slotStates: (fields[3] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.cycleId)
      ..writeByte(2)
      ..write(obj.timestamps)
      ..writeByte(3)
      ..write(obj.slotStates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
