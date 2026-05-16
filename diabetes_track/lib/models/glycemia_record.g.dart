// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glycemia_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlycemiaRecordAdapter extends TypeAdapter<GlycemiaRecord> {
  @override
  final int typeId = 0;

  @override
  GlycemiaRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlycemiaRecord(
      value: fields[0] as double,
      unit: fields[1] as String,
      condition: fields[2] as String,
      category: fields[3] as String,
      dateTime: fields[4] as DateTime,
      type: fields[5] as String,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GlycemiaRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.condition)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlycemiaRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
