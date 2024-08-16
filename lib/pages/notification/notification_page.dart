import 'package:flutter/material.dart';
import 'package:opdsure/pages/notification/notification_view.dart';
import 'package:opdsure/widget/opd_widget.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => NotificationController();
}

class NotificationController extends State<NotificationPage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NotificationView(this);

  void deleteNotification(String s) async {
    await OpdSure.of(context).client.deleteNotifications(s);
    setState(() {});
  }
}
