// import 'dart:collection';
//
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class MyInAppBrowser extends InAppBrowser {
//   MyInAppBrowser(
//       {super.windowId,
//         super.initialUserScripts,
//         super.pullToRefreshController});
//
//   @override
//   Future onBrowserCreated() async {
//     print("\n\nBrowser Created!\n\n");
//   }
//
//   @override
//   Future onLoadStart(url) async {}
//
//   @override
//   Future onLoadStop(url) async {
//     pullToRefreshController?.endRefreshing();
//   }
//
//   @override
//   Future<PermissionResponse> onPermissionRequest(permissionRequest) async {
//     return PermissionResponse(
//         resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);
//   }
//
//   @override
//   void onLoadError(url, code, message) {
//     pullToRefreshController?.endRefreshing();
//   }
//
//   @override
//   void onProgressChanged(progress) {
//     if (progress == 100) {
//       pullToRefreshController?.endRefreshing();
//     }
//   }
//
//   @override
//   void onExit() {
//     print("\n\nBrowser closed!\n\n");
//   }
//
//   @override
//   Future<NavigationActionPolicy> shouldOverrideUrlLoading(
//       navigationAction) async {
//     print("\n\nOverride ${navigationAction.request.url}\n\n");
//     return NavigationActionPolicy.ALLOW;
//   }
//
//   @override
//   void onMainWindowWillClose() {
//     close();
//   }
// }