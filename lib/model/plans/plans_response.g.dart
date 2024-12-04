// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlansResponseAdapter extends TypeAdapter<PlansResponse> {
  @override
  final int typeId = 2;

  @override
  PlansResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlansResponse()
      .._data = fields[0] as PlansData?
      .._success = fields[1] as bool?
      .._message = fields[2] as String?
      .._error = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, PlansResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._data)
      ..writeByte(1)
      ..write(obj._success)
      ..writeByte(2)
      ..write(obj._message)
      ..writeByte(3)
      ..write(obj._error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlansResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlansDataAdapter extends TypeAdapter<PlansData> {
  @override
  final int typeId = 3;

  @override
  PlansData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlansData()
      .._records = (fields[0] as List?)?.cast<PlanRecords>()
      .._pagination = fields[1] as Pagination?;
  }

  @override
  void write(BinaryWriter writer, PlansData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._records)
      ..writeByte(1)
      ..write(obj._pagination);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlansDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaginationAdapter extends TypeAdapter<Pagination> {
  @override
  final int typeId = 4;

  @override
  Pagination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pagination()
      .._totalRecords = fields[0] as int?
      .._pageSize = fields[1] as int?
      .._totalPages = fields[2] as int?
      .._currentPage = fields[3] as int?
      .._nextPage = fields[4] as int?
      .._prevPage = fields[5] as int?;
  }

  @override
  void write(BinaryWriter writer, Pagination obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._totalRecords)
      ..writeByte(1)
      ..write(obj._pageSize)
      ..writeByte(2)
      ..write(obj._totalPages)
      ..writeByte(3)
      ..write(obj._currentPage)
      ..writeByte(4)
      ..write(obj._nextPage)
      ..writeByte(5)
      ..write(obj._prevPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlanRecordsAdapter extends TypeAdapter<PlanRecords> {
  @override
  final int typeId = 5;

  @override
  PlanRecords read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanRecords()
      .._id = fields[0] as String?
      .._name = fields[1] as String?
      .._frequency = fields[2] as int?
      .._subscriberType = fields[3] as int?
      .._opdMaxDiscount = fields[4] as int?
      .._opdPrecentDiscount = fields[5] as int?
      .._labMaxDiscount = fields[6] as int?
      .._labPrecentDiscount = fields[7] as int?
      .._pharmacyMaxDiscount = fields[8] as int?
      .._pharmacyPrecentDiscount = fields[9] as int?
      .._planBenefits = (fields[10] as List?)?.cast<PlanBenefits>()
      .._membershipOptions = (fields[11] as List?)?.cast<MembershipOptions>()
      .._files = (fields[12] as List?)?.cast<String>()
      .._createdAt = fields[13] as String?
      .._updatedAt = fields[14] as String?
      .._v = fields[15] as int?;
  }

  @override
  void write(BinaryWriter writer, PlanRecords obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._frequency)
      ..writeByte(3)
      ..write(obj._subscriberType)
      ..writeByte(4)
      ..write(obj._opdMaxDiscount)
      ..writeByte(5)
      ..write(obj._opdPrecentDiscount)
      ..writeByte(6)
      ..write(obj._labMaxDiscount)
      ..writeByte(7)
      ..write(obj._labPrecentDiscount)
      ..writeByte(8)
      ..write(obj._pharmacyMaxDiscount)
      ..writeByte(9)
      ..write(obj._pharmacyPrecentDiscount)
      ..writeByte(10)
      ..write(obj._planBenefits)
      ..writeByte(11)
      ..write(obj._membershipOptions)
      ..writeByte(12)
      ..write(obj._files)
      ..writeByte(13)
      ..write(obj._createdAt)
      ..writeByte(14)
      ..write(obj._updatedAt)
      ..writeByte(15)
      ..write(obj._v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanRecordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MembershipOptionsAdapter extends TypeAdapter<MembershipOptions> {
  @override
  final int typeId = 6;

  @override
  MembershipOptions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MembershipOptions()
      .._membershipId = fields[0] as int?
      .._membershipLabel = fields[1] as String?
      .._memberCount = fields[2] as int?
      .._charges = fields[3] as dynamic
      .._walletBalance = fields[4] as int?;
  }

  @override
  void write(BinaryWriter writer, MembershipOptions obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._membershipId)
      ..writeByte(1)
      ..write(obj._membershipLabel)
      ..writeByte(2)
      ..write(obj._memberCount)
      ..writeByte(3)
      ..write(obj._charges)
      ..writeByte(4)
      ..write(obj._walletBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlanBenefitsAdapter extends TypeAdapter<PlanBenefits> {
  @override
  final int typeId = 7;

  @override
  PlanBenefits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlanBenefits()
      .._planLabel = fields[0] as String?
      .._planFeature = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, PlanBenefits obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._planLabel)
      ..writeByte(1)
      ..write(obj._planFeature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanBenefitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
