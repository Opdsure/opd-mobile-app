// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_box.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientBoxAdapter extends TypeAdapter<ClientBox> {
  @override
  final int typeId = 1;

  @override
  ClientBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientBox()
      .._baseServerUrl = fields[0] as String?
      .._accessToken = fields[1] as String?
      .._userId = fields[2] as String?
      .._id = fields[3] as int?
      .._isPlanPurchased = fields[4] as bool?;
  }

  @override
  void write(BinaryWriter writer, ClientBox obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._baseServerUrl)
      ..writeByte(1)
      ..write(obj._accessToken)
      ..writeByte(2)
      ..write(obj._userId)
      ..writeByte(3)
      ..write(obj._id)
      ..writeByte(4)
      ..write(obj._isPlanPurchased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
