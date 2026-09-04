import 'package:opdsure/config/app_config.dart';

// Partnership API response model
// GET /api/v1/public/partnerships
//
// Response structure:
// {
//   "data": {
//     "carousel": [...],
//     "icons": [...]
//   },
//   "success": true,
//   "message": "API executed successfully"
// }

class PartnershipResponse {
  PartnershipResponse({
    PartnershipData? data,
    bool? success,
    String? message,
  }) {
    _data = data;
    _success = success;
    _message = message;
  }

  PartnershipResponse.fromJson(dynamic json) {
    _data =
        json['data'] != null ? PartnershipData.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
  }

  PartnershipData? _data;
  bool? _success;
  String? _message;

  PartnershipData? get data => _data;
  bool get success => _success ?? false;
  String get message => _message ?? '';

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

class PartnershipData {
  PartnershipData({
    List<PartnershipItem>? carousel,
    List<PartnershipItem>? icons,
  }) {
    _carousel = carousel;
    _icons = icons;
  }

  PartnershipData.fromJson(dynamic json) {
    if (json['carousel'] != null) {
      _carousel = [];
      json['carousel'].forEach((v) {
        _carousel?.add(PartnershipItem.fromJson(v));
      });
    }
    if (json['icons'] != null) {
      _icons = [];
      json['icons'].forEach((v) {
        _icons?.add(PartnershipItem.fromJson(v));
      });
    }
  }

  List<PartnershipItem>? _carousel;
  List<PartnershipItem>? _icons;

  List<PartnershipItem> get carousel => _carousel ?? [];
  List<PartnershipItem> get icons => _icons ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_carousel != null) {
      map['carousel'] = _carousel?.map((v) => v.toJson()).toList();
    }
    if (_icons != null) {
      map['icons'] = _icons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PartnershipItem {
  PartnershipItem({
    String? id,
    String? title,
    String? subtitle,
    String? redirectUrl,
    String? assetType,
    String? assetUrl,
    String? displayType,
    int? sortOrder,
  }) {
    _id = id;
    _title = title;
    _subtitle = subtitle;
    _redirectUrl = redirectUrl;
    _assetType = assetType;
    _assetUrl = assetUrl;
    _displayType = displayType;
    _sortOrder = sortOrder;
  }

  PartnershipItem.fromJson(dynamic json) {
    _id = json['_id'];
    _title = json['title'];
    _subtitle = json['subtitle'];
    _redirectUrl = json['redirect_url'];
    _assetType = json['asset_type'];
    _assetUrl = json['asset_url'];
    _displayType = json['display_type'];
    _sortOrder = json['sort_order'];
  }

  String? _id;
  String? _title;
  String? _subtitle;
  String? _redirectUrl;
  String? _assetType;
  String? _assetUrl;
  String? _displayType;
  int? _sortOrder;

  String get id => _id ?? '';
  String get title => _title ?? '';
  String get subtitle => _subtitle ?? '';
  String get redirectUrl => _redirectUrl ?? '';
  String get assetType => _assetType ?? '';
  String get assetUrl {
    final url = _assetUrl ?? '';
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://${AppConfig.defaultBaseUrl}/$url';
  }

  String get displayType => _displayType ?? '';
  int get sortOrder => _sortOrder ?? 0;

  /// Infers whether the asset URL points to a video by its file extension.
  /// Used as a fallback when the API omits [assetType].
  bool get _urlLooksLikeVideo {
    final url = assetUrl.toLowerCase();
    if (url.isEmpty) return false;
    const videoExtensions = [
      '.mp4',
      '.mov',
      '.webm',
      '.m4v',
      '.avi',
      '.mkv',
      '.3gp',
    ];
    return videoExtensions.any((ext) => url.contains(ext));
  }

  /// Whether this item has a valid image asset.
  /// Falls back to inferring from the asset URL when [assetType] is missing,
  /// since the API may omit `asset_type`.
  bool get isImage {
    if (assetUrl.isEmpty) return false;
    if (assetType == 'image') return true;
    if (assetType == 'video') return false;
    // asset_type missing/unknown: treat as image unless the URL is a video.
    return !_urlLooksLikeVideo;
  }

  /// Whether this item has a valid video asset.
  /// Falls back to inferring from the asset URL when [assetType] is missing.
  bool get isVideo {
    if (assetUrl.isEmpty) return false;
    if (assetType == 'video') return true;
    if (assetType == 'image') return false;
    return _urlLooksLikeVideo;
  }

  /// Whether this item has a valid redirect URL
  bool get hasValidRedirectUrl {
    if (redirectUrl.isEmpty) return false;
    final uri = Uri.tryParse(redirectUrl);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['title'] = _title;
    map['subtitle'] = _subtitle;
    map['redirect_url'] = _redirectUrl;
    map['asset_type'] = _assetType;
    map['asset_url'] = _assetUrl;
    map['display_type'] = _displayType;
    map['sort_order'] = _sortOrder;
    return map;
  }
}
