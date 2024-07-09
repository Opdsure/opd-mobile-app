// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelationsAdapter extends TypeAdapter<Relations> {
  @override
  final int typeId = 10;

  @override
  Relations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Relations()
      .._data = fields[0] as RelationsData?
      .._success = fields[1] as bool?
      .._message = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, Relations obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._data)
      ..writeByte(1)
      ..write(obj._success)
      ..writeByte(2)
      ..write(obj._message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RelationsDataAdapter extends TypeAdapter<RelationsData> {
  @override
  final int typeId = 11;

  @override
  RelationsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelationsData()
      .._self = fields[0] as int?
      .._father = fields[1] as int?
      .._mother = fields[2] as int?
      .._sister = fields[3] as int?
      .._brother = fields[4] as int?
      .._son = fields[5] as int?
      .._daughter = fields[6] as int?
      .._wife = fields[7] as int?
      .._husband = fields[8] as int?
      .._fatherinlaw = fields[9] as int?
      .._motherinlaw = fields[10] as int?;
  }

  @override
  void write(BinaryWriter writer, RelationsData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._self)
      ..writeByte(1)
      ..write(obj._father)
      ..writeByte(2)
      ..write(obj._mother)
      ..writeByte(3)
      ..write(obj._sister)
      ..writeByte(4)
      ..write(obj._brother)
      ..writeByte(5)
      ..write(obj._son)
      ..writeByte(6)
      ..write(obj._daughter)
      ..writeByte(7)
      ..write(obj._wife)
      ..writeByte(8)
      ..write(obj._husband)
      ..writeByte(9)
      ..write(obj._fatherinlaw)
      ..writeByte(10)
      ..write(obj._motherinlaw);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
