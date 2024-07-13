class CreateOrder {
  CreateOrder({
      CreatePaymentData? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  CreateOrder.fromJson(dynamic json) {
    _data = json['data'] != null ? CreatePaymentData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  CreatePaymentData? _data;
  bool? _success;
  String? _message;

  CreatePaymentData? get data => _data ?? CreatePaymentData();
  bool? get success => _success ??false;
  String? get message => _message ?? "";

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

class CreatePaymentData {
  CreatePaymentData({
      int? amount, 
      int? amountDue, 
      int? amountPaid, 
      int? attempts, 
      int? createdAt, 
      String? currency, 
      String? entity, 
      String? id, 
      Notes? notes, 
      dynamic offerId, 
      String? receipt, 
      String? status,}){
    _amount = amount;
    _amountDue = amountDue;
    _amountPaid = amountPaid;
    _attempts = attempts;
    _createdAt = createdAt;
    _currency = currency;
    _entity = entity;
    _id = id;
    _notes = notes;
    _offerId = offerId;
    _receipt = receipt;
    _status = status;
}

  CreatePaymentData.fromJson(dynamic json) {
    _amount = json['amount'];
    _amountDue = json['amount_due'];
    _amountPaid = json['amount_paid'];
    _attempts = json['attempts'];
    _createdAt = json['created_at'];
    _currency = json['currency'];
    _entity = json['entity'];
    _id = json['id'];
    _notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    _offerId = json['offer_id'];
    _receipt = json['receipt'];
    _status = json['status'];
  }
  int? _amount;
  int? _amountDue;
  int? _amountPaid;
  int? _attempts;
  int? _createdAt;
  String? _currency;
  String? _entity;
  String? _id;
  Notes? _notes;
  dynamic _offerId;
  String? _receipt;
  String? _status;

  int? get amount => _amount;
  int? get amountDue => _amountDue;
  int? get amountPaid => _amountPaid;
  int? get attempts => _attempts;
  int? get createdAt => _createdAt;
  String? get currency => _currency;
  String? get entity => _entity;
  String? get id => _id;
  Notes? get notes => _notes;
  dynamic get offerId => _offerId;
  String? get receipt => _receipt;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = _amount;
    map['amount_due'] = _amountDue;
    map['amount_paid'] = _amountPaid;
    map['attempts'] = _attempts;
    map['created_at'] = _createdAt;
    map['currency'] = _currency;
    map['entity'] = _entity;
    map['id'] = _id;
    if (_notes != null) {
      map['notes'] = _notes?.toJson();
    }
    map['offer_id'] = _offerId;
    map['receipt'] = _receipt;
    map['status'] = _status;
    return map;
  }

}

class Notes {
  Notes({
      int? membershipId, 
      String? planId,}){
    _membershipId = membershipId;
    _planId = planId;
}

  Notes.fromJson(dynamic json) {
    _membershipId = json['membership_id'];
    _planId = json['plan_id'];
  }
  int? _membershipId;
  String? _planId;

  int? get membershipId => _membershipId;
  String? get planId => _planId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['membership_id'] = _membershipId;
    map['plan_id'] = _planId;
    return map;
  }

}