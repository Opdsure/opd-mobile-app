// Marketplace items API response model
// GET /api/v1/user/marketplace/subcategories/{subcategoryId}/items
//
// Each item is an image or video card with a title, subtitle and redirect URL.
// Response: { data: { items: [ { _id, title, subtitle, redirect_url,
//   asset_type, asset_url, sort_order } ] }, success, message }

import 'package:opdsure/config/app_config.dart';

class MarketplaceItemsResponse {
  MarketplaceItemsResponse({
    List<MarketplaceItem>? items,
    bool? success,
    String? message,
  }) {
    _items = items;
    _success = success;
    _message = message;
  }

  MarketplaceItemsResponse.fromJson(dynamic json) {
    // The items list can appear in several shapes depending on the API:
    //   { data: { items: [...] } }
    //   { data: { subcategory: { items: [...] } } }
    //   { data: [...] }
    //   { items: [...] }
    // As a last resort, scan the data map for the first List of maps.
    _items = _extractItems(json);
    _success = json['success'];
    _message = json['message'];
  }

  static List<MarketplaceItem> _extractItems(dynamic json) {
    final data = json is Map ? json['data'] : null;

    if (data is List) return _parseList(data);

    if (data is Map) {
      if (data['items'] is List) return _parseList(data['items']);
      if (data['subcategory'] is Map &&
          (data['subcategory'] as Map)['items'] is List) {
        return _parseList((data['subcategory'] as Map)['items']);
      }
      // Fallback: first list of maps found inside data.
      for (final value in data.values) {
        if (value is List && (value.isEmpty || value.first is Map)) {
          return _parseList(value);
        }
      }
    }

    if (json is Map && json['items'] is List) {
      return _parseList(json['items']);
    }
    return <MarketplaceItem>[];
  }

  static List<MarketplaceItem> _parseList(List raw) {
    return raw
        .whereType<Map>()
        .map((e) => MarketplaceItem.fromJson(e))
        .toList();
  }

  List<MarketplaceItem>? _items;
  bool? _success;
  String? _message;

  List<MarketplaceItem> get items => _items ?? [];
  bool get success => _success ?? false;
  String get message => _message ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = {'items': _items?.map((v) => v.toJson()).toList()};
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }
}

class MarketplaceItem {
  MarketplaceItem({
    String? id,
    String? title,
    String? subtitle,
    String? redirectUrl,
    String? assetType,
    String? assetUrl,
    int? sortOrder,
  }) {
    _id = id;
    _title = title;
    _subtitle = subtitle;
    _redirectUrl = redirectUrl;
    _assetType = assetType;
    _assetUrl = assetUrl;
    _sortOrder = sortOrder;
  }

  MarketplaceItem.fromJson(dynamic json) {
    _id = json['_id'] ?? json['id'];
    _title = json['title'] ?? json['name'];
    _subtitle = json['subtitle'] ?? json['description'];
    _assetType = json['asset_type'];
    _assetUrl = json['asset_url'] ?? json['image_url'] ?? json['media_url'];
    _sortOrder = json['sort_order'];

    // Try the known key names first.
    _redirectUrl = json['redirect_url'] ??
        json['redirection_url'] ??
        json['redirect'] ??
        json['redirectUrl'] ??
        json['target_url'] ??
        json['external_url'] ??
        json['website'] ??
        json['link'] ??
        json['url'];

    // Fallback: scan every string value in the item for an http(s) URL that
    // is not the asset URL. This makes redirection work regardless of the
    // exact field name the API uses.
    if ((_redirectUrl == null || _redirectUrl!.isEmpty) && json is Map) {
      final assetRaw = (_assetUrl ?? '').toString();
      for (final value in json.values) {
        if (value is String &&
            (value.startsWith('http://') || value.startsWith('https://')) &&
            value != assetRaw) {
          _redirectUrl = value;
          break;
        }
      }
    }
  }

  String? _id;
  String? _title;
  String? _subtitle;
  String? _redirectUrl;
  String? _assetType;
  String? _assetUrl;
  int? _sortOrder;

  String get id => _id ?? '';
  String get title => _title ?? '';
  String get subtitle => _subtitle ?? '';
  String get redirectUrl => _redirectUrl ?? '';
  String get assetType => _assetType ?? '';

  /// Absolute asset URL. Relative paths are prefixed with the API host.
  String get assetUrl {
    final url = _assetUrl ?? '';
    if (url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final path = url.startsWith('/') ? url.substring(1) : url;
    return 'https://${AppConfig.defaultBaseUrl}/$path';
  }

  int get sortOrder => _sortOrder ?? 0;

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

  /// Whether the item's asset is an image.
  /// Falls back to URL extension when [assetType] is missing.
  bool get isImage {
    if (assetUrl.isEmpty) return false;
    if (assetType == 'image') return true;
    if (assetType == 'video') return false;
    return !_urlLooksLikeVideo;
  }

  /// Whether the item's asset is a video.
  bool get isVideo {
    if (assetUrl.isEmpty) return false;
    if (assetType == 'video') return true;
    if (assetType == 'image') return false;
    return _urlLooksLikeVideo;
  }

  bool get hasAsset => assetUrl.isNotEmpty;

  /// Whether the item has a launchable redirect URL.
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
    map['title'] = _title;
    map['subtitle'] = _subtitle;
    map['redirect_url'] = _redirectUrl;
    map['asset_type'] = _assetType;
    map['asset_url'] = _assetUrl;
    map['sort_order'] = _sortOrder;
    return map;
  }
}
