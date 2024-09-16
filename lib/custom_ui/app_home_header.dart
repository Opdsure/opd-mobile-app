import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHomeHeader extends StatelessWidget{
  final Widget title;
  const AppHomeHeader({super.key,
    required this.title
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title,
              Row(
                children: [
                  IconButton(onPressed: (){
                    context.push('/home/wallet');
                  }, icon: const ImageIcon(AssetImage('assets/images/wallet_icon.png'), size: 20,)),
                  Stack(
                    children: [
                      IconButton(onPressed: (){
                        context.push('/home/notifications');
                      }, icon: const ImageIcon(AssetImage('assets/images/bell_icon.png'), size: 20,)),
                      Positioned(
                        right: 12,
                        top: 5,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}