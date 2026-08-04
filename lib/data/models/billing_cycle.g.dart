// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_cycle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillingCycleAdapter extends TypeAdapter<BillingCycle> {
  @override
  final int typeId = 2;

  @override
  BillingCycle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillingCycle(
      id: fields[0] as String,
      studentId: fields[1] as String,
      startDate: fields[2] as String,
      endDate: fields[3] as String?,
      isArchived: fields[4] as bool,
      totalEarned: fields[5] as double?,
      archivedTimestamps: (fields[6] as List?)?.cast<String>(),
      archivedSlotStates: (fields[7] as List?)?.cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, BillingCycle obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.isArchived)
      ..writeByte(5)
      ..write(obj.totalEarned)
      ..writeByte(6)
      ..write(obj.archivedTimestamps)
      ..writeByte(7)
      ..write(obj.archivedSlotStates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCycleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
