class PlanUsageResponse {
  PlanUsageData? _data;
  bool? _success;
  String? _message;

  PlanUsageResponse({PlanUsageData? data, bool? success, String? message}) {
    _data = data;
    _success = success;
    _message = message;
  }

  PlanUsageResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? PlanUsageData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  PlanUsageData? get data => _data;
  bool? get success => _success ?? false;
  String? get message => _message ?? '';
}

class PlanUsageData {
  String? _asOf;
  bool? _hasPlan;
  bool? _planExpired;
  String? _planStartDate;
  String? _planEndDate;
  WalletUsage? _wallet;
  List<CategoryLimit>? _categoryLimits;
  BalanceTotals? _balanceTotals;

  PlanUsageData.fromJson(dynamic json) {
    _asOf = json['as_of'];
    _hasPlan = json['has_plan'];
    _planExpired = json['plan_expired'];
    _planStartDate = json['plan_start_date'];
    _planEndDate = json['plan_end_date'];
    _wallet = json['wallet'] != null ? WalletUsage.fromJson(json['wallet']) : null;
    if (json['category_limits'] != null) {
      _categoryLimits = <CategoryLimit>[];
      json['category_limits'].forEach((v) {
        _categoryLimits!.add(CategoryLimit.fromJson(v));
      });
    }
    _balanceTotals = json['balance_totals'] != null
        ? BalanceTotals.fromJson(json['balance_totals'])
        : null;
  }

  String? get asOf => _asOf;
  bool get hasPlan => _hasPlan ?? false;
  bool get planExpired => _planExpired ?? false;
  String? get planStartDate => _planStartDate;
  String? get planEndDate => _planEndDate;
  WalletUsage? get wallet => _wallet;
  List<CategoryLimit> get categoryLimits => _categoryLimits ?? [];
  BalanceTotals? get balanceTotals => _balanceTotals;
}

class WalletUsage {
  double? _grantedAmount;
  double? _balance;
  double? _utilisedAmount;
  double? _utilisedPercentage;
  double? _settledAmount;
  double? _pendingPayoutAmount;

  WalletUsage.fromJson(dynamic json) {
    _grantedAmount = _toDouble(json['granted_amount']);
    _balance = _toDouble(json['balance']);
    _utilisedAmount = _toDouble(json['utilised_amount']);
    _utilisedPercentage = _toDouble(json['utilised_percentage']);
    _settledAmount = _toDouble(json['settled_amount']);
    _pendingPayoutAmount = _toDouble(json['pending_payout_amount']);
  }

  double get grantedAmount => _grantedAmount ?? 0;
  double get balance => _balance ?? 0;
  double get utilisedAmount => _utilisedAmount ?? 0;
  double get utilisedPercentage => _utilisedPercentage ?? 0;
  double get settledAmount => _settledAmount ?? 0;
  double get pendingPayoutAmount => _pendingPayoutAmount ?? 0;

  double _toDouble(dynamic v) => (v is num) ? v.toDouble() : 0.0;
}

class CategoryLimit {
  String? _key;
  String? _label;
  String? _shortLabel;
  int? _coveragePercentage;
  int? _perClaimLimit;
  int? _totalLimit;
  int? _consumedLimit;
  int? _remainingLimit;

  CategoryLimit.fromJson(dynamic json) {
    _key = json['key'];
    _label = json['label'];
    _shortLabel = json['short_label'];
    _coveragePercentage = json['coverage_percentage'];
    _perClaimLimit = json['per_claim_limit'];
    _totalLimit = json['total_limit'];
    _consumedLimit = json['consumed_limit'];
    _remainingLimit = json['remaining_limit'];
  }

  String get key => _key ?? '';
  String get label => _label ?? '';
  String get shortLabel => _shortLabel ?? '';
  int get coveragePercentage => _coveragePercentage ?? 0;
  int get perClaimLimit => _perClaimLimit ?? 0;
  int get totalLimit => _totalLimit ?? 0;
  int get consumedLimit => _consumedLimit ?? 0;
  int get remainingLimit => _remainingLimit ?? 0;

  double get usedPercentage =>
      totalLimit > 0 ? (consumedLimit / totalLimit) * 100 : 0;
}

class BalanceTotals {
  int? _totalLimit;
  int? _consumedLimit;
  int? _remainingLimit;

  BalanceTotals.fromJson(dynamic json) {
    _totalLimit = json['total_limit'];
    _consumedLimit = json['consumed_limit'];
    _remainingLimit = json['remaining_limit'];
  }

  int get totalLimit => _totalLimit ?? 0;
  int get consumedLimit => _consumedLimit ?? 0;
  int get remainingLimit => _remainingLimit ?? 0;
}
