import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/repository/network_api/api.dart';


enum RequestType { GET, POST, PUT, DELETE }

class OpdApi extends Api {

  Uri? get baseServerUri => baseUri;

  set baseServerUri(Uri? uri) => baseUri = uri;

  String? get accessToken => bearerToken;

  set accessToken(String? token) => bearerToken = token;


  @override
  Never bodySizeExceeded(int expected, int actual) {
    super.bodySizeExceeded(expected, actual);
  }

  @override
  Never unexpectedResponse(BaseResponse response, Uint8List body) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      final resp = json.decode(utf8.decode(body));
      if (resp is Map<String, Object?>) {
        super.unexpectedResponse(response, body);
        //throw MatrixException.fromJson(resp);
      }
    }
    super.unexpectedResponse(response, body);
  }

  OpdApi({
    Uri? baseServerUri,
    String? accessToken,
    super.httpClient
  }) : super(baseUri: baseServerUri, bearerToken: accessToken);


  Future<Map<String, Object?>> request(
      RequestType type,
      String action, {
        dynamic data = '',
        String contentType = 'application/json',
        Map<String, Object?>? query,
      }) async {
    if (baseServerUri == null) {
      throw ('No homeserver specified.');
    }
    dynamic json;
    (data is! String) ? json = jsonEncode(data) : json = data;
    if (data is List<int> || action.startsWith('/media/v3/upload')) json = data;

    final url = baseServerUri!
        .resolveUri(Uri(path: '_matrix$action', queryParameters: query));

    final headers = <String, String>{};
    if (type == RequestType.PUT || type == RequestType.POST) {
      headers['Content-Type'] = contentType;
    }
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    late http.Response resp;
    Map<String, Object?>? jsonResp = <String, Object?>{};
    try {
      switch (type) {
        case RequestType.GET:
          resp = await httpClient.get(url, headers: headers);
          break;
        case RequestType.POST:
          resp = await httpClient.post(url, body: json, headers: headers);
          break;
        case RequestType.PUT:
          resp = await httpClient.put(url, body: json, headers: headers);
          break;
        case RequestType.DELETE:
          resp = await httpClient.delete(url, headers: headers);
          break;
      }
      var respBody = resp.body;
      try {
        respBody = utf8.decode(resp.bodyBytes);
      } catch (_) {
        // No-OP
      }
      if (resp.statusCode >= 500 && resp.statusCode < 600) {
        throw Exception(respBody);
      }
      var jsonString = String.fromCharCodes(respBody.runes);
      if (jsonString.startsWith('[') && jsonString.endsWith(']')) {
        jsonString = '{"chunk":$jsonString}';
      }
      jsonResp = jsonDecode(jsonString)
      as Map<String, Object?>?; // May throw FormatException
    } catch (e, s) {
      throw 'Error: ${e.toString()}  trace: ${s.toString()}';
    }
    if (resp.statusCode >= 400 && resp.statusCode < 500) {
      throw '';
    }

    return jsonResp!;
  }
}