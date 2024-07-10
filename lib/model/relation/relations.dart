import 'package:hive/hive.dart';
import 'package:opdsure/model/database_type_key.dart';
import 'package:opdsure/utils/app_keys/database_box_key.dart';
import 'package:opdsure/utils/opd_extension/int_extention.dart';

part 'relations.g.dart';

@HiveType(typeId: DatabaseTypeKey.relationsBox)
class Relations {
  Relations({
      RelationsData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  Relations.fromJson(dynamic json) {
    _data = json['data'] != null ? RelationsData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  @HiveField(0)
  RelationsData? _data;
  @HiveField(1)
  bool? _success;
  @HiveField(2)
  String? _message;

  RelationsData? get data => _data;
  bool? get success => _success;
  String? get message => _message;

  List<Relation> get relationsData{
    List<Relation> relations = [];
    for (var entry in _data!.toJson().entries) {
      relations.add(Relation(entry.value!.getRelation(), entry.value!));
  }
    return relations;
  }

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

@HiveType(typeId: DatabaseTypeKey.relationsData)
class RelationsData {
  RelationsData({
      int? self, 
      int? father, 
      int? mother, 
      int? sister, 
      int? brother, 
      int? son, 
      int? daughter, 
      int? wife, 
      int? husband, 
      int? fatherinlaw, 
      int? motherinlaw,}){
    _self = self;
    _father = father;
    _mother = mother;
    _sister = sister;
    _brother = brother;
    _son = son;
    _daughter = daughter;
    _wife = wife;
    _husband = husband;
    _fatherinlaw = fatherinlaw;
    _motherinlaw = motherinlaw;
}

  RelationsData.fromJson(dynamic json) {
    _self = json['SELF'];
    _father = json['FATHER'];
    _mother = json['MOTHER'];
    _sister = json['SISTER'];
    _brother = json['BROTHER'];
    _son = json['SON'];
    _daughter = json['DAUGHTER'];
    _wife = json['WIFE'];
    _husband = json['HUSBAND'];
    _fatherinlaw = json['FATHER_IN_LAW'];
    _motherinlaw = json['MOTHER_IN_LAW'];
  }

  @HiveField(0)
  int? _self;
  @HiveField(1)
  int? _father;
  @HiveField(2)
  int? _mother;
  @HiveField(3)
  int? _sister;
  @HiveField(4)
  int? _brother;
  @HiveField(5)
  int? _son;
  @HiveField(6)
  int? _daughter;
  @HiveField(7)
  int? _wife;
  @HiveField(8)
  int? _husband;
  @HiveField(9)
  int? _fatherinlaw;
  @HiveField(10)
  int? _motherinlaw;

  int? get self => _self;
  int? get father => _father;
  int? get mother => _mother;
  int? get sister => _sister;
  int? get brother => _brother;
  int? get son => _son;
  int? get daughter => _daughter;
  int? get wife => _wife;
  int? get husband => _husband;
  int? get fatherinlaw => _fatherinlaw;
  int? get motherinlaw => _motherinlaw;

  Map<String, int?> toJson() {
    final map = <String, int?>{};
    map['SELF'] = _self;
    map['FATHER'] = _father;
    map['MOTHER'] = _mother;
    map['SISTER'] = _sister;
    map['BROTHER'] = _brother;
    map['SON'] = _son;
    map['DAUGHTER'] = _daughter;
    map['WIFE'] = _wife;
    map['HUSBAND'] = _husband;
    map['FATHER_IN_LAW'] = _fatherinlaw;
    map['MOTHER_IN_LAW'] = _motherinlaw;
    return map;
  }
}

class Relation{
  String name;
  int value;

  Relation(this.name, this.value);
}