import 'package:flutter/cupertino.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_header.dart';
import 'package:opdsure/utils/common_methods.dart';

class ViewImagePage extends StatelessWidget{
  final String headerName;
  final String imageUrl;
  const ViewImagePage({required this.headerName,required this.imageUrl, super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBasePage(
      appHeader: AppHeader(headerName: headerName,),
      childContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
          )
        ],
      ),
    );
  }

}