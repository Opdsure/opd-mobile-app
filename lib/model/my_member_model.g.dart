// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_member_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyMemberModelAdapter extends TypeAdapter<MyMemberModel> {
  @override
  final int typeId = 12;

  @override
  MyMemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyMemberModel()
      .._data = (fields[0] as List?)?.cast<MemberList>()
      .._success = fields[1] as bool?
      .._message = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, MyMemberModel obj) {
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
      other is MyMemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemberListAdapter extends TypeAdapter<MemberList> {
  @override
  final int typeId = 13;

  @override
  MemberList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberList()
      .._id = fields[0] as String?
      .._name = fields[1] as String?
      .._phone = fields[2] as dynamic?
      .._countryCode = fields[3] as String?
      .._gender = fields[4] as int?
      .._dob = fields[5] as String?
      .._userId = fields[6] as String?
      .._address = fields[7] as String?
      .._relation = fields[8] as int?
      .._planStatus = fields[9] as int?
      .._reviewStatus = fields[10] as int?
      .._createdAt = fields[11] as String?
      .._updatedAt = fields[12] as String?
      .._v = fields[13] as int?;
  }

  @override
  void write(BinaryWriter writer, MemberList obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._phone)
      ..writeByte(3)
      ..write(obj._countryCode)
      ..writeByte(4)
      ..write(obj._gender)
      ..writeByte(5)
      ..write(obj._dob)
      ..writeByte(6)
      ..write(obj._userId)
      ..writeByte(7)
      ..write(obj._address)
      ..writeByte(8)
      ..write(obj._relation)
      ..writeByte(9)
      ..write(obj._planStatus)
      ..writeByte(10)
      ..write(obj._reviewStatus)
      ..writeByte(11)
      ..write(obj._createdAt)
      ..writeByte(12)
      ..write(obj._updatedAt)
      ..writeByte(13)
      ..write(obj._v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
