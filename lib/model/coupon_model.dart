class CouponModel {
  CouponModel({
      Data? data, 
      bool? success, 
      String? message,}){
    _data = data;
    _success = success;
    _message = message;
}

  CouponModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  Data? _data;
  bool? _success;
  String? _message;

  Data? get data => _data ?? Data();
  bool? get success => _success ?? false;
  String? get message => _message ?? '';

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

class Data {
  Data({
      int? planPrice,
    dynamic gst,
      int? couponDiscount, 
      int? preDiscount, 
      int? consumedDays, 
      int? remainingDays,}){
    _planPrice = planPrice;
    _gst = gst;
    _couponDiscount = couponDiscount;
    _preDiscount = preDiscount;
    _consumedDays = consumedDays;
    _remainingDays = remainingDays;
}

  Data.fromJson(dynamic json) {
    _planPrice = json['plan_price'];
    _gst = json['gst'];
    _couponDiscount = json['coupon_discount'];
    _preDiscount = json['pre_discount'];
    _consumedDays = json['consumed_days'];
    _remainingDays = json['remaining_days'];
  }
  dynamic _planPrice;
  dynamic _gst;
  int? _couponDiscount;
  int? _preDiscount;
  int? _consumedDays;
  int? _remainingDays;

  dynamic get planPrice => _planPrice ?? 0;
  dynamic get gst => _gst?? 0;
  int? get couponDiscount => _couponDiscount?? 0;
  int? get preDiscount => _preDiscount ?? 0;
  int? get consumedDays => _consumedDays ?? 0;
  int? get remainingDays => _remainingDays ?? 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['plan_price'] = _planPrice;
    map['gst'] = _gst;
    map['coupon_discount'] = _couponDiscount;
    map['pre_discount'] = _preDiscount;
    map['consumed_days'] = _consumedDays;
    map['remaining_days'] = _remainingDays;
    return map;
  }

}