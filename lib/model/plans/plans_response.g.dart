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
      .._data = fields[0] as Data?
      .._success = fields[1] as bool?
      .._message = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, PlansResponse obj) {
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
      other is PlansResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 3;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data()
      .._records = (fields[0] as List?)?.cast<Records>()
      .._pagination = fields[1] as Pagination?;
  }

  @override
  void write(BinaryWriter writer, Data obj) {
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
      other is DataAdapter &&
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
      .._nextPage = fields[4] as dynamic
      .._prevPage = fields[5] as dynamic;
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

class RecordsAdapter extends TypeAdapter<Records> {
  @override
  final int typeId = 5;

  @override
  Records read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Records()
      .._id = fields[0] as String?
      .._name = fields[1] as String?
      .._charges = fields[2] as String?
      .._frequency = fields[3] as int?
      .._features = fields[4] as String?
      .._createdAt = fields[5] as String?
      .._updatedAt = fields[6] as String?
      .._v = fields[7] as int?;
  }

  @override
  void write(BinaryWriter writer, Records obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._charges)
      ..writeByte(3)
      ..write(obj._frequency)
      ..writeByte(4)
      ..write(obj._features)
      ..writeByte(5)
      ..write(obj._createdAt)
      ..writeByte(6)
      ..write(obj._updatedAt)
      ..writeByte(7)
      ..write(obj._v);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
