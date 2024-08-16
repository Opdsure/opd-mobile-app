import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/custom_ui/app_base_page.dart';
import 'package:opdsure/custom_ui/app_round_view.dart';
import 'package:opdsure/model/notifications/notification_model.dart';
import 'package:opdsure/pages/notification/notification_page.dart';

import '../../custom_ui/app_header.dart';
import '../../custom_ui/app_text_view.dart';
import '../../utils/common_methods.dart';
import '../../widget/opd_widget.dart';

class NotificationView extends StatelessWidget {
  final NotificationController controller;

  const NotificationView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      appHeader: AppHeader(headerName: 'Notifications'),
      childContent: FutureBuilder<NotificationModel>(
          future: OpdSure.of(context).client.getNotifications(),
          builder: (context, snapshot) {
            if(snapshot.data == null){
              return const Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else{
              return ListView.builder(
                  itemCount: snapshot.data!.data!.records!.length,
                  itemBuilder: (context, index) {
                    return AppRoundView(
                      isMargin: true,
                      corner: 10.0,
                      color: const Color(0x1A486AB3),
                      mChild: ListTile(
                        onTap: () async {
                        },
                        leading: Icon(Icons.notifications, color: AppConfig.colorSchemeSeed, size: 20,),
                        title: AppTextView(text: snapshot.data!.data!.records![index].message!,),
                        subtitle: AppTextView(text: CommonMethods.formatIsoDateString(snapshot.data!.data!.records![index].createdAt!, isTime: true, isAddTime: true), size: 10,),
                        trailing: IconButton(icon: Icon(Icons.close, color: AppConfig.colorSchemeSeed, size: 20,), onPressed: () {
                          controller.deleteNotification(snapshot.data!.data!.records![index].id!);
                        },),
                      ),
                    );
                  });
            }

          }
      ),
    );
  }
}
