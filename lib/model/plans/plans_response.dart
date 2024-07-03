import 'package:hive/hive.dart';
part 'plans_response.g.dart';

@HiveType(typeId: 2)
class PlansResponse {
  PlansResponse({
      Data? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  PlansResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  @HiveField(0)
  Data? _data;
  @HiveField(1)
  bool? _success;
  @HiveField(2)
  String? _message;

  Data? get data => _data;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

@HiveType(typeId: 3)
class Data {
  Data({
      List<Records>? records, 
      Pagination? pagination,}){
    _records = records;
    _pagination = pagination;
}

  Data.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(Records.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  @HiveField(0)
  List<Records>? _records;
  @HiveField(1)
  Pagination? _pagination;

  List<Records>? get records => _records;
  Pagination? get pagination => _pagination;
  List<String>? get plansName{
    if(_records != null){
      var nameList = <String>[];
      for(var name in _records!){
        nameList.add(name.name!);
      }
      return nameList;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    if (_pagination != null) {
      map['pagination'] = _pagination?.toJson();
    }
    return map;
  }

}

@HiveType(typeId: 4)
class Pagination {
  Pagination({
      int? totalRecords, 
      int? pageSize, 
      int? totalPages, 
      int? currentPage, 
      dynamic nextPage, 
      dynamic prevPage,}){
    _totalRecords = totalRecords;
    _pageSize = pageSize;
    _totalPages = totalPages;
    _currentPage = currentPage;
    _nextPage = nextPage;
    _prevPage = prevPage;
}

  Pagination.fromJson(dynamic json) {
    _totalRecords = json['totalRecords'];
    _pageSize = json['pageSize'];
    _totalPages = json['totalPages'];
    _currentPage = json['currentPage'];
    _nextPage = json['nextPage'];
    _prevPage = json['prevPage'];
  }
  @HiveField(0)
  int? _totalRecords;
  @HiveField(1)
  int? _pageSize;
  @HiveField(2)
  int? _totalPages;
  @HiveField(3)
  int? _currentPage;
  @HiveField(4)
  dynamic _nextPage;
  @HiveField(5)
  dynamic _prevPage;

  int? get totalRecords => _totalRecords;
  int? get pageSize => _pageSize;
  int? get totalPages => _totalPages;
  int? get currentPage => _currentPage;
  dynamic get nextPage => _nextPage;
  dynamic get prevPage => _prevPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRecords'] = _totalRecords;
    map['pageSize'] = _pageSize;
    map['totalPages'] = _totalPages;
    map['currentPage'] = _currentPage;
    map['nextPage'] = _nextPage;
    map['prevPage'] = _prevPage;
    return map;
  }

}

@HiveType(typeId: 5)
class Records {
  Records({
      String? id, 
      String? name, 
      String? charges, 
      int? frequency, 
      String? features, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _name = name;
    _charges = charges;
    _frequency = frequency;
    _features = features;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Records.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _charges = json['charges'];
    _frequency = json['frequency'];
    _features = json['features'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _charges;
  @HiveField(3)
  int? _frequency;
  @HiveField(4)
  String? _features;
  @HiveField(5)
  String? _createdAt;
  @HiveField(6)
  String? _updatedAt;
  @HiveField(7)
  int? _v;

  String? get id => _id;
  String? get name => _name;
  String? get charges => _charges!.replaceAll(' Rs.', '');
  int? get frequency => _frequency;
  String? get features => _features;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['charges'] = _charges;
    map['frequency'] = _frequency;
    map['features'] = _features;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}