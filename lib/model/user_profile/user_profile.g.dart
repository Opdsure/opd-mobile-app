// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 8;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile()
      .._data = fields[0] as ProfileData?
      .._success = fields[1] as bool?
      .._message = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
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
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfileDataAdapter extends TypeAdapter<ProfileData> {
  @override
  final int typeId = 9;

  @override
  ProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileData()
      .._verified = fields[0] as Verified?
      .._plan = fields[1] as Plan?
      .._id = fields[2] as String?
      .._phone = fields[3] as String?
      .._email = fields[4] as String?
      .._state = fields[5] as int?
      .._city = fields[6] as String?
      .._pinCode = fields[7] as int?
      .._address = fields[8] as String?
      .._countryCode = fields[9] as String?
      .._gender = fields[10] as int?
      .._dob = fields[11] as String?
      .._organizationId = fields[12] as String?
      .._profileImage = fields[13] as String?
      .._name = fields[14] as String?
      .._walletBalance = fields[15] as int?;
  }

  @override
  void write(BinaryWriter writer, ProfileData obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj._verified)
      ..writeByte(1)
      ..write(obj._plan)
      ..writeByte(2)
      ..write(obj._id)
      ..writeByte(3)
      ..write(obj._phone)
      ..writeByte(4)
      ..write(obj._email)
      ..writeByte(5)
      ..write(obj._state)
      ..writeByte(6)
      ..write(obj._city)
      ..writeByte(7)
      ..write(obj._pinCode)
      ..writeByte(8)
      ..write(obj._address)
      ..writeByte(9)
      ..write(obj._countryCode)
      ..writeByte(10)
      ..write(obj._gender)
      ..writeByte(11)
      ..write(obj._dob)
      ..writeByte(12)
      ..write(obj._organizationId)
      ..writeByte(13)
      ..write(obj._profileImage)
      ..writeByte(14)
      ..write(obj._name)
      ..writeByte(15)
      ..write(obj._walletBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlanAdapter extends TypeAdapter<Plan> {
  @override
  final int typeId = 14;

  @override
  Plan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plan()
      .._purchased = fields[0] as bool?
      .._id = fields[1] as String?
      .._membershipId = fields[2] as int?;
  }

  @override
  void write(BinaryWriter writer, Plan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._purchased)
      ..writeByte(1)
      ..write(obj._id)
      ..writeByte(2)
      ..write(obj._membershipId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VerifiedAdapter extends TypeAdapter<Verified> {
  @override
  final int typeId = 15;

  @override
  Verified read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Verified()
      .._email = fields[0] as bool?
      .._phone = fields[1] as bool?;
  }

  @override
  void write(BinaryWriter writer, Verified obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._email)
      ..writeByte(1)
      ..write(obj._phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerifiedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
