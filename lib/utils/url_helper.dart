import 'package:url_launcher/url_launcher.dart';
import 'package:opdsure/utils/logs/logs.dart';

/// Reusable helper for launching external URLs safely.
/// Used by partnership carousel and icons to open redirect_url in the browser.
class UrlHelper {
  UrlHelper._();

  /// Validates and launches [url] in the device's external browser.
  /// Only allows http:// and https:// schemes.
  /// Fails gracefully on invalid or malformed URLs.
  static Future<void> launchExternalUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null) {
      Logs().w('UrlHelper: Invalid URL format: $url');
      return;
    }

    if (uri.scheme != 'http' && uri.scheme != 'https') {
      Logs().w('UrlHelper: Unsupported URL scheme: ${uri.scheme}');
      return;
    }

    if (uri.host.isEmpty) {
      Logs().w('UrlHelper: URL has no host: $url');
      return;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        Logs().w('UrlHelper: Could not launch URL: $url');
      }
    } catch (e) {
      Logs().e('UrlHelper: Error launching URL: $url, error: $e');
    }
  }
}
