class CalculateClaimModel {
  CalculateClaimModel({
    Data? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  CalculateClaimModel.fromJson(dynamic json) {
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
    dynamic finalPrice,
    dynamic percentage,
    dynamic amount,
    dynamic claimableAmount,
    String? appliedRule,
  }) {
    _finalPrice = finalPrice;
    _percentage = percentage;
    _amount = amount;
    _claimableAmount = claimableAmount;
    _appliedRule = appliedRule;
  }

  Data.fromJson(dynamic json) {
    _finalPrice = json['finalPrice'];
    _percentage = json['percentage'];
    _amount = json['amount'];
    _claimableAmount = json['claimableAmount'];
    _appliedRule = json['appliedRule'];
  }

  dynamic _finalPrice;
  dynamic _percentage;
  dynamic _amount;
  dynamic _claimableAmount;
  String? _appliedRule;

  dynamic get finalPrice => _finalPrice;
  dynamic get percentage => _percentage;
  dynamic get amount => _amount;
  dynamic get claimableAmount => _claimableAmount;
  String? get appliedRule => _appliedRule;

  /// Returns a human-readable explanation for the applied rule.
  String? get appliedRuleLabel {
    if (_appliedRule == null) return null;
    switch (_appliedRule) {
      case 'PERCENTAGE':
        return '${_percentage}% plan coverage applied';
      case 'PER_CLAIM_LIMIT':
        return 'Capped by per-claim limit (plan covers ${_percentage}%, but max \u20B9${_claimableAmount} per claim)';
      case 'MAX_CLAIM_BALANCE':
        return 'Capped by remaining claim balance (plan covers ${_percentage}%, but only \u20B9${_claimableAmount} balance left)';
      default:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['finalPrice'] = _finalPrice;
    map['percentage'] = _percentage;
    map['amount'] = _amount;
    map['claimableAmount'] = _claimableAmount;
    map['appliedRule'] = _appliedRule;
    return map;
  }
}
