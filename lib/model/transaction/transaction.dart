class Transaction {
  Transaction({
      List<TransactionData>? data,
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  Transaction.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TransactionData.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }
  List<TransactionData>? _data;
  bool? _success;
  String? _message;

  List<TransactionData>? get data => _data ?? [];
  bool? get success => _success ?? false;
  String? get message => _message ?? "";

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

class TransactionData {
  TransactionData({
      String? id, 
      String? userId, 
      int? amount, 
      int? type, 
      String? planId, 
      String? claimId,
      String? createdAt,
      String? updatedAt, 
      int? v,}){
    _id = id;
    _userId = userId;
    _amount = amount;
    _type = type;
    _planId = planId;
    _claimId = claimId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  TransactionData.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['user_id'];
    _amount = json['amount'];
    _type = json['type'];
    _planId = json['plan_id'];
    _claimId = json['claim_id'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _userId;
  int? _amount;
  int? _type;
  String? _planId;
  String? _claimId;
  String? _createdAt;
  String? _updatedAt;
  int? _v;

  String? get id => _id ?? '';
  String? get userId => _userId ?? '';
  int? get amount => _amount ?? 0;
  int? get type => _type ?? 0;
  String? get planId => _planId ?? '';
  String? get claimId => _claimId ?? "";
  String? get createdAt => _createdAt ?? "";
  String? get updatedAt => _updatedAt ?? "";
  int? get v => _v ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['user_id'] = _userId;
    map['amount'] = _amount;
    map['type'] = _type;
    map['plan_id'] = _planId;
    map['claim_id'] = _claimId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}