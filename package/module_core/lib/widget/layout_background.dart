import 'package:flutter/material.dart';
import 'package:module_core/common/color.dart';
import 'package:module_core/common/lottie.dart';
import 'package:module_core/widget/mylottie.dart';

class LayoutBackground extends StatelessWidget {
  const LayoutBackground({super.key,required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColor.hitambackgroundstart,
                  MyColor.hitambackgroundend,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: SizedBox(
            
            height: 500,
            child: MylottieImpl(MyLottie.lottiekiri),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            
            height: 500,
            child: MylottieImpl(MyLottie.lottiekanan),
          ),
        ),
        Center(
          child: widget,
        )
      ],
    );
    
  }
}