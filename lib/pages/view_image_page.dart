// import 'package:flutter/cupertino.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:opdsure/custom_ui/app_base_page.dart';
// import 'package:opdsure/custom_ui/app_header.dart';
// import 'package:opdsure/utils/common_methods.dart';
//
// class ViewImagePage extends StatelessWidget{
//   final String headerName;
//   final String imageUrl;
//   const ViewImagePage({required this.headerName,required this.imageUrl, super.key});
//   @override
//   Widget build(BuildContext context) {
//     return AppBasePage(
//       appHeader: AppHeader(headerName: headerName,),
//       childContent: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           (imageUrl.contains('pdf'))?
//     PDFView(
//       filePath: imageUrl,
//       enableSwipe: true,
//       swipeHorizontal: true,
//       autoSpacing: false,
//       pageFling: false,
//       onRender: (_pages) {
//         setState(() {
//           pages = _pages;
//           isReady = true;
//         });
//       },
//       onError: (error) {
//         print(error.toString());
//       },
//       onPageError: (page, error) {
//         print('$page: ${error.toString()}');
//       },
//       onViewCreated: (PDFViewController pdfViewController) {
//         _controller.complete(pdfViewController);
//       },
//       onPageChanged: (int page, int total) {
//         print('page change: $page/$total');
//       },
//     )
//               :
//           Image.network(
//             imageUrl,
//           )
//         ],
//       ),
//     );
//   }
//
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';

class ViewImagePage extends StatefulWidget {
  final String headerName;
  final String imageUrl;

  const ViewImagePage({
    required this.headerName,
    required this.imageUrl,
    super.key,
  });

  @override
  State<ViewImagePage> createState() => _ViewImagePageState();
}

class _ViewImagePageState extends State<ViewImagePage> {
  String? localPDFPath;
  bool isLoading = false;
  int? pages = 0;
  bool isReady = false;
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  @override
  void initState() {
    super.initState();


    if (widget.imageUrl.toLowerCase().contains('.pdf')) {
      _downloadPDF(widget.imageUrl);
    }

    print("this is my image ${widget.imageUrl}");
  }

  Future<void> _downloadPDF(String url) async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        localPDFPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print("PDF download error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = widget.imageUrl.toLowerCase().contains('.pdf');

    return AppBasePage(
      appHeader: AppHeader(headerName: widget.headerName),
      childContent: Center(
        child: isPdf
            ? isLoading
            ? const CircularProgressIndicator()
            : localPDFPath == null
            ? const Text("Failed to load PDF.")
            : PDFView(
          filePath: localPDFPath,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: false,
          onRender: (_pages) {
            setState(() {
              pages = _pages;
              isReady = true;
            });
          },
          onError: (error) {
            print("PDF Error: $error");
          },
          onPageError: (page, error) {
            print("Page $page Error: $error");
          },
          onViewCreated: (controller) {
            _controller.complete(controller);
          },
          onPageChanged: (page, total) {
            print('Page changed: $page/$total');
          },
        )
            : Image.network(
          widget.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Text("Failed to load image.");
          },
        ),
      ),
    );
  }
}
