import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
        child: LoadingAnimationWidget.inkDrop(
        color: Colors.white,
        size: 200,
        ),
      )
    );
  }
}
