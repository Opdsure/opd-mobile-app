import 'package:flutter/material.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/custom_ui/app_text_view.dart';
import 'package:opdsure/utils/common_methods.dart';


class ClaimCountTile extends StatelessWidget {
  final String title;
  final int count;
  const ClaimCountTile({required this.count, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffE7EDFF),
        border: Border.all(color: AppConfig.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextView(text: title, size: 14,fontWeight: FontWeight.w700,),

          AppTextView(text: count.toString(), size: 16,fontWeight: FontWeight.w400,),
        ],
      ),
    );
  }
}
