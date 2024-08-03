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

class Data {
  Data({
      int? planPrice, 
      dynamic gst,
      dynamic couponDiscount,}){
    _planPrice = planPrice;
    _gst = gst;
    _couponDiscount = couponDiscount;
}

  Data.fromJson(dynamic json) {
    _planPrice = json['plan_price'];
    _gst = json['gst'];
    _couponDiscount = json['coupon_discount'];
  }
  int? _planPrice;
  dynamic _gst;
  dynamic _couponDiscount;

  int? get planPrice => _planPrice;
  dynamic get gst => _gst;
  dynamic get couponDiscount => _couponDiscount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['plan_price'] = _planPrice;
    map['gst'] = _gst;
    map['coupon_discount'] = _couponDiscount;
    return map;
  }

}