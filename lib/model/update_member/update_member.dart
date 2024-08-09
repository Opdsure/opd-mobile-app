class UpdateMember {
  UpdateMember({
      List<UpdateMemberData>? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  UpdateMember.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(UpdateMemberData.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }
  List<UpdateMemberData>? _data;
  bool? _success;
  String? _message;

  List<UpdateMemberData>? get data => _data;
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

class UpdateMemberData {
  UpdateMemberData({
      String? id, 
      String? name, 
      int? phone, 
      String? countryCode, 
      int? gender, 
      String? dob, 
      String? address, 
      String? memberId, 
      String? userId, 
      String? file, 
      int? relation, 
      int? planStatus, 
      int? reviewStatus, 
      String? createdAt, 
      String? updatedAt, 
      int? v,}){
    _id = id;
    _name = name;
    _phone = phone;
    _countryCode = countryCode;
    _gender = gender;
    _dob = dob;
    _address = address;
    _memberId = memberId;
    _userId = userId;
    _file = file;
    _relation = relation;
    _planStatus = planStatus;
    _reviewStatus = reviewStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  UpdateMemberData.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _phone = json['phone'];
    _countryCode = json['country_code'];
    _gender = json['gender'];
    _dob = json['dob'];
    _address = json['address'];
    _memberId = json['member_id'];
    _userId = json['user_id'];
    _file = json['file'];
    _relation = json['relation'];
    _planStatus = json['plan_status'];
    _reviewStatus = json['review_status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _name;
  int? _phone;
  String? _countryCode;
  int? _gender;
  String? _dob;
  String? _address;
  String? _memberId;
  String? _userId;
  String? _file;
  int? _relation;
  int? _planStatus;
  int? _reviewStatus;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id;
  String? get name => _name;
  int? get phone => _phone;
  String? get countryCode => _countryCode;
  int? get gender => _gender;
  String? get dob => _dob;
  String? get address => _address;
  String? get memberId => _memberId;
  String? get userId => _userId;
  String? get file => _file;
  int? get relation => _relation;
  int? get planStatus => _planStatus;
  int? get reviewStatus => _reviewStatus;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    map['country_code'] = _countryCode;
    map['gender'] = _gender;
    map['dob'] = _dob;
    map['address'] = _address;
    map['member_id'] = _memberId;
    map['user_id'] = _userId;
    map['file'] = _file;
    map['relation'] = _relation;
    map['plan_status'] = _planStatus;
    map['review_status'] = _reviewStatus;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}