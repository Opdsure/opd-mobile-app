import 'package:flutter/cupertino.dart';

class AppHomeHeader extends StatelessWidget{
  final Widget? titleUi;
  AppHomeHeader({
    this.titleUi
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        titleUi!,
        Row(
          children: [
            Image.asset(
              'assets/images/wallet_icon.png',
              height: 30.0,
              width: 30.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Image.asset(
              'assets/images/bell_icon.png',
              height: 30.0,
              width: 30.0,
            ),
          ],
        )
      ],
    );
  }

}