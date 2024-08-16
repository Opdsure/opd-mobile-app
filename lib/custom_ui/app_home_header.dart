import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHomeHeader extends StatelessWidget{
  final Widget? titleUi;
  const AppHomeHeader({super.key,
    this.titleUi
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleUi!,
          Row(
            children: [
              IconButton(onPressed: (){
                context.push('/home/wallet');
              }, icon: const ImageIcon(AssetImage('assets/images/wallet_icon.png'), size: 30,)),
              const SizedBox(
                width: 15.0,
              ),
              IconButton(onPressed: (){
                context.push('/home/notifications');
              }, icon: const ImageIcon(AssetImage('assets/images/bell_icon.png'), size: 30,)),
            ],
          )
        ],
      ),
    );
  }

}