// import 'dart:collection';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../config/app_config.dart';
//
// class WebView extends StatefulWidget {
//   final String url;
//
//   const WebView({required this.url, super.key});
//
//   @override
//   _WebViewState createState() => _WebViewState();
// }
//
// class _WebViewState extends State<WebView> {
//   final GlobalKey webViewKey = GlobalKey();
//
//   InAppWebViewController? webViewController;
//   InAppWebViewSettings settings = InAppWebViewSettings(
//       minimumZoomScale: 1,
//       maximumZoomScale: 1,
//       isInspectable: true,
//       mediaPlaybackRequiresUserGesture: false,
//       allowsInlineMediaPlayback: true,
//       iframeAllow: "camera; microphone",
//       iframeAllowFullscreen: true);
//
//   PullToRefreshController? pullToRefreshController;
//
//   late ContextMenu contextMenu;
//   String url = "";
//   double progress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     contextMenu = ContextMenu(
//         menuItems: [
//           ContextMenuItem(
//               id: 1,
//               title: "Special",
//               action: () async {
//                 print("Menu item Special clicked!");
//                 print(await webViewController?.getSelectedText());
//                 await webViewController?.clearFocus();
//               })
//         ],
//         settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
//         onCreateContextMenu: (hitTestResult) async {});
//
//     pullToRefreshController = kIsWeb ||
//             ![TargetPlatform.iOS, TargetPlatform.android]
//                 .contains(defaultTargetPlatform)
//         ? null
//         : PullToRefreshController(
//             settings: PullToRefreshSettings(
//               color: AppConfig.primaryColor,
//             ),
//             onRefresh: () async {
//               if (defaultTargetPlatform == TargetPlatform.android) {
//                 webViewController?.reload();
//               } else if (defaultTargetPlatform == TargetPlatform.iOS ||
//                   defaultTargetPlatform == TargetPlatform.macOS) {
//                 webViewController?.loadUrl(
//                     urlRequest:
//                         URLRequest(url: WebUri(widget.url)));
//               }
//             },
//           );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: InAppWebView(
//         io
//         key: webViewKey,
//         initialUrlRequest: URLRequest(url: WebUri(widget.url)),
//         initialUserScripts: UnmodifiableListView<UserScript>([]),
//         initialSettings: settings,
//         contextMenu: contextMenu,
//         pullToRefreshController: pullToRefreshController,
//         onWebViewCreated: (controller) async {
//           webViewController = controller;
//         },
//         onLoadStart: (controller, url) async {
//           setState(() {
//             this.url = url.toString();
//           });
//         },
//         onGeolocationPermissionsShowPrompt: (controller, origin) async {
//           return GeolocationPermissionShowPromptResponse(
//               allow: true, origin: origin);
//         },
//         onNavigationResponse: (controller, response) async {
//           return null;
//         },
//         onPermissionRequest: (controller, request) async {
//           return PermissionResponse(
//               resources: request.resources,
//               action: PermissionResponseAction.GRANT);
//         },
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           var uri = navigationAction.request.url!;
//
//           if (![
//             "http",
//             "https",
//             "file",
//             "chrome",
//             "data",
//             "javascript",
//             "about"
//           ].contains(uri.scheme)) {
//             if (await canLaunchUrl(uri)) {
//               await launchUrl(
//                 uri,
//               );
//               return NavigationActionPolicy.CANCEL;
//             }
//           }
//
//           return NavigationActionPolicy.ALLOW;
//         },
//         onLoadStop: (controller, url) async {
//           pullToRefreshController?.endRefreshing();
//           setState(() {
//             this.url = url.toString();
//           });
//         },
//         onReceivedError: (controller, request, error) {
//           pullToRefreshController?.endRefreshing();
//         },
//         onProgressChanged: (controller, progress) {
//           if (progress == 100) {
//             pullToRefreshController?.endRefreshing();
//           }
//           setState(() {
//             this.progress = progress / 100;
//           });
//         },
//         onUpdateVisitedHistory: (controller, url, isReload) {
//           setState(() {
//             this.url = url.toString();
//           });
//         },
//         onConsoleMessage: (controller, consoleMessage) {
//           print(consoleMessage);
//         },
//       ),
//     );
//   }
// }
