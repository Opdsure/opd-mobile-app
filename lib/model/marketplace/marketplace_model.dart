// Marketplace API response model
// GET /api/v1/user/marketplace/dashboard
//
// Response: { data: { categories: [ { _id, name, sort_order,
//   subcategories: [ { _id, name, icon_url, sort_order, item_count } ] } ] },
//   success, message }

import 'package:opdsure/config/app_config.dart';

class MarketplaceResponse {
  MarketplaceResponse({
    MarketplaceData? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  MarketplaceResponse.fromJson(dynamic json) {
    _data =
        json['data'] != null ? MarketplaceData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  MarketplaceData? _data;
  bool? _success;
  String? _message;

  MarketplaceData? get data => _data;
  bool get success => _success ?? false;
  String get message => _message ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) map['data'] = _data?.toJson();
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }
}

class MarketplaceData {
  MarketplaceData({List<MarketplaceCategory>? categories}) {
    _categories = categories;
  }

  MarketplaceData.fromJson(dynamic json) {
    if (json['categories'] != null) {
      _categories = <MarketplaceCategory>[];
      json['categories'].forEach((v) {
        _categories?.add(MarketplaceCategory.fromJson(v));
      });
    }
  }

  List<MarketplaceCategory>? _categories;

  List<MarketplaceCategory> get categories => _categories ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_categories != null) {
      map['categories'] = _categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MarketplaceCategory {
  MarketplaceCategory({
    String? id,
    String? name,
    int? sortOrder,
    List<MarketplaceSubcategory>? subcategories,
  }) {
    _id = id;
    _name = name;
    _sortOrder = sortOrder;
    _subcategories = subcategories;
  }

  MarketplaceCategory.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _sortOrder = json['sort_order'];
    if (json['subcategories'] != null) {
      _subcategories = <MarketplaceSubcategory>[];
      json['subcategories'].forEach((v) {
        _subcategories?.add(MarketplaceSubcategory.fromJson(v));
      });
    }
  }

  String? _id;
  String? _name;
  int? _sortOrder;
  List<MarketplaceSubcategory>? _subcategories;

  String get id => _id ?? '';
  String get name => _name ?? '';
  int get sortOrder => _sortOrder ?? 0;
  List<MarketplaceSubcategory> get subcategories => _subcategories ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['sort_order'] = _sortOrder;
    if (_subcategories != null) {
      map['subcategories'] = _subcategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MarketplaceSubcategory {
  MarketplaceSubcategory({
    String? id,
    String? name,
    String? iconUrl,
    String? redirectUrl,
    int? sortOrder,
    int? itemCount,
  }) {
    _id = id;
    _name = name;
    _iconUrl = iconUrl;
    _redirectUrl = redirectUrl;
    _sortOrder = sortOrder;
    _itemCount = itemCount;
  }

  MarketplaceSubcategory.fromJson(dynamic json) {
    _id = json['_id'];
    _name = json['name'];
    _iconUrl = json['icon_url'];
    // Accept several possible key names for the redirect target.
    _redirectUrl = json['redirect_url'] ??
        json['url'] ??
        json['link'] ??
        json['redirectUrl'];
    _sortOrder = json['sort_order'];
    _itemCount = json['item_count'];
  }

  String? _id;
  String? _name;
  String? _iconUrl;
  String? _redirectUrl;
  int? _sortOrder;
  int? _itemCount;

  String get id => _id ?? '';
  String get name => _name ?? '';

  /// Resolves the icon URL. Absolute URLs are returned as-is; relative paths
  /// are prefixed with the API base host (mirrors the partnership model).
  String get iconUrl {
    final url = _iconUrl ?? '';
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final path = url.startsWith('/') ? url.substring(1) : url;
    return 'https://${AppConfig.defaultBaseUrl}/$path';
  }

  /// Redirect target when the subcategory is tapped.
  String get redirectUrl => _redirectUrl ?? '';

  int get sortOrder => _sortOrder ?? 0;
  int get itemCount => _itemCount ?? 0;

  /// Whether this subcategory has a valid icon URL
  bool get hasIcon => iconUrl.isNotEmpty;

  /// Whether this subcategory has a launchable redirect URL
  bool get hasRedirect {
    if (redirectUrl.isEmpty) return false;
    final uri = Uri.tryParse(redirectUrl);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['name'] = _name;
    map['icon_url'] = _iconUrl;
    map['redirect_url'] = _redirectUrl;
    map['sort_order'] = _sortOrder;
    map['item_count'] = _itemCount;
    return map;
  }
}
